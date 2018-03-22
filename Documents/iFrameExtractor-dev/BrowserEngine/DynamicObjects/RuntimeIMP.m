//
//  RuntimeIMP.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/12/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "RuntimeIMP.h"

@implementation RuntimeIMP

-(void)addImplFromBlock{
    int (^impyBlock)(id, int, int) = ^(id _self, int a, int b)
    {
        return a+b;
    };
    // grab an instance of the class we'll modify next
    RuntimeIMP *a = [RuntimeIMP new];
    // create an IMP from the block
    int (*impyFunct)(id, SEL, int, int) = (void*) imp_implementationWithBlock(impyBlock);
    // call the block, call the imp. Note the argumentation differences
    NSLog(@"impyBlock: %d + %d = %d", 20, 22, impyBlock(nil, 20, 22));
    NSLog(@"impyFunct: %d + %d = %d", 20, 22, impyFunct(nil, NULL, 20, 22));
    
    // dynamically add the method to the class, then invoke it on the previously
    // created instance (or we could create the instance after adding, doesn't matter)
    class_addMethod([RuntimeIMP class], @selector(answerForThis:andThat:), (IMP)impyFunct, "i@:ii");
    NSLog(@"Method: %d + %d = %d", 20, 22, [a answerForThis:20 andThat:22]);
    
    // It is just a block;  grab some state (the selector & a variable)
    SEL _sel = @selector(boogityBoo:);
    float k = 5.0;
    IMP boo = imp_implementationWithBlock(^(id _self, float c) {
        NSLog(@"Executing [%@ -%@%f] %f",
              [_self class], NSStringFromSelector(_sel), c,
              c * k);
    });
    
    class_addMethod([RuntimeIMP class], _sel, boo, "v@:f");
    
    // call the method
    [a boogityBoo:3.1415];
}

IMP impOfCallingMethod(id lookupObject, SEL selector)
{
    NSUInteger returnAddress = (NSUInteger)__builtin_return_address(0);
    NSUInteger closest = 0;
    
    // Iterate over the class and all superclasses
    Class currentClass = object_getClass(lookupObject);
    while (currentClass)
    {
        // Iterate over all instance methods for this class
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        unsigned int i;
        for (i = 0; i < methodCount; i++)
        {
            // Ignore methods with different selectors
            if (method_getName(methodList[i]) != selector)
            {
                continue;
            }
            
            // If this address is closer, use it instead
            NSUInteger address = (NSUInteger)method_getImplementation(methodList[i]);
            if (address < returnAddress && address > closest)
            {
                closest = address;
            }
        }
        
        free(methodList);
        currentClass = class_getSuperclass(currentClass);
    }
    
    return (IMP)closest;
}

- (void)myMethodWithParam1:(int)someParameter andParam2:(int)otherParameter
{
    //    void *myImplementation = impOfCallingInstanceMethod([self class], _cmd);
    //
    //    // Add method to Dummy class (args explained below)
    //    class_addMethod([NSObject class], @selector(printHello), (IMP)myImplementation, "v@:");
    //
    //    NSObject* instance = [[NSObject alloc] init];
    //    SEL selector = NSSelectorFromString(@"printHello");
    //    if ([instance respondsToSelector:selector]){
    //        [instance performSelector:selector withObject:@"abc"];
    //        //[instance printHello];
    //    }
}
@end
