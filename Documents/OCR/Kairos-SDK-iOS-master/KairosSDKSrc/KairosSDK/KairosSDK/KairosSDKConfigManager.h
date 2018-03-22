//
//  KARConfigManager.h
//  TimeClock
//
//  Created by Eric Turner on 3/31/14.
//  Copyright (c) 2014 Kairos AR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

//#import "KARClientConfig.h"
//#import "onlineStatus.h"

@interface KairosSDKConfigManager : NSObject

//@property (strong, nonatomic) KARClientConfig *clientConfig;

@property (strong, nonatomic) NSString *prefilledActivationCode;

@property (strong, nonatomic) NSString *facialrecTransactionId;

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (assign, nonatomic) CGFloat faceRoll;

@property (assign, nonatomic) CGFloat faceYaw;

@property (assign, nonatomic) int numberOfLivenessDetections;

@property (assign, nonatomic) int requiredLivenessDetections;

@property (assign, nonatomic) int minLengthOfBlink;

@property (assign, nonatomic) int minLengthOfSmile;

@property (assign, nonatomic) int minFramesBetweenBlinks;

@property (assign, nonatomic) int minFramesBetweenSmiles;

@property (assign, nonatomic) int minMessageTime;

@property (assign, nonatomic) int maxMessageTime;

@property (assign, nonatomic) BOOL canShowFaceDetectBox;

@property (assign, nonatomic) BOOL canDetectFaces;

@property (strong, nonatomic) NSDate *lastMessageStartedAt;

@property (strong, nonatomic) NSDate *lastSupportingPhotoTakenAt;

@property (assign, nonatomic) int supportingPhotoInterval;

@property (strong, nonatomic) NSMutableArray *supportingPhotos;

@property (assign, nonatomic) CGPoint lastFaceCenterPoint;

@property (assign, nonatomic) int unstillFrameCounter;

@property (assign, nonatomic) BOOL grayscaleStillsEnabled;

@property (strong, nonatomic) UIColor * faceBoxColorValid;

@property (strong, nonatomic) UIColor * faceBoxColorInvalid;

@property (assign, nonatomic) BOOL croppingEnabled;

@property (strong, nonatomic) UIImage *capturedImage;

@property (assign, nonatomic) CGFloat showImageCaptureViewAnimationDuration;

@property (assign, nonatomic) CGFloat hideImageCaptureViewAnimationDuration;

@property (assign, nonatomic) NSUInteger showImageCaptureViewTransitionType;

@property (assign, nonatomic) NSUInteger hideImageCaptureViewTransitionType;

@property (assign, nonatomic) CGFloat faceBoxBorderThickness;

@property (assign, nonatomic) CGFloat faceBoxBorderOpacity;

@property (assign, nonatomic) BOOL shutterSoundEnabled;

@property (assign, nonatomic) BOOL flashEnabled;

@property (assign, nonatomic) BOOL errorMessagesEnabled;

@property (strong, nonatomic) NSString* faceErrorStringHoldStill;

@property (strong, nonatomic) NSString* faceErrorStringFaceScreen;

@property (strong, nonatomic) NSString* faceErrorStringMoveAway;

@property (strong, nonatomic) NSString* faceErrorStringMoveCloser;

@property (strong, nonatomic) UIColor* errorMessageBackgroundColor;

@property (strong, nonatomic) UIColor* errorMessageTextColor;

@property (assign, nonatomic) CGFloat errorMessageTextSize;

@property (assign, nonatomic) NSUInteger progressViewType;

@property (assign, nonatomic) CGFloat progressBarTintColorOpacity;

@property (strong, nonatomic) UIColor *progressBarTintColor;

@property (assign, nonatomic) CGFloat stillImageTintColorOpacity;

@property (strong, nonatomic) UIColor *stillImageTintColor;

@property (assign, nonatomic) CGRect faceBoxRect;

@property (assign, nonatomic) NSUInteger preferredCameraType;


/*
 * Whether to display a flash animation
 * on screen at time of image capture.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableFlash:(BOOL)enabled;





// Liveness Detection
@property (assign, nonatomic) BOOL usesLivenessDetection;
@property (assign, nonatomic) int numberOfFaceDetectionFrames;

// how many frames we require to complete for a photo to be taken
@property (assign, nonatomic) int minimumSessionFrames;

// 2-Factor Authentication
@property (assign, nonatomic) BOOL uses2FactorAuthentication;

@property (assign, nonatomic) BOOL is2FAFirstStageSuccessfull;

@property (strong, nonatomic) NSString *badgeNumberFor2FA;

- (void)reset2FA;


+ (instancetype)sharedManager;

/** set ClientConfig object from JSON returned from client/get_config */
- (void)setConfigurationDictionary:(NSDictionary *)clientConfig;

- (void)resetLivenessDetections;

- (void)incrementLivenessDetections;

- (BOOL)haveEnoughLivenessDetections;

- (BOOL)minMessageTimePassed;

- (BOOL)maxMessageTimePassed;

- (void)resetMessageDate;



/* * * Photo Record Stuff * * *
 * We take some photos before and 
 * after a punch to provide additional context
 * for admins performing fraud management */


// Adds a photo to the array
- (void)addSupportingPhoto:(CIImage*)photo;

// Resets (empties) the array
- (void)resetSupportingPhotoArray;


- (BOOL)canTakeSupportingPhoto;

// compiles the photos, extracting a subset for sending to the API
- (NSData *)compiledSupportingPhotos;

- (void)trimSupportingPhotoArrayIfMoreThan:(int)threshold;

- (void)supportingPhotoHighFrequencyMode;

- (void)supportingPhotoLowFrequencyMode;

- (void)incrementSessionFrames;

- (void)incrementUnstillFrames;

- (void)resetUnstillFrames;

- (BOOL)isTooManyUnstillFrames;

@end
