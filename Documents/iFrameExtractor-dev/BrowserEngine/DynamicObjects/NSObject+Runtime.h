//
//  NSObject+Runtime.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/10/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunTimeClass.h"

@interface NSObject (subclass)
+(Class) newSubclassNamed:(NSString *) name
                protocols:(Protocol **) protos
                    impls:(selBlockPair *) impls;
@end
