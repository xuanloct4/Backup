//
//  KARFaceFrame.h
//  TimeClock
//
//  Created by Tom Hutchinson on 24/05/2013.
//  Copyright (c) 2013 Kairos AR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KairosSDKFaceFrame : NSObject

@property (nonatomic) float xMovement;
@property (nonatomic) float yMovement;
@property (nonatomic) float widthChange;
@property (nonatomic) float heightChange;

- (id)initWithxMovement:(float)xMovement yMovement:(float)yMovement widthChange:(float)widthChange heightChange:(float)heightChange;

@end
