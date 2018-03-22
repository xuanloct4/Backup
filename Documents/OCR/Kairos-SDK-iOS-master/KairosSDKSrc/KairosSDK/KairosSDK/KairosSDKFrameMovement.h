//
//  KARFrameMovement.h
//  TimeClock
//
//  Created by Tom Hutchinson on 24/05/2013.
//  Copyright (c) 2013 Kairos AR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface KairosSDKFrameMovement : NSObject {
    NSMutableArray *facesArray;
    CGRect lastFaceRect;
}

- (BOOL)isMoving:(CGRect)newFaceRect;
- (void)resetPrevious;

@end