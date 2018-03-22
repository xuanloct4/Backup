//
//  RunTimeClass.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/10/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "RunTimeClass.h"

@implementation RunTimeClass

 #pragma mark - Helper methods
+(NSString*)propName:(NSString*)name
{
    name = [name stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSRange r;
    r.length = name.length -1 ;
    r.location = 1;
    
    NSString* firstChar = [name stringByReplacingCharactersInRange:r withString:@""];
    
    if([firstChar isEqualToString:[firstChar lowercaseString]])
    {
        return name;
    }
    
    r.length = 1;
    r.location = 0;
    
    NSString* theRest = [name stringByReplacingCharactersInRange:r withString:@""];
    
    return [NSString stringWithFormat:@"%@%@", [firstChar lowercaseString] , theRest];
    
}

+(NSString*)setterName:(NSString*)name
{
    name = [self propName:name];
    
    NSRange r;
    r.length = name.length -1 ;
    r.location = 1;
    
    NSString* firstChar = [name stringByReplacingCharactersInRange:r withString:@""];
    
    r.length = 1;
    r.location = 0;
    
    NSString* theRest = [name stringByReplacingCharactersInRange:r withString:@""];
    
    return [NSString stringWithFormat:@"set%@%@", [firstChar uppercaseString] , theRest];
}


+(NSString*)propNameFromSetterName:(NSString*)name
{
    NSRange r;
    r.length = 3 ;
    r.location = 0;
    
    NSString* propName = [name stringByReplacingCharactersInRange:r withString:@""];
    
    return [self propName:propName];
}

+(NSString*)ivarName:(NSString*)name
{
    NSRange r;
    r.length = name.length -1 ;
    r.location = 1;
    
    NSString* firstChar = [name stringByReplacingCharactersInRange:r withString:@""].lowercaseString;
    
    if([firstChar isEqualToString:@"_"])
        return name;
    
    r.length = 1;
    r.location = 0;
    
    NSString* theRest = [name stringByReplacingCharactersInRange:r withString:@""];
    
    return [NSString stringWithFormat:@"_%@%@",firstChar, theRest];
}


#pragma mark - Getter:

NSObject *getter(id self, SEL _cmd)
{
    NSString* name = NSStringFromSelector(_cmd);
    NSString* ivarName = [self ivarName:name];
    Ivar ivar = class_getInstanceVariable([self class], [ivarName UTF8String]);
    return object_getIvar(self, ivar);
}

#pragma mark - Setter:
void setter(id self, SEL _cmd, NSObject *newObj)
{
    NSString* name = [self propNameFromSetterName:NSStringFromSelector(_cmd)];
    NSString* ivarName = [self ivarName:name];
    Ivar ivar = class_getInstanceVariable([self class], [ivarName UTF8String]);
    id oldObj = object_getIvar(self, ivar);
    if (![oldObj isEqual: newObj])
    {
        if(oldObj != nil)
//            [oldObj release];
        
        object_setIvar(self, ivar, newObj);
//        [newObj retain];
    }
}

 #pragma mark - Define method for creating the class.
+(NSDictionary*)buildClassFromDictionary:(NSArray*)propNames withName:(NSString*)className

{
    
    NSMutableDictionary* keys = [[NSMutableDictionary alloc]init];
    
    
    
    Class newClass = NSClassFromString(className);
    
    
    
    if(newClass == nil)
        
    {
        
        newClass = objc_allocateClassPair([NSObject class], [className UTF8String], 0);
        
        
        
        for(NSString* key in propNames)
            
        {
            
            NSString* propName = [self propName: key];
            
            NSString* iVarName = [self ivarName:propName];
            
            
            
            class_addIvar(newClass, [iVarName UTF8String] , sizeof(NSObject*), log2(sizeof(NSObject*)), @encode(NSObject));
            
            
            
            objc_property_attribute_t a1 = { "T", "@\"NSObject\"" };
            
            objc_property_attribute_t a2 = { "&", "" };
            
            objc_property_attribute_t a3 = { "N", "" };
            
            objc_property_attribute_t a4 = { "V", [iVarName UTF8String] };
            
            objc_property_attribute_t attrs[] = { a1, a2, a3, a4};
            
            
            
            class_addProperty(newClass, [propName UTF8String], attrs, 4);
            
            class_addMethod(newClass, NSSelectorFromString(propName), (IMP)getter, "@@:");
            
            class_addMethod(newClass, NSSelectorFromString([self setterName:propName]), (IMP)setter, "v@:@");
            
            
            
            [keys setValue:key forKey:propName];
            
        }
        
        
        
        objc_registerClassPair(newClass);
        
    }
    return keys;
    
}

+(Class) newSubclassNamed:(NSString *)name
                protocols:(Protocol **)protos
                    impls:(selBlockPair *)impls
{
    if (name == nil)
    {
        // basically create a random name
        name = [NSString stringWithFormat:@"%s_%i_%i", class_getName(self), arc4random(), arc4random()];
    }
    
    // allocated a new class as a subclass of self (so I could use this on a NSArray if I wanted)
    Class newClass = objc_allocateClassPair(self, [name UTF8String], 0);
    
    // add all of the protocols untill we hit null
    while (protos && *protos != NULL)
    {
        class_addProtocol(newClass, *protos);
        protos++;
    }
    
    // add all the impls till we hit null
    while (impls && impls->aSEL)
    {
        class_addMethod(newClass, impls->aSEL, imp_implementationWithBlock(impls->aBlock), "@@:*");
        impls++;
    }
    
    // register our class pair
    objc_registerClassPair(newClass);
    
    return newClass;
}

@end
