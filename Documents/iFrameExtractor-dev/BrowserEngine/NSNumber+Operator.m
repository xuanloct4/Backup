//
//  NSNumber+Operator.m
//  SimpleFFPlayer
//
//  Created by loctv on 6/19/17.
//  Copyright © 2017 xuanloctn. All rights reserved.
//

#import "NSNumber+Operator.h"

@implementation NSNumber(Operator)
-(NSNumber*)add:(NSNumber*)number{
    
    int a1 = self.intValue;
    int a2 = number.intValue;
    int a3 = a1 +a2;
    
    number = [NSNumber numberWithInt:a3];
    return  [NSNumber numberWithInt:a3];
}

-(NSNumber*)addNum1:(NSNumber*)number1
            addNum2:(NSNumber*)number2{
    NSNumber *num1 = [self add:number1];
    NSNumber *num2 = [num1 add:number2];
    return num2;
}

-(NSNumber*)addNum1:(NSNumber*)number1
            addNum2:(NSNumber*)number2
            addNum3:(NSNumber*)number3
            addNum4:(NSNumber*)number4{
    NSNumber *num1 = [self add:number1];
    NSNumber *num2 = [num1 add:number2];
    NSNumber *num3 = [num2 add:number3];
    NSNumber *num4 = [num3 add:number4];
    return num4;
}

-(NSNumber*)addInt1:(int)num1
            addInt2:(int)num2
{
 int a1 = self.intValue;
    a1 += num1;
    a1 += num2;
    return [NSNumber numberWithInt:a1];
}
@end
