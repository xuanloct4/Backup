//
//  RunTimeClass.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/10/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/message.h>
#import <objc/NSObjCRuntime.h>
#import <objc/NSObject.h>
#import <objc/objc-api.h>
#import <objc/objc-auto.h>
#import <objc/objc-sync.h>
#import <objc/objc-exception.h>
#import <objc/objc.h>
#import <objc/runtime.h>


typedef struct selBlockPair { SEL aSEL; id (^__unsafe_unretained aBlock)(id, ...); } selBlockPair;
#define NIL_PAIR ((struct selBlockPair) { 0, 0 })
#define PAIR_LIST (struct selBlockPair [])
#define BLOCK_CAST (id (^)(id, ...))

@interface RunTimeClass : NSObject
#pragma mark - Helper methods
+(NSString*)propName:(NSString*)name;
+(NSString*)setterName:(NSString*)name;
+(NSString*)propNameFromSetterName:(NSString*)name;
+(NSString*)ivarName:(NSString*)name;


#pragma mark - Getter:
NSObject *getter(id self, SEL _cmd);

#pragma mark - Setter:
void setter(id self, SEL _cmd, NSObject *newObj);

#pragma mark - Define method for creating the class.
+(NSDictionary*)buildClassFromDictionary:(NSArray*)propNames withName:(NSString*)className;


+(Class) newSubclassNamed:(NSString *) name
                protocols:(Protocol **) protos
                    impls:(selBlockPair *) impls;

//-(void)printHello;
@end
