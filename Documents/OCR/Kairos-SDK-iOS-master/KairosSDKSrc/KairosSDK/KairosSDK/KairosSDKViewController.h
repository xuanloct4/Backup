//
//  KRViewController.h
//  KairosSDK
//
//  Created by Eric Turner on 3/14/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KairosSDKFrameMovement.h"

@interface CIFaceFeature (Blinking)
- (BOOL)blinking;
@end


@interface LivelinessEvent : NSObject
@property (nonatomic, strong) NSNumber *numberOfFrames;
@property (nonatomic, assign) NSTimeInterval duration;
- (id)initWithStartDate:(NSDate *)startDate;
- (void)endWithFinishDate:(NSDate *)finishDate;
@end



@interface KARSessionConfig : NSObject
+ (id)sharedSessionConfig;
@property (nonatomic, assign) NSUInteger minLengthOfBlink;
@property (nonatomic, assign) NSUInteger minLengthOfSmile;
@property (nonatomic, assign) NSUInteger minFramesBetweenBlinks;
@property (nonatomic, assign) NSUInteger minFramesBetweenSmiles;
@end



@interface KairosSDKViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {

    KairosSDKFrameMovement *frameMovement;
    CIContext *_ciContext;
    CIDetector *_faceDetector;
    NSNumber *captureProgress;
    NSTimer *noFacesTimer;
    BOOL faceErrorHidden;
    
}

// General
@property (strong, nonatomic, readonly) AVCaptureSession           * session;
@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer * previewLayer;
@property (strong, nonatomic)           UIView                     * previewView;
@property (strong, nonatomic)           AVCaptureVideoDataOutput   * videoDataOutput;
@property (strong, nonatomic)           dispatch_queue_t             videodataQueue;
@property (strong, nonatomic)           UIImageView                * stillImageView;
@property (strong, nonatomic)           UIView                     * stillImageTintView;
@property (strong, nonatomic)           UIView                     * flashView;
@property (strong, nonatomic)           UIView                     * errorMessageView;
@property (strong, nonatomic)           UIView                     * errorMessageBackgroundView;
@property (strong, nonatomic)           UILabel                    * errorMessageLabel;
@property (assign, nonatomic)           CGRect                       errorMessageVisibleRect;
@property (assign, nonatomic)           CGRect                       errorMessageHiddenRect;
@property (strong, nonatomic)           UIView                     * barView;
@property (strong, nonatomic)           UIView                     * progressBar;
@property (strong, nonatomic)           UIView                     * progressBarAnimationView;
@property (strong, nonatomic)           UIView                     * progressBarTintView;
@property (assign, nonatomic)           CGRect                       progressBarHiddenRect;
@property (assign, nonatomic)           CGRect                       progressBarVisibleRect;
@property (strong, nonatomic)           UIActivityIndicatorView    * progressSpinner;
@property (assign, nonatomic)           SystemSoundID                shutterSoundID;




// Core Image
@property (strong,nonatomic) AVCaptureMetadataOutput *metadataOutput;
@property (strong,nonatomic) NSDate* avfLastFrameTime;
@property (assign,nonatomic) float avfProcessingInterval;
@property (strong,nonatomic) NSMutableDictionary* avfFaceLayers;
@property (strong,nonatomic) NSMutableDictionary* indexForFaceID;

//Blinks
@property (nonatomic, strong) LivelinessEvent *currentBlinkEvent;
@property (nonatomic, strong) LivelinessEvent *blinkEventToCommit;
@property (nonatomic, strong) NSMutableArray *blinkEvents;
@property (nonatomic, strong) NSNumber *framesSinceLastBlink;
@property (nonatomic, strong) IBOutlet UILabel *totalBlinkEventsLabel;

//Smiles
@property (nonatomic, strong) LivelinessEvent *currentSmileEvent;
@property (nonatomic, strong) LivelinessEvent *smileEventToCommit;
@property (nonatomic, strong) NSMutableArray *smileEvents;
@property (nonatomic, strong) NSNumber *framesSinceLastSmile;
@property (nonatomic, strong) IBOutlet UILabel *totalSmileEventsLabel;

//Face
@property (nonatomic, assign) int currentTrackingID;

/*
 * Show the still image after image capture */
- (void)showStillWithImage:(CIImage*)ciimg;

@end
