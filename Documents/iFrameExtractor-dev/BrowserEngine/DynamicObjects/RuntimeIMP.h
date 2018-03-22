//
//  RuntimeIMP.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/12/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RuntimeIMP : NSObject
- (int)answerForThis:(int)a andThat:(int)b;
- (void)boogityBoo:(float)c;

//IMP impOfCallingMethod(id lookupObject, SEL selector);
- (void)myMethodWithParam1:(int)someParameter andParam2:(int)otherParameter;
@end
