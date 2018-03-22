/*
 * Copyright (c) 2012-2013, 2015 Apple Inc. All rights reserved.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. The rights granted to you under the License
 * may not be used to create, or enable the creation or redistribution of,
 * unlawful or unlicensed copies of an Apple operating system, or to
 * circumvent, violate, or enable the circumvention or violation of, any
 * terms of an Apple operating system software license agreement.
 *
 * Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_END@
 */


/*
 * Corpses Overview
 * ================
 * 
 * A corpse is a state of process that is past the point of its death. This means that process has
 * completed all its termination operations like releasing file descriptors, mach ports, sockets and
 * other constructs used to identify a process. For all the processes this mimics the behavior as if
 * the process has died and no longer available by any means.
 * 
 * Why do we need Corpses?
 * -----------------------
 * For crash inspection we need to inspect the state and data that is associated with process so that
 * crash reporting infrastructure can build backtraces, find leaks etc. For example a crash
 * 
 * Corpses functionality in kernel
 * ===============================
 * The corpse functionality is an extension of existing exception reporting mechanisms we have. The
 * exception_triage calls will try to deliver the first round of exceptions allowing
 * task/debugger/ReportCrash/launchd level exception handlers to  respond to exception. If even after
 * notification the exception is not handled, then the process begins the death operations and during
 * proc_prepareexit, we decide to create a corpse for inspection. Following is a sample run through
 * of events and data shuffling that happens when corpses is enabled.
 * 
 *   * a process causes an exception during normal execution of threads.
 *   * The exception generated by either mach(e.g GUARDED_MARCHPORT) or bsd(eg SIGABORT, GUARDED_FD
 *     etc) side is passed through the exception_triage() function to follow the thread -> task -> host
 *     level exception handling system. This set of steps are same as before and allow for existing
 *     crash reporting systems (both internal and 3rd party) to catch and create reports as required.
 *   * If above exception handling returns failed (when nobody handles the notification), then the
 *     proc_prepareexit path has logic to decide to create corpse.
 *   * The task_mark_corpse function allocates userspace vm memory and attaches the information
 *     kcdata_descriptor_t to task->corpse_info field of task.
 *     - All the task's threads are marked with the "inspection" flag which signals the termination
 *       daemon to not reap them but hold until they are being inspected.
 *     - task flags t_flags reflect the corpse bit and also a PENDING_CORPSE bit. PENDING_CORPSE
 *       prevents task_terminate from stripping important data from task.
 *     - It marks all the threads to terminate and return to AST for termination.
 *     - The allocation logic takes into account the rate limiting policy of allowing only
 *       TOTAL_CORPSES_ALLOWED in flight.
 *   * The proc exit threads continues and collects required information in the allocated vm region.
 *     Once complete it marks itself for termination.
 *   * In the thread_terminate_self(), the last thread to enter will do a call to proc_exit().
 *     Following this is a check to see if task is marked for corpse notification and will
 *     invoke the the task_deliver_crash_notification().
 *   * Once EXC_CORPSE_NOTIFY is delivered, it removes the PENDING_CORPSE flag from task (and
 *     inspection flag from all its threads) and allows task_terminate to go ahead and continue
 *     the mach task termination process.
 *   * ASIDE: The rest of the threads that are reaching the thread_terminate_daemon() with the
 *     inspection flag set are just bounced to another holding queue (crashed_threads_queue).
 *     Only after the corpse notification these are pulled out from holding queue and enqueued
 *     back to termination queue
 * 
 * 
 * Corpse info format
 * ==================
 * The kernel (task_mark_corpse()) makes a vm allocation in the dead task's vm space (with tag
 *     VM_MEMORY_CORPSEINFO (80)). Within this memory all corpse information is saved by various
 *     subsystems like
 *   * bsd proc exit path may write down pid, parent pid, number of file descriptors etc
 *   * mach side may append data regarding ledger usage, memory stats etc
 * See detailed info about the memory structure and format in kern_cdata.h documentation.
 * 
 * Configuring Corpses functionality
 * =================================
 *   boot-arg: -no_corpses disables the corpse generation. This can be added/removed without affecting
 *     any other subsystem.
 *   TOTAL_CORPSES_ALLOWED : (recompilation required) - Changing this number allows for controlling
 *     the number of corpse instances to be held for inspection before allowing memory to be reclaimed
 *     by system.
 *   CORPSEINFO_ALLOCATION_SIZE: is the default size of vm allocation. If in future there is much more
 *     data to be put in, then please re-tune this parameter.
 * 
 * Debugging/Visibility
 * ====================
 *   * lldbmacros for thread and task summary are updated to show "C" flag for corpse task/threads.
 *   * there are macros to see list of threads in termination queue (dumpthread_terminate_queue)
 *     and holding queue (dumpcrashed_thread_queue).
 *   * In case of corpse creation is disabled of ignored then the system log is updated with
 *     printf data with reason.
 * 
 * Limitations of Corpses
 * ======================
 *   With holding off memory for inspection, it creates vm pressure which might not be desirable
 *   on low memory devices. There are limits to max corpses being inspected at a time which is
 *   marked by TOTAL_CORPSES_ALLOWED.
 * 
 */


