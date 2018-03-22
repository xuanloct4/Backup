//
//  RuntimeInvocation.m
//  SimpleFFPlayer
//
//  Created by loctv on 6/22/17.
//  Copyright © 2017 xuanloctn. All rights reserved.
//

#import "RuntimeInvocation.h"

@implementation RuntimeInvocation


+(id)initializeObjectType:(NSString *)objectType
           fromCharacters:(NSString *)characters {
    Class cl = NSClassFromString(objectType);
    //        id object = [[cl alloc] init];
    id object;
    
    if ([objectType isEqualToString:@"NSNumber"]) {
        //        if([characters containsString:@"."]){
        //            double doubleValue =[characters doubleValue];
        //            object = [NSNumber numberWithDouble:doubleValue];
        //        }else {
        //            long long longValue =[characters longLongValue];
        //            object = [NSNumber numberWithLongLong:longValue];
        //        }
        
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [formatter numberFromString:characters];
        if (strcmp([number objCType], @encode(double)) == 0) {
            double doubleValue =[characters doubleValue];
            object = [NSNumber numberWithDouble:doubleValue];
        } else if (strcmp([number objCType], @encode(long long)) == 0) {
            long long longValue =[characters longLongValue];
            object = [NSNumber numberWithLongLong:longValue];
        }
        
    }else {
        object = [[cl alloc] init];
    }
    
    return object;
}

+(id)invokeObject:(id)object
         selector:(NSString *)selectorName
     argumentList:(NSMutableArray *)args {
    SEL selector = NSSelectorFromString(selectorName);
//    if(args == nil || args.count == 0){
//        if ([object respondsToSelector:selector]) {
//            [object performSelector:selector];
//        }
//        return nil;
//    }
    NSInvocation *inv;
    id retValue;
    @try {
        NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
        inv = [NSInvocation invocationWithMethodSignature:methodSignature];
        [inv setSelector:selector];
        [inv setTarget:object];
        for (int i = 0; i <args.count; i++) {
            id arg = args[i];
            [inv setArgument:&arg atIndex:i+2];
        }
        [inv performSelector:@selector(invoke) withObject:nil];
        [inv getReturnValue:&retValue];
    } @catch(NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
//    @finally {
//        NSLog(@"Finally");
//    }
    
    return retValue;
}

+(id)invokeObjectWithClass:(NSString *)objectType
            withCharacters:(NSString *)characters
                  selector:(NSString *)selectorName
              argumentList:(NSMutableArray *)args {
    
    id object = [RuntimeInvocation initializeObjectType:objectType fromCharacters:characters];
    
    id retValue = [RuntimeInvocation invokeObject:object
                                         selector:selectorName
                                     argumentList:args];
    return retValue;
}

@end
