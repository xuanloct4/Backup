//
//  InvocationForwarding.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/11/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "InvocationForwarding.h"


@implementation InvocationForwarding
@dynamic title, author;

- (id)init
{
    if ((self = [super init])) {
        data = [[NSMutableDictionary alloc] init];
        [data setObject:@"Tom Sawyer" forKey:@"title"];
        [data setObject:@"Mark Twain" forKey:@"author"];
    }
    return self;
}

//- (void)dealloc
//{
//    [data release];
//    [super dealloc];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
//    id surrogate = [[NSObject alloc] init];
//        NSMethodSignature* signature = [super methodSignatureForSelector:selector];
//        if (!signature) {
//            signature = [surrogate methodSignatureForSelector:selector];
//        }
//        return signature;
    
    
    NSString *sel = NSStringFromSelector(selector);
    if ([sel rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
//    id someOtherObject = [[NSObject alloc] init];
//    if ([someOtherObject respondsToSelector:
//         [invocation selector]]) {
//        [invocation invokeWithTarget:someOtherObject];
//    } else {
//        [super forwardInvocation:invocation];
//    }
    
    NSString *key = NSStringFromSelector([invocation selector]);
    if ([key rangeOfString:@"set"].location == 0) {
        key = [[key substringWithRange:NSMakeRange(3, [key length]-4)] lowercaseString];
        NSString *obj;
        [invocation getArgument:&obj atIndex:2];
        [data setObject:obj forKey:key];
    } else {
        NSString *obj = [data objectForKey:key];
        [invocation setReturnValue:&obj];
    }
}

@end