#include <kern/assert.h>
#include <mach/mach_types.h>
#include <mach/boolean.h>
#include <mach/vm_param.h>
#include <kern/kern_types.h>
#include <kern/mach_param.h>
#include <kern/thread.h>
#include <kern/task.h>
#include <corpses/task_corpse.h>
#include <kern/kalloc.h>
#include <kern/kern_cdata.h>
#include <mach/mach_vm.h>

#if CONFIG_MACF
#include <security/mac_mach_internal.h>
#endif

/*
 * Exported interfaces
 */
#include <mach/task_server.h>

unsigned long  total_corpses_count = 0;
unsigned long  total_corpses_created = 0;
boolean_t corpse_enabled_config = TRUE;

/* bootarg to turn on corpse forking for EXC_RESOURCE */
int exc_via_corpse_forking = 1;

/* bootarg to unify corpse blob allocation */
int unify_corpse_blob_alloc = 1;

/* bootarg to generate corpse for fatal high memory watermark violation */
int corpse_for_fatal_memkill = 1;

kcdata_descriptor_t task_get_corpseinfo(task_t task);
kcdata_descriptor_t task_crashinfo_alloc_init(mach_vm_address_t crash_data_p, unsigned size, int get_corpseref, unsigned flags);
kern_return_t task_crashinfo_destroy(kcdata_descriptor_t data, int release_corpseref);
static kern_return_t task_crashinfo_get_ref();
static kern_return_t task_crashinfo_release_ref();
extern int IS_64BIT_PROCESS(void *);
extern void gather_populate_corpse_crashinfo(void *p, void *crash_info_ptr, mach_exception_data_type_t code, mach_exception_data_type_t subcode, uint64_t *udata_buffer, int num_udata);
extern void *proc_find(int pid);
extern int proc_rele(void *p);


void corpses_init(){
	char temp_buf[20];
	int exc_corpse_forking;
	int corpse_blob_alloc;
	int fatal_memkill;
	if (PE_parse_boot_argn("-no_corpses", temp_buf, sizeof(temp_buf))) {
		corpse_enabled_config = FALSE;
	}
	if (PE_parse_boot_argn("exc_via_corpse_forking", &exc_corpse_forking, sizeof(exc_corpse_forking))) {
		exc_via_corpse_forking = exc_corpse_forking;
	}
	if (PE_parse_boot_argn("unify_corpse_blob_alloc", &corpse_blob_alloc, sizeof(corpse_blob_alloc))) {
		unify_corpse_blob_alloc = corpse_blob_alloc;
	}
	if (PE_parse_boot_argn("corpse_for_fatal_memkill", &fatal_memkill, sizeof(fatal_memkill))) {
		corpse_for_fatal_memkill = fatal_memkill;
	}
}

/*
 * Routine: corpses_enabled
 * returns FALSE if not enabled
 */
boolean_t corpses_enabled()
{
	return corpse_enabled_config;
}

/*
 * Routine: task_crashinfo_get_ref()
 *          Grab a slot at creating a corpse.
 * Returns: KERN_SUCCESS if the policy allows for creating a corpse.
 */
kern_return_t task_crashinfo_get_ref()
{
	unsigned long counter = total_corpses_count;
	counter = OSIncrementAtomic((SInt32 *)&total_corpses_count);
	if (counter >= TOTAL_CORPSES_ALLOWED) {
		OSDecrementAtomic((SInt32 *)&total_corpses_count);
		return KERN_RESOURCE_SHORTAGE;
	}
	OSIncrementAtomicLong((volatile long *)&total_corpses_created);
	return KERN_SUCCESS;
}

/*
 * Routine: task_crashinfo_release_ref
 *          release the slot for corpse being used.
 */
