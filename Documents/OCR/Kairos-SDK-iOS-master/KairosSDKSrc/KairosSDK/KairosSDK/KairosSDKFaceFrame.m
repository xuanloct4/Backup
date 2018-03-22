//
//  KARFaceFrame.m
//  TimeClock
//
//  Created by Tom Hutchinson on 24/05/2013.
//  Copyright (c) 2013 Kairos AR. All rights reserved.
//

#import "KairosSDKFaceFrame.h"

@implementation KairosSDKFaceFrame

- (id)init
{
    return [self initWithxMovement:0.0 yMovement:0.0 widthChange:0.0 heightChange:0.0];
}

- (id)initWithxMovement:(float)xMovement yMovement:(float)yMovement widthChange:(float)widthChange heightChange:(float)heightChange {
    self = [super init];
    if(self) {
        _xMovement = xMovement;
        _yMovement = yMovement;
        _widthChange = widthChange;
        _heightChange = heightChange;
    }
    return(self);
}

@end
