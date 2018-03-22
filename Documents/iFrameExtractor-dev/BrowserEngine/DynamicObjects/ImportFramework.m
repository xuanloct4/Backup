//
//  ImportFramework.m
//  SimpleFFPlayer
//
//  Created by loctv on 7/26/17.
//  Copyright © 2017 xuanloctn. All rights reserved.
//

#import "ImportFramework.h"

@implementation ImportFramework
+(void) importFrameworkPath:(NSString *)path
                       mode:(int)mode {
    const char *cString = [path cStringUsingEncoding:NSASCIIStringEncoding];
    //        void *handle = dlopen("System/Library/Frameworks/UIKit.framework/UIKit", RTLD_NOW);
    void *handle = dlopen(cString, mode);
    
    
    //    int     *iptr, (*fptr)(int);
    void     *iptr, (*fptr)();
    *(void **)(&fptr) = dlsym(handle, "my_function");
    //   fptr = dlsym(RTLD_SELF, "my_function");
    
    //    iptr = (int *)dlsym(handle, "my_object");
    /* invoke function, passing value of integer as a parameter */
    //     (*fpt95ư99-r)(*iptr);
    (*fptr)();
    
    if (handle) {
        if (0 != dlclose(handle)) {
            printf("dlclose failed! %s\n", dlerror());
        }
    } else {
        printf("dlopen failed! %s\n", dlerror());
    }
}
@end