kern_return_t task_crashinfo_release_ref()
{
	unsigned long __assert_only counter;
	counter =	OSDecrementAtomic((SInt32 *)&total_corpses_count);
	assert(counter > 0);
	return KERN_SUCCESS;
}


kcdata_descriptor_t task_crashinfo_alloc_init(mach_vm_address_t crash_data_p, unsigned size, int get_corpseref, unsigned flags)
{
	if(get_corpseref && KERN_SUCCESS != task_crashinfo_get_ref()) {
		return NULL;
	}

	return kcdata_memory_alloc_init(crash_data_p, TASK_CRASHINFO_BEGIN, size, flags);
}


/*
 * Free up the memory associated with task_crashinfo_data
 */
kern_return_t task_crashinfo_destroy(kcdata_descriptor_t data, int release_corpseref)
{
	if (!data) {
		return KERN_INVALID_ARGUMENT;
	}

	if (release_corpseref)
		task_crashinfo_release_ref();
	return kcdata_memory_destroy(data);
}

/*
 * Routine: task_get_corpseinfo
 * params: task - task which has corpse info setup.
 * returns: crash info data attached to task.
 *          NULL if task is null or has no corpse info
 */
kcdata_descriptor_t task_get_corpseinfo(task_t task)
{
	kcdata_descriptor_t retval = NULL;
	if (task != NULL){
		retval = task->corpse_info;
	}
	return retval;
}

/*
 * Routine: task_add_to_corpse_task_list
 * params: task - task to be added to corpse task list
 * returns: None.
 */
void
task_add_to_corpse_task_list(task_t corpse_task)
{
	lck_mtx_lock(&tasks_corpse_lock);
	queue_enter(&corpse_tasks, corpse_task, task_t, corpse_tasks);
	lck_mtx_unlock(&tasks_corpse_lock);
}

/*
 * Routine: task_remove_from_corpse_task_list
 * params: task - task to be removed from corpse task list
 * returns: None.
 */
void
task_remove_from_corpse_task_list(task_t corpse_task)
{
	lck_mtx_lock(&tasks_corpse_lock);
	queue_remove(&corpse_tasks, corpse_task, task_t, corpse_tasks);
	lck_mtx_unlock(&tasks_corpse_lock);
}

/*
 * Routine: task_purge_all_corpses
 * params: None.
 * returns: None.
 */
void
task_purge_all_corpses(void)
{
	task_t task;

	printf("Purging corpses......\n\n");

	lck_mtx_lock(&tasks_corpse_lock);
	/* Iterate through all the corpse tasks and clear all map entries */
	queue_iterate(&corpse_tasks, task, task_t, corpse_tasks) {
		vm_map_remove(task->map,
		      task->map->min_offset,
		      task->map->max_offset,
		      /* no unnesting on final cleanup: */
		      VM_MAP_REMOVE_NO_UNNESTING);
	}

	lck_mtx_unlock(&tasks_corpse_lock);
}

/*
 * Routine: task_generate_corpse
 * params: task - task to fork a corpse
 *         corpse_task - task port of the generated corpse
 * returns: KERN_SUCCESS on Success.
 *          KERN_FAILURE on Failure.
 *          KERN_NO_SUPPORTED on corpse disabled.
 *          KERN_RESOURCE_SHORTAGE on memory alloc failure or reaching max corpse.
 */
kern_return_t
task_generate_corpse(
	task_t task,
	ipc_port_t *corpse_task_port)
{
	task_t new_task;
	kern_return_t kr;
	thread_t thread, th_iter;
	ipc_port_t corpse_port;
	ipc_port_t old_notify;

	if (task == kernel_task || task == TASK_NULL || task == current_task()) {
		return KERN_INVALID_ARGUMENT;
	}

	task_lock(task);
	if (task_is_a_corpse_fork(task)) {
		task_unlock(task);
		return KERN_INVALID_ARGUMENT;
	}
	task_unlock(task);

	/* Generate a corpse for the given task, will return with a ref on corpse task */
	kr = task_generate_corpse_internal(task, &new_task, &thread, 0, 0);
	if (kr != KERN_SUCCESS) {
		return kr;
	}
	assert(thread == THREAD_NULL);

	/* wait for all the threads in the task to terminate */
	task_lock(new_task);
	task_wait_till_threads_terminate_locked(new_task);

	/* Reset thread ports of all the threads in task */
	queue_iterate(&new_task->threads, th_iter, thread_t, task_threads)
	{
		/* Do not reset the thread port for inactive threads */
		if (th_iter->corpse_dup == FALSE) {
			ipc_thread_reset(th_iter);
		}
	}
	task_unlock(new_task);

	/* transfer the task ref to port and arm the no-senders notification */
	corpse_port = convert_task_to_port(new_task);
	assert(IP_NULL != corpse_port);

	ip_lock(corpse_port);
	assert(ip_active(corpse_port));
	ipc_port_nsrequest(corpse_port, corpse_port->ip_mscount, ipc_port_make_sonce_locked(corpse_port), &old_notify);
	/* port unlocked */

	assert(IP_NULL == old_notify);
	*corpse_task_port = corpse_port;
	return KERN_SUCCESS;
}

