//
//  Utilities.m
//  SimpleFFPlayer
//
//  Created by  jefby on 16/1/13.
//  Copyright © 2016年 jefby. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end
