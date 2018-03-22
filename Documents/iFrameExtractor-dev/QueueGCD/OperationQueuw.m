//
//  OperationQueuw.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/4/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "OperationQueuw.h"

@interface QueueExample: NSOperation
@end

@implementation QueueExample
//    //1
//    let photoRecord: PhotoRecord
//
//    //2
//    init(photoRecord: PhotoRecord) {
//        self.photoRecord = photoRecord
//    }

//3
- (void)main{
    //4
    if (self.isCancelled){
        return;
    }
    
    NSLog(@"QueueExample.main");
    
}
@end


@implementation OperationQueuw
- (void)viewDidLoad {
    [super viewDidLoad];
    //    OperationQueuw *q = [[OperationQueuw alloc] init];
    //    [q sampleCodeOne];
    //    [q sampleCodeTwo];
    //    [q sampleCodeThree];
    //    [q showCurrentTime];

    NSOperation *op = [[NSOperation alloc] init];
    op.queuePriority = NSOperationQueuePriorityVeryHigh;
    op.qualityOfService = NSQualityOfServiceUserInteractive;
    [op setCompletionBlock:^{
        NSLog(@"Op is executing");
    }];
    
    
    QueueExample *q = [[QueueExample alloc] init];
    NSOperation *op1 = [[NSOperation alloc] init];
    op1.queuePriority = NSOperationQueuePriorityVeryHigh;
    op1.qualityOfService = NSQualityOfServiceUserInitiated;
    [op1 setCompletionBlock:^{
        NSLog(@"Op1 is executing");
    }];
    //    [q addDependency:op1];
    //    [q start];
    
    //    // Main queue
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        NSLog(@"Main Queue");
    }];
    
    [op addDependency:op1];
    
    [mainQueue addOperation:op];
    [mainQueue addOperation:op1];
    [mainQueue addOperation:q];
    
    
    //    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    //    [myQueue addOperationWithBlock:^{
    //        // Background work
    //        NSLog(@"My Queue");
    //
    //        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //            // Main thread work (UI usually)
    //            NSLog(@"Main Queue");
    //        }];
    //    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - NSOperationQueue using NSInvocationOperation
-(void)sampleCodeOne
{
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Debasis",@"firstName",@"Das",@"lastName", nil];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testMethodOne:) object:dataDict];
    [operationQueue addOperation:invocationOperation];
    
}

-(void)testMethodOne:(id)obj
{
    NSLog(@"is testMethodOne running on main thread? ANS - %@",[NSThread isMainThread]? @"YES":@"NO");
    NSLog(@"obj %@",obj);
    //Do something using Obj or with Obj
}

#pragma mark - NSOperationQueue using NSBlockOperation
-(void)sampleCodeTwo
{
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    NSBlockOperation *blockCompletionOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"The block operation ended, Do something such as show a successmessage etc");
        //This the completion block operation
    }];
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        //This is the worker block operation
        [self methodOne];
    }];
    [blockCompletionOperation addDependency:blockOperation];
    [operationQueue addOperation:blockCompletionOperation];
    [operationQueue addOperation:blockOperation];
}

-(void)methodOne
{
    NSLog(@"is testMethodOne running on main thread? ANS - %@",[NSThread isMainThread]? @"YES":@"NO");
    for (int i = 0; i<5; i++)
    {
        NSLog(@"sleeps for 1 sec and i is %d",i);
        sleep(1);
    }
}

