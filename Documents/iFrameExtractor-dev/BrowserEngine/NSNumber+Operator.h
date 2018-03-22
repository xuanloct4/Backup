//
//  NSNumber+Operator.h
//  SimpleFFPlayer
//
//  Created by loctv on 6/19/17.
//  Copyright © 2017 xuanloctn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(Operator)
-(NSNumber*)add:(NSNumber*)number;
-(NSNumber*)addNum1:(NSNumber*)number1
addNum2:(NSNumber*)number2;
-(NSNumber*)addNum1:(NSNumber*)number1
            addNum2:(NSNumber*)number2
            addNum3:(NSNumber*)number3
            addNum4:(NSNumber*)number4;
-(NSNumber*)addInt1:(int)num1
            addInt2:(int)num2;
@end
