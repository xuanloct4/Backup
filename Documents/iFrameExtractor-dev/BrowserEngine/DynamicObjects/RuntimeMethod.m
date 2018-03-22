//
//  RuntimeMethod.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/10/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "RuntimeMethod.h"

@implementation RuntimeMethod

void newMethod(id self, SEL _cmd, id object)
{
    NSString *_message = [NSString stringWithFormat:@"Hello from a dynamically added method! (self=%p), (object=%@)\n", self,object];
    const char *message = [_message cStringUsingEncoding:NSUTF8StringEncoding];
    printf("%s", message);
}

+ (void)load {
    // Add method to Dummy class (args explained below)
    class_addMethod([RunTimeClass class], @selector(printHello), (IMP)newMethod, "v@:");
    
    RunTimeClass* instance = [[RunTimeClass alloc] init];
    SEL selector = NSSelectorFromString(@"printHello");
    if ([instance respondsToSelector:selector]){
        [instance performSelector:selector withObject:@"abc"];
         //[instance printHello];
    }
}

@end