#pragma mark - NSOperationQueue using a Custom NSOperation
-(void)sampleCodeThree
{
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    KSCustomOperation *customOperation = [[KSCustomOperation alloc] initWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"Debasis",@"firstName",@"Das",@"lastName",nil]];
    //You can pass any object in the initWithData method. Here we are passing a NSDictionary Object
    
    NSBlockOperation *blockCompletionOperation = [NSBlockOperation blockOperationWithBlock:^{
        //This is the completion block that will get called when the custom operation work is completed.
        NSLog(@"Do Something here. Probably alert the user that the work is complete");
    }];
    
    customOperation.completionBlock =^{
        NSLog(@"Completed");
        NSLog(@"Operation Completion Block. Do something here. Probably alert the user that the work is complete");
        //This is another way of catching the Custom Operation completition.
        //In case you donot want to catch the completion using a block operation as state above. you can catch it here and remove the block operation and the dependency introduced in the next line of code
    };
    
    [blockCompletionOperation addDependency:customOperation];
    [operationQueue addOperation:blockCompletionOperation];
    [operationQueue addOperation:customOperation];
    //[customOperation start]; //Uncommenting this line of code will run the custom operation twice one using the NSOperationQueue and the other using the custom operations start method
}

#pragma mark - Updating UI Element from a secondary/background thread created from NSInvocationOperation
-(void)showCurrentTime
{
    NSOperationQueue * operationQueue = [NSOperationQueue new];
    NSInvocationOperation *operationOne = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(showTime) object:nil];
    [operationQueue addOperation:operationOne];
    
}

-(void)showTime
{
    // This method will be called on a new thread.
    // As UI elements are not supposed to be updated from a background thread and thus we do performSelectorOnMainThread to update the UI Elements
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSLog(@"Custom Operation - Main Method isMainThread?? ANS = %@",[NSThread isMainThread]? @"YES":@"NO");
    while (TRUE)
    {
        NSString *theTime = [timeFormat stringFromDate:[NSDate date]];
//        [self.systemTimeTextField performSelectorOnMainThread:@selector(setStringValue:) withObject:theTime waitUntilDone:YES];
         [self performSelectorOnMainThread:@selector(logTime:) withObject:theTime waitUntilDone:YES];
    }
}

-(void)logTime:(NSString *)time{
    NSLog(@"%@",time);
}

#pragma mark - Dispatch Block from a serial dispatch queue
-(void)sampleCodeFive
{
    dispatch_block_t myBlock = ^{
        int i = 0;          /* counter, to print numbers */
        for (i=0; i<10; i++)
        {
            NSLog(@"i is %d",i);
            sleep(1);
        }
    };
    // Create the queue
    dispatch_queue_t queue1 = dispatch_queue_create("com.concurrency.sampleQueue1", NULL);
    NSLog(@"%s",dispatch_queue_get_label(queue1));
    // Lets execute the block
    dispatch_async(queue1, myBlock);
    //dispatch_release(queue1); //No need to release in ARC
}

#pragma mark - Serial Dispatch Queue
-(void)sampleCodeSix
{
    NSLog(@"testDispatchQueues isMainThread %@",[NSThread isMainThread]? @"YES":@"NO");
    dispatch_queue_t serialQueue = dispatch_queue_create("com.example.MySerialQueue",NULL);
    dispatch_async(serialQueue,^{
        NSLog(@"%s",dispatch_queue_get_label(serialQueue));
        NSLog(@"Block 1 Do some work here");
        
    });
    NSLog(@"Do something else outside the blocks");
    
    dispatch_async(serialQueue,^{
        NSLog(@"%s",dispatch_queue_get_label(serialQueue));
        NSLog(@"Block 2 Do some more work here");
    });
    NSLog(@"Both blocks might or might not have completed. This might get printed before Block 2 is completed");
}

#pragma mark - Global Dispatch Queue
-(void)sampleCodeSeven
{
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(aQueue,^{
        NSLog(@"%s",dispatch_queue_get_label(aQueue));
        NSLog(@"This is the global Dispatch Queue");
    });
    
    dispatch_sync(aQueue,^{
        NSLog(@"%s",dispatch_queue_get_label(aQueue));
        for (int i =0; i<5;i++)
        {
            NSLog(@"i %d",i);
            sleep(1);
        }
    });
    
    dispatch_async(aQueue,^{
        NSLog(@"%s",dispatch_queue_get_label(aQueue));
        for (int j =0; j<5;j++)
        {
            NSLog(@"This is j %d",j);
            sleep(1);
        }
    });
}

@end