/*
 * Routine: task_enqueue_exception_with_corpse
 * params: task - task to generate a corpse and enqueue it
 *         code - exception code to be enqueued
 *         codeCnt - code array count - code and subcode
 */
void
task_enqueue_exception_with_corpse(
	task_t task,
	mach_exception_data_t code,
	mach_msg_type_number_t codeCnt)
{
	task_t new_task = TASK_NULL;
	thread_t thread = THREAD_NULL;
	kern_return_t kr;

	if (codeCnt < 2) {
		return;
	}

	/* Generate a corpse for the given task, will return with a ref on corpse task */
	kr = task_generate_corpse_internal(task, &new_task, &thread, code[0], code[1]);
	if (kr != KERN_SUCCESS) {
		return;
	}

	assert(thread != THREAD_NULL);
	assert(new_task != TASK_NULL);
	thread_exception_enqueue(new_task, thread);

	return;
}

/*
 * Routine: task_generate_corpse_internal
 * params: task - task to fork a corpse
 *         corpse_task - task of the generated corpse
 *         exc_thread - equivalent thread in corpse enqueuing exception
 *         code - mach exception code to be passed in corpse blob
 *         subcode - mach excpetion subcode to be passed in corpse blob
 * returns: KERN_SUCCESS on Success.
 *          KERN_FAILURE on Failure.
 *          KERN_NO_SUPPORTED on corpse disabled.
 *          KERN_RESOURCE_SHORTAGE on memory alloc failure or reaching max corpse.
 */
kern_return_t
task_generate_corpse_internal(
	task_t task,
	task_t *corpse_task,
	thread_t *exc_thread,
	mach_exception_data_type_t code,
	mach_exception_data_type_t subcode)
{
	task_t new_task = TASK_NULL;
	thread_t thread = THREAD_NULL;
	thread_t thread_next = THREAD_NULL;
	kern_return_t kr;
	struct proc *p = NULL;
	int is64bit;
	int t_flags;
	uint64_t *udata_buffer = NULL;
	int size = 0;
	int num_udata = 0;
	boolean_t release_corpse_ref = FALSE;

	if (!corpses_enabled()) {
		return KERN_NOT_SUPPORTED;
	}

	kr = task_crashinfo_get_ref();
	if (kr != KERN_SUCCESS) {
		return kr;
	}
	release_corpse_ref = TRUE;

	/* Having a task reference does not guarantee a proc reference */
	p = proc_find(task_pid(task));
	if (p == NULL) {
		kr = KERN_INVALID_TASK;
		goto error_task_generate_corpse;
	}

	is64bit = IS_64BIT_PROCESS(p);
	t_flags = TF_CORPSE_FORK | TF_PENDING_CORPSE | TF_CORPSE | (is64bit ? TF_64B_ADDR : TF_NONE);

	/* Create a task for corpse */
	kr = task_create_internal(task,
				NULL,
				TRUE,
				is64bit,
				t_flags,
				TPF_NONE,
				&new_task);
	if (kr != KERN_SUCCESS) {
		goto error_task_generate_corpse;
	}

	/* Create and copy threads from task, returns a ref to thread */
	kr = task_duplicate_map_and_threads(task, p, new_task, &thread,
				is64bit, &udata_buffer, &size, &num_udata);
	if (kr != KERN_SUCCESS) {
		goto error_task_generate_corpse;
	}

	kr = task_collect_crash_info(new_task, p, TRUE);
	if (kr != KERN_SUCCESS) {
		goto error_task_generate_corpse;
	}

	/* The corpse_info field in task in initialized, call to task_deallocate will drop corpse ref */
	release_corpse_ref = FALSE;

	kr = task_start_halt(new_task);
	if (kr != KERN_SUCCESS) {
		goto error_task_generate_corpse;
	}

	/* terminate the ipc space */
	ipc_space_terminate(new_task->itk_space);

	/* Populate the corpse blob, use the proc struct of task instead of corpse task */
	gather_populate_corpse_crashinfo(p, task_get_corpseinfo(new_task), code, subcode, udata_buffer, num_udata);

	/* Add it to global corpse task list */
	task_add_to_corpse_task_list(new_task);

	*corpse_task = new_task;
	*exc_thread = thread;

error_task_generate_corpse:
	/* Release the proc reference */
	if (p != NULL) {
		proc_rele(p);
	}

	if (kr != KERN_SUCCESS) {
		if (thread != THREAD_NULL) {
			thread_deallocate(thread);
		}
		if (new_task != TASK_NULL) {
			task_lock(new_task);
			/* Terminate all the other threads in the task. */
			queue_iterate(&new_task->threads, thread_next, thread_t, task_threads)
			{
				thread_terminate_internal(thread_next);
			}
			/* wait for all the threads in the task to terminate */
			task_wait_till_threads_terminate_locked(new_task);
			task_unlock(new_task);

			task_clear_corpse(new_task);
			task_terminate_internal(new_task);
			task_deallocate(new_task);
		}
		if (release_corpse_ref) {
			task_crashinfo_release_ref();
		}
	}
	/* Free the udata buffer allocated in task_duplicate_map_and_threads */
	if (udata_buffer != NULL) {
		kfree(udata_buffer, size);
	}

	return kr;
}

