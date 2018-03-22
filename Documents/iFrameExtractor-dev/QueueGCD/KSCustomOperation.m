//
//  KSCustomOperation.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/4/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "KSCustomOperation.h"


/***********************************************
 CUSTOM OPERATION IMPLEMENTATION
 **********************************************/
@implementation KSCustomOperation
-(id)initWithData:(id)dataDictionary
{
    if (self = [super init])
    {
        _mainDataDictionary = dataDictionary;
        executing = NO;
        finished = NO;
        
    }
    return self;
}

-(void)start
{
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)main
{
    //This is the method that will do the work
    @try {
        NSLog(@"Custom Operation - Main Method isMainThread?? ANS = %@",[NSThread isMainThread]? @"YES":@"NO");
        NSLog(@"Custom Operation - Main Method [NSThread currentThread] %@",[NSThread currentThread]);
        NSLog(@"Custom Operation - Main Method Try Block - Do Some work here");
        NSLog(@"Custom Operation - Main Method The data that was passed is %@",_mainDataDictionary);
        for (int i = 0; i<5; i++)
        {
            NSLog(@"i%d",i);
            sleep(1); //Never put sleep in production code until and unless the situation demands. A sleep is induced here to demonstrate a scenario that takes some time to complete
        }
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Catch the exception %@",[exception description]);
    }
    @finally {
        NSLog(@"Custom Operation - Main Method - Finally block");
    }
}

-(BOOL)isConcurrent
{
    return YES;    //Default is NO so overriding it to return YES;
}

-(BOOL)isExecuting{
    return executing;
}

-(BOOL)isFinished{
    return finished;
}
@end
