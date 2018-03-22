//
//  RuntimeInvocation.h
//  SimpleFFPlayer
//
//  Created by loctv on 6/22/17.
//  Copyright © 2017 xuanloctn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEObjectInitialization.h"

@interface RuntimeInvocation : NSObject

+(_Nonnull id)initializeObjectType:( NSString * _Nonnull)objectType
           fromCharacters:(NSString * _Nullable)characters;

+(_Nullable id)invokeObject:(id _Nonnull)object
         selector:(NSString *_Nonnull)selectorName
     argumentList:(NSMutableArray *_Nullable)args;

+(_Nullable id)invokeObjectWithClass:(NSString *_Nonnull)objectType
            withCharacters:(NSString *_Nullable)characters
                  selector:(NSString *_Nonnull)selectorName
              argumentList:(NSMutableArray *_Nullable)args;
@end
