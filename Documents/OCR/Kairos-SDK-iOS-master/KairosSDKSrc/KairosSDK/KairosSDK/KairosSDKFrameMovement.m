//
//  KARFrameMovement.m
//  TimeClock
//
//  Created by Tom Hutchinson on 24/05/2013.
//  Copyright (c) 2013 Kairos AR. All rights reserved.
//

#import "KairosSDKFrameMovement.h"
#import "KairosSDKFaceFrame.h"

#define maxChange 0.005

@implementation KairosSDKFrameMovement

-(id)init {
    if (self = [super init])  {
        facesArray = [[NSMutableArray alloc] init];
        [self resetPrevious];
    }
    return self;
}

//Reset all frames to fail (starting state)
- (void)resetPrevious {
    lastFaceRect = CGRectMake(0, 0, 0, 0);
    
    for (int i=0; i<4; i++) {
        KairosSDKFaceFrame *newFaceFrame = [[KairosSDKFaceFrame alloc] initWithxMovement:1.0 yMovement:1.0 widthChange:1.0 heightChange:1.0];
        
        [facesArray addObject:newFaceFrame];
    }
}

- (BOOL)isMoving:(CGRect)newFaceRect {
    [self addFace:newFaceRect];
    float totalXMovement = 0.0;
    float totalYMovement = 0.0;
    float totalWidthChange = 0.0;
    float totalHeightChange = 0.0;

    for (KairosSDKFaceFrame *faceFrame in facesArray) {
        totalXMovement = totalXMovement + faceFrame.xMovement;
        totalYMovement = totalYMovement + faceFrame.yMovement;
        totalWidthChange = totalWidthChange + faceFrame.widthChange;
        totalHeightChange = totalHeightChange + faceFrame.heightChange;
    }
    if ((totalXMovement > maxChange) || (totalYMovement > maxChange) || (totalWidthChange > maxChange) || (totalHeightChange > maxChange)) {
        return YES;
    }
    else {
    return NO;
    }
}

- (void)addFace:(CGRect)newFaceRect {
    [facesArray removeLastObject];
    //NSLog(@"ADD FACE");
    float movementX = [self calculateDifference:newFaceRect.origin.x :lastFaceRect.origin.x];
    float movementY = [self calculateDifference:newFaceRect.origin.y :lastFaceRect.origin.y];
    float widthChange = [self calculateDifference:newFaceRect.size.width :lastFaceRect.size.width];
    float heightChange = [self calculateDifference:newFaceRect.size.height :lastFaceRect.size.height];
    //NSLog(@"THIS WIDTH CHANGE: %f", widthChange);
    KairosSDKFaceFrame *newFaceFrame = [[KairosSDKFaceFrame alloc] initWithxMovement:movementX yMovement:movementY widthChange:widthChange heightChange:heightChange];
    
    [facesArray insertObject:newFaceFrame atIndex:0];
    
    lastFaceRect = newFaceRect;
}

//Calculate difference between last frame and this frame
- (float)calculateDifference:(float)newValue :(float)lastValue {
    float rawDifferance = newValue - lastValue;
    if (rawDifferance < 0.0) {
        return fabsf(rawDifferance);
    }
    
    else {
        return rawDifferance;
    }
}

@end
