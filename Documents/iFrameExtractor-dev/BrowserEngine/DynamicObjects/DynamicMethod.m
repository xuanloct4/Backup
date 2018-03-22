//
//  DynamicMethod.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/11/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "DynamicMethod.h"
#import <objc/runtime.h>

@implementation DynamicMethod

+ (BOOL) resolveInstanceMethod:(SEL)aSEL
{
    NSString *method = NSStringFromSelector(aSEL);
//   IMP imp = imp_implementationWithBlock(^(id me, BOOL firstParam, NSString* secondParam)
//                                                                     {
//                                                                         //Implementation goes in here
//                                                                         return @""; //something of type 'id'
//                                                                         
//                                                                     });
    if ([method hasPrefix:@"set"])
    {
        class_addMethod([self class], aSEL, (IMP) accessorSetter, "v@:@");
        return YES;
    }
    else
    {
        class_addMethod([self class], aSEL, (IMP) accessorGetter, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}

NSObject* accessorGetter(id self, SEL _cmd)
{
    NSString *method = NSStringFromSelector(_cmd);
    // Return the value of whatever key based on the method name
//    return [((EventItem *)self)-&amp;gt;valDict objectForKey:method];
 return [[self properties] valueForKey:method];
}


void accessorSetter(id self, SEL _cmd, NSObject* newValue)
{
    NSString *method = NSStringFromSelector(_cmd);
    
    // remove set
//    NSString *anID = [[method stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@&amp;quot;&amp;quot;]
//                      stringByReplacingOccurrencesOfString:@"set" withString:@""];
//    NSString *firstLowerChar = [[anID substringToIndex:1] lowercaseString];
//    anID = [anID stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLowerChar];
//    // Set value of the key anID to newValue
//    [((EventItem *)self)-&amp;gt;valDict setValue:newValue forKey:anID];
    
    id value = [newValue copy];
    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    // delete "set" and ":" and lowercase first letter
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
    NSString *firstChar = [key substringToIndex:1];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
    
    [[self properties] setValue:value forKey:key];
    
}
@end
