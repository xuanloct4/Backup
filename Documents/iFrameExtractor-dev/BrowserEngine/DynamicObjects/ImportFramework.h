//
//  ImportFramework.h
//  SimpleFFPlayer
//
//  Created by loctv on 7/26/17.
//  Copyright © 2017 xuanloctn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dlfcn.h>

@interface ImportFramework : NSObject
+(void) importFrameworkPath:(NSString *)path
                       mode:(int)mode;
@end