/*
 * Routine: task_map_corpse_info
 * params: task - Map the corpse info in task's address space
 *         corpse_task - task port of the corpse
 *         kcd_addr_begin - address of the mapped corpse info
 *         kcd_addr_begin - size of the mapped corpse info
 * returns: KERN_SUCCESS on Success.
 *          KERN_FAILURE on Failure.
 *          KERN_INVALID_ARGUMENT on invalid arguments.
 * Note: Temporary function, will be deleted soon.
 */
kern_return_t
task_map_corpse_info(
	task_t task,
	task_t corpse_task,
	vm_address_t *kcd_addr_begin,
	uint32_t *kcd_size)
{
	kern_return_t kr;
	mach_vm_address_t kcd_addr_begin_64;
	mach_vm_size_t size_64;

	kr = task_map_corpse_info_64(task, corpse_task, &kcd_addr_begin_64, &size_64);
	if (kr != KERN_SUCCESS) {
		return kr;
	}

	*kcd_addr_begin = (vm_address_t)kcd_addr_begin_64;
	*kcd_size = (uint32_t) size_64;
	return KERN_SUCCESS;
}

/*
 * Routine: task_map_corpse_info_64
 * params: task - Map the corpse info in task's address space
 *         corpse_task - task port of the corpse
 *         kcd_addr_begin - address of the mapped corpse info (takes mach_vm_addess_t *)
 *         kcd_addr_begin - size of the mapped corpse info (takes mach_vm_size_t *)
 * returns: KERN_SUCCESS on Success.
 *          KERN_FAILURE on Failure.
 *          KERN_INVALID_ARGUMENT on invalid arguments.
 */
kern_return_t
task_map_corpse_info_64(
	task_t task,
	task_t corpse_task,
	mach_vm_address_t *kcd_addr_begin,
	mach_vm_size_t *kcd_size)
{
	kern_return_t kr;
	mach_vm_offset_t crash_data_ptr = 0;
	mach_vm_size_t size = CORPSEINFO_ALLOCATION_SIZE;

	if (task == TASK_NULL || task_is_a_corpse_fork(task)) {
		return KERN_INVALID_ARGUMENT;
	}

	if (corpse_task == TASK_NULL || !task_is_a_corpse(corpse_task) ||
	    corpse_task->corpse_info == NULL || corpse_task->corpse_info_kernel == NULL) {
		return KERN_INVALID_ARGUMENT;
	}
	kr = mach_vm_allocate(task->map, &crash_data_ptr, size,
			(VM_MAKE_TAG(VM_MEMORY_CORPSEINFO) | VM_FLAGS_ANYWHERE));
	if (kr != KERN_SUCCESS) {
		return kr;
	}
	copyout(corpse_task->corpse_info_kernel, crash_data_ptr, size);
	*kcd_addr_begin = crash_data_ptr;
	*kcd_size = size;

	return KERN_SUCCESS;
}
