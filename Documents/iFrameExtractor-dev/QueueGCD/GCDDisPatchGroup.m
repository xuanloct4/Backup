//
//  GCDDisPatchGroup.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/11/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "GCDDisPatchGroup.h"

@implementation GCDDisPatchGroup
-(void)fetchConfigurationWithCompletion:(void (^)(NSError* error))completion
{
    // Define errors to be processed when everything is complete.
    // One error per service; in this example we'll have two
    __block NSError *configError = nil;
    __block NSError *preferenceError = nil;

//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t serialQueue = dispatch_queue_create("queue", 0);
    dispatch_apply(3, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        
        NSURL *url;
        switch (i) {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            default:
                break;
        }
    });
    
    // Create the dispatch group
        dispatch_group_t serviceGroup = dispatch_group_create();
    
    // Adding tasks to a dispatch group by
    dispatch_group_async(serviceGroup,serialQueue,^{
        // some work here
    });
    
    // Or using dispatch_group_enter dispatch_group_leave
    
    // Start the first service
    dispatch_group_enter(serviceGroup);
    [self startWithCompletion:^(NSURLResponse *results, NSError* error){
          NSLog(@"DispatchGroup_Enter.startWithCompletion1:");
        // Do something with the results
        configError = error;
        dispatch_group_leave(serviceGroup);
    }];
    NSLog(@"DispatchGroup_Leave.startWithCompletion1:");

    
    // Start the second service
    dispatch_group_enter(serviceGroup);
    [self startWithCompletion:^(NSURLResponse *results, NSError* error){
         NSLog(@"DispatchGroup_Enter.startWithCompletion2:");
        // Do something with the results
        preferenceError = error;
        dispatch_group_leave(serviceGroup);
    }];
     NSLog(@"DispatchGroup_Leave.startWithCompletion2:");
    
    
    // Acting when the group is finished
    dispatch_async(serialQueue,^{
    dispatch_group_wait(serviceGroup,DISPATCH_TIME_FOREVER);
    // Won't get here until everything has finished
        printf("Won't get here until everything has finished");
    });
                   
    dispatch_async(dispatch_get_main_queue(), ^{
        // Assess any errors
        NSError *overallError = nil;
        if (configError || preferenceError)
        {
            // Either make a new error or assign one of them to the overall error
            overallError = configError ?: preferenceError;
        }
        // Now call the final completion block
        completion(overallError);
    });
    
    // Or tell the group to run another block when the work is done
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        // Assess any errors
        NSError *overallError = nil;
        if (configError || preferenceError)
        {
            // Either make a new error or assign one of them to the overall error
            overallError = configError ?: preferenceError;
        }
        // Now call the final completion block
        completion(overallError);
    });
}

-(void)startWithCompletion:(void (^)(NSURLResponse *v, NSError* error))completion{
  // ...
    NSLog(@"startWithCompletion:");
    completion(self.response, self.error);
}
@end
