//
//  KRViewController.m
//  KairosSDK
//
//  Created by Eric Turner on 3/14/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import "KairosSDKViewController.h"
#import "KairosSDKFrameMovement.h"
#import "KairosSDKConstants.h"
#import "KairosSDKConfigManager.h"
#import "KairosSDKCore.h"
#import "KairosSDKCommon.h"
#import "KARShutterSound.h"
#import "KAR_NSData+Base64.h"

#define maxNoFacesTime 2.0

@implementation CIFaceFeature (Blinking)

- (BOOL)blinking {
    
    if(IS_OS_7_OR_LATER == NO)
        return NO;
    
    if(self.leftEyeClosed && self.rightEyeClosed) {
        return YES;
    } else {
        return NO;
    }
    
}
@end



@interface LivelinessEvent ()
@property (nonatomic, strong) NSDate *startDate;
@end

@implementation LivelinessEvent
- (id)initWithStartDate:(NSDate *)startDate {
    self = [super init];
    if(self) {
        _startDate = startDate;
        _numberOfFrames = [NSNumber numberWithInt:0];
    }
    return self;
}
- (void)endWithFinishDate:(NSDate *)finishDate {
    _duration = [finishDate timeIntervalSinceDate:_startDate];
}
@end





@implementation KARSessionConfig
+ (id)sharedSessionConfig {
    static KARSessionConfig *sharedSessionConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSessionConfig = [[self alloc] init];
    });
    return sharedSessionConfig;
}
- (id)init {
    if (self = [super init]) {
        
        _minLengthOfBlink = [[KairosSDKConfigManager sharedManager] minLengthOfBlink];
        _minLengthOfSmile = [[KairosSDKConfigManager sharedManager] minLengthOfSmile];
        _minFramesBetweenBlinks = [[KairosSDKConfigManager sharedManager] minFramesBetweenBlinks];
        _minFramesBetweenSmiles = [[KairosSDKConfigManager sharedManager] minFramesBetweenSmiles];
        
    }
    return self;
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
}
@end




@interface KairosSDKViewController ()
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation KairosSDKViewController


////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

////////////////////////////////////////////////////////////////
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishProgressViews)
                                                 name:@"com.kairos.internal.requestreturned"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetUI)
                                                 name:@"com.kairos.sdk.didhideimagecaptureview"
                                               object:nil];

    
    self.previewView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [[self view] addSubview:self.previewView];
    
    NSDictionary *detectorOptions = @{CIDetectorTracking: @YES,
                                      CIDetectorAccuracy: CIDetectorAccuracyLow};
	_faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                       context:nil
                                       options:detectorOptions];
    
    _stillImageView = [[UIImageView alloc] initWithImage:nil];
    [_stillImageView setFrame:self.view.bounds];
    _stillImageView.alpha = 0.0;
    [[self view] addSubview:_stillImageView];
    [[self view] bringSubviewToFront:_stillImageView];
    
    if([[KairosSDKConfigManager sharedManager] stillImageTintColor] != nil)
    {
        _stillImageTintView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       _stillImageView.bounds.size.width,
                                                                       _stillImageView.bounds.size.height)];
        _stillImageTintView.backgroundColor = [[KairosSDKConfigManager sharedManager] stillImageTintColor];
        _stillImageTintView.alpha = [[KairosSDKConfigManager sharedManager] stillImageTintColorOpacity];
        [_stillImageView addSubview:_stillImageTintView];
    }
    
    [self setupAVCapture];
    
    //* * * * Error Message View * * * *
    CGFloat errorMessageViewHeight = [UIScreen mainScreen].bounds.size.height/9;
    _errorMessageHiddenRect = CGRectMake(0,
                                         0 - errorMessageViewHeight,
                                         [UIScreen mainScreen].bounds.size.width,
                                         errorMessageViewHeight);
    
    _errorMessageVisibleRect = CGRectMake(0,
                                          0,
                                          [UIScreen mainScreen].bounds.size.width,
                                          errorMessageViewHeight);
    
    _errorMessageView = [[UIView alloc] initWithFrame:_errorMessageHiddenRect];
    _errorMessageView.backgroundColor = [UIColor clearColor];
    
    
    if([[KairosSDKConfigManager sharedManager] progressViewType] == 1){

        //* * * * Progress Spinner * * * * * * * * * *
        _progressSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _progressSpinner.center = self.view.center;
        _progressSpinner.hidesWhenStopped = YES;
        [_progressSpinner stopAnimating];
        [self.view addSubview:_progressSpinner];
        [self.view bringSubviewToFront:_progressSpinner];
        
    }else  if([[KairosSDKConfigManager sharedManager] progressViewType] == 2){
    
        //* * * * Progress Bar View * * * * * * * * * *
        CGFloat progressBarHeight = [UIScreen mainScreen].bounds.size.height / 14;
        _progressBarHiddenRect = CGRectMake(0,
                                            0 - progressBarHeight,
                                            [UIScreen mainScreen].bounds.size.width,
                                            progressBarHeight);
        _progressBarVisibleRect = CGRectMake(0,
                                            0,
                                            [UIScreen mainScreen].bounds.size.width,
                                            progressBarHeight);
        
        _barView = [[UIView alloc] initWithFrame:_progressBarHiddenRect];
        _barView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.75];
        _barView.clipsToBounds = YES;
        
        _progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, _barView.bounds.size.height)];
        _progressBar.backgroundColor = [UIColor clearColor];
        _progressBar.clipsToBounds = YES;
        
        UIImage *progressBarPattern = [self progressBarImage];
        _progressBarAnimationView = [[UIView alloc] initWithFrame:CGRectMake(-progressBarPattern.size.width,
                                                                             0,
                                                                            [UIScreen mainScreen].bounds.size.width * progressBarPattern.size.width,
                                                                            _barView.bounds.size.height)];
        _progressBarAnimationView.backgroundColor = [UIColor colorWithPatternImage:progressBarPattern];
        
        _progressBarTintView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        _progressBarAnimationView.bounds.size.width,
                                                                        _progressBarAnimationView.bounds.size.height)];
        _progressBarTintView.clipsToBounds = YES;
        _progressBarTintView.backgroundColor = [[KairosSDKConfigManager sharedManager] progressBarTintColor];
        _progressBarTintView.alpha = [[KairosSDKConfigManager sharedManager] progressBarTintColorOpacity];
        [_progressBarAnimationView addSubview:_progressBarTintView];
        
        
        [_progressBar addSubview:_progressBarAnimationView];
        [_barView addSubview:_progressBar];
        _barView.alpha = 0.9;
        [self.view addSubview:_barView];
        
    }
    
    
    //* * * * Error Message Background View * * * *
    _errorMessageBackgroundView = [[UIView alloc] initWithFrame:_errorMessageView.bounds];
    _errorMessageBackgroundView.backgroundColor = [[KairosSDKConfigManager sharedManager] errorMessageBackgroundColor];
    _errorMessageBackgroundView.alpha = 0.75;
    
    
    //* * * * Error Message Label * * * *
    CGFloat padding = _errorMessageView.bounds.size.height / 4;
    CGFloat errorTextSize = [[KairosSDKConfigManager sharedManager] errorMessageTextSize];
    CGRect  labelRect = CGRectMake(padding/2,
                                   padding/2,
                                   _errorMessageView.bounds.size.width - padding,
                                   _errorMessageView.bounds.size.height - padding);
    _errorMessageLabel = [[UILabel alloc] initWithFrame:labelRect];
    _errorMessageLabel.backgroundColor           = [UIColor clearColor];
    _errorMessageLabel.textColor                 = [[KairosSDKConfigManager sharedManager] errorMessageTextColor];
    _errorMessageLabel.font                      = [UIFont systemFontOfSize:errorTextSize];
    _errorMessageLabel.adjustsFontSizeToFitWidth = YES;
    _errorMessageLabel.textAlignment             = NSTextAlignmentCenter;
    
    [_errorMessageView addSubview:_errorMessageBackgroundView];
    [_errorMessageView addSubview:_errorMessageLabel];
    [_errorMessageView bringSubviewToFront:_errorMessageLabel];
    
    _errorMessageView.alpha = 0.0;
    [self.view addSubview:_errorMessageView];
    [self.view bringSubviewToFront:_errorMessageView];
    
    
    //* * * * Flash View * * * * *
    _flashView = [[UIView alloc] initWithFrame:self.view.bounds];
    _flashView.backgroundColor = [UIColor whiteColor];
    _flashView.alpha = 0.0;
    [self.view addSubview:_flashView];
    [self.view bringSubviewToFront:_flashView];
    
}

////////////////////////////////////////////////////////////////
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
}

////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];

}

////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[KairosSDKCore sharedManager] finishShowingUI];
    
    [self startProgressBarAnimation];

}

////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


////////////////////////////////////////////////////////////////
- (void)teardownAVCapture
{
	[self.session stopRunning];
	
	[self.previewLayer removeFromSuperlayer];
	self.previewLayer = nil;
	
	self.session = nil;
}


////////////////////////////////////////////////////////////////
- (void)resetUI
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        _stillImageView.image = nil;
        _stillImageView.alpha = 0.0;
        _errorMessageView.alpha = 0.0;
        _errorMessageLabel.text = @"";
    });
}

////////////////////////////////////////////////////////////////
- (void)showFlashView
{
    if([[KairosSDKConfigManager sharedManager] flashEnabled] == NO)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {

    [self.view bringSubviewToFront:_flashView];
        
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _flashView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self fadeFlashView];
                     }];
    });
}

////////////////////////////////////////////////////////////////
- (void)fadeFlashView
{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _flashView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         
                     }];
}

////////////////////////////////////////////////////////////////
- (void)showStillWithImage:(CIImage*)ciimg
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        [self tryHideFaceError];
        
        UIImage *img = [[KairosSDKCore sharedManager] uiimageFromCiimage:ciimg
                                                       andOrientation:UIImageOrientationLeftMirrored];

        
        img = [[KairosSDKCore sharedManager] fixOrientationForImage:img];
        
        
        if([[KairosSDKConfigManager sharedManager] grayscaleStillsEnabled] == YES ||
           [[KairosSDKConfigManager sharedManager] stillImageTintColor] != nil){
            
            img = [[KairosSDKCore sharedManager] convertToGreyscale:img];
        }
        
        if([[KairosSDKConfigManager sharedManager] stillImageTintColor]){
            
            
        }
        
        
        CGSize imgSize = CGSizeMake(_stillImageView.frame.size.width, _stillImageView.frame.size.height);
        img = [[KairosSDKCore sharedManager] resizeImage:img scaledToSize:imgSize];
        
        _stillImageView.image = img;
        
        [UIView animateWithDuration:0.45 animations:^{
            _stillImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        
    });
}

- (void)setupAVCapture
{
    
	NSError *error = nil;
    
    frameMovement = [[KairosSDKFrameMovement alloc] init];
    
	self.session = [AVCaptureSession new];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
        
    }else{
        
        if([UIScreen mainScreen].bounds.size.height == 480) {
            
            [self.session setSessionPreset:AVCaptureSessionPresetMedium];
            
        }else{
            
            [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        }
    }
    
    AVCaptureDevice *device;
    
    // Preferred camera is front-camera
    if([[KairosSDKConfigManager sharedManager] preferredCameraType] == 0){
        
        device = [self frontFacingCameraIfAvailable];

    // Preferred camera is back-camera
    }else if([[KairosSDKConfigManager sharedManager] preferredCameraType] == 1){
        
        device = [self rearFacingCameraIfAvailable];
        
    // Default to front-camera
    }else{
        
        device = [self frontFacingCameraIfAvailable];
    }
    
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error)
    {
        NSLog(@"Error: %@", error.localizedDescription);
    }
	
	if ([self.session canAddInput:deviceInput])
    {
		[self.session addInput:deviceInput];
    }
	
	self.videoDataOutput = [AVCaptureVideoDataOutput new];
	
	NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
									   [NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	[self.videoDataOutput setVideoSettings:rgbOutputSettings];
	[self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
	self.videodataQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
	[self.videoDataOutput setSampleBufferDelegate:self queue:self.videodataQueue];
	
    if ( [self.session canAddOutput:self.videoDataOutput] )
		[self.session addOutput:self.videoDataOutput];
	[[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
	
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
	[self.previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    
	[self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	CALayer *rootLayer = self.previewView.layer;
	[rootLayer setMasksToBounds:YES];
	[self.previewLayer setFrame:[rootLayer bounds]];
    
	[rootLayer addSublayer:self.previewLayer];
    
    _stillImageView.alpha = 0.0;
    
	[self.session startRunning];
    
    [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
	if (error) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
															message:[error localizedDescription]
														   delegate:nil
												  cancelButtonTitle:@"Dismiss"
												  otherButtonTitles:nil];
		[alertView show];
		[self teardownAVCapture];
	}
}


//Get the forward facing camera, if not present default to another
-(AVCaptureDevice *)frontFacingCameraIfAvailable {
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionFront) {
            captureDevice = device;
            break;
        }
    }
    //  couldn't find one on the front, so just get the default video device.
    if (! captureDevice) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}


//Get the forward facing camera, if not present default to another
-(AVCaptureDevice *)rearFacingCameraIfAvailable {
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionBack) {
            captureDevice = device;
            break;
        }
    }
    //  couldn't find one on the front, so just get the default video device.
    if (! captureDevice) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

- (UIImage*)progressBarImage
{
    
    NSString *base64image = @"iVBORw0KGgoAAAANSUhEUgAAAHgAAAByCAYAAACY/xW0AAAAHGlET1QAAAACAAAAAAAAADkAAAAoAAAAOQAAADkAAAMoU3LPCAAAAvRJREFUeAHsnOuqwjAQhH1K8a54Q8W74l3Rl+1zyBxYCD1tE3viaZLpj5JqayF+mc0mjlupVqsRyzGZTKLX60VzPJ/PqMICt16vR/f7nQYuBvJ6veYBPJvNqOBCva1WiwMw1Pt4PKgAL5fLn6mXIkTP53MquFBvs9nkAIyOosNMyRUGtORWwSsYoYoJLqYiTEkUgJFksKkXyaTARRu0gjebDZV6sQxU1Rs04Ha7TadebOSo6g0a8G63o1Lv9XqNarUaB+But0sFF0nkeDz+BTdYBR8OByrA5/M5Ub1BAu71elRwod7hcJio3iABH49HKsCn0ykVbnCAB4MBFVyot9/v8wDGXMS0a4VcAyrNOoLZ6BiNRlRwMZCRb2TBDSZEY/2HdSCTevf7vRZuMIAZrTidTocDMPZeb7cblXq3260R3CAUzGrF0c29ct3rJIvRirNarYzV672Cma04olBd662CGa04i8XiI/V6rWBGK06j0eAAzGjFUY10urCsXvcyRMOxz7SpkWTFUSFmnXsHmFG90+n049As0L0DjEU+k3qxiRM30gk8k9YrwNieY7PBpllxTODiHq8AY4OdSb2XyyXVihMcYEYrDn4CNQWZdp83CmYz0umsOGlA4+97AZjRioM+x2Hlee0FYIxmprnXxIpjCtt5wKUVJ9tzpQPtNGBYcZBJMqnX1IqjAyvXnQaMNSATXKzxTa04AlDXOgu4tOL8LTQLeGcBMxrp8JdXAWOrdRIw1MtY08oWVPU5TgIujXR2wjNAOwcYrgXWmlaq8mydOwcYviO2zFlqWtmCqj7HKcCMRrq8VhwVYta5U4Dh+WVSb7ymVRaovNecAcxoxYnXtMoLMetzzgAua1rZy5xV4E4AZrTiJNW0UsHYOncCMJsVJ62mlS2o6nMKB1zWtPpOaBbIhQNms+Kgjoh8+f/RFgoYFWKYlkXoqy0rjungKBQwW00r9NcUjK37CgOM6mxs6jWpimMLrDynMMBlTavvJlcC+A0AAP//9XgfRQAAAw9JREFU7ZzpyvIwFIS9SnFX3FBxV9wVvdlex8d8EKi8tWm1yUk6+VFS2kJonjNJTjpNpVqtRraP8XgcvV4vqqPb7VpvZ3Ct2IZbq9Wi6/VKBXe324nAFQE8mUyo4D6fz6jT6XAArtfr0f1+pwK82WzE4FpX8Gw2o4IL9bZaLQ7AUO/j8aACvFqtROFaVfB8PqeCC/U2m00OwHhRvDBTaoSAtp2hJNVnJU1aLpdUcDEUNRoNDsCYZLCpF5PJJDVJXDOu4PV6TaVepIGYUErATKrTKOB2u02nXizkJDW01DWjgLfbLZV6b7ebU+pFUBkDjOU5trEXH1GklPqpXmOA9/s9lXovl0uEDymfGlrquhHAvV6PCi7y+9Fo5BxcBJURwIfDgQrw6XRyEq4RwIPBgAou1It3luqCdfUWrmBEM9OSJHorXSNL3i8UMMYhJrh4V8w3JAHq6i4MMGaQmEkyAUamoGtg6fuFAWYz0iHHl7TiZA2cQgBj7RWrOEzqxSpd1kaWfK4QwNPplAou1CttxckaND8DZjTS4QtZ1gaWfu5nwIxWHF/Ui+D6CTBcC2xGOrhTpFWZp/6fAC8WC7qx1wUjnRXAwUhn/5+uPGDVs18rGJ5fprQIQ5FLVhwFUFd+BTgY6fxQL+B/BThYcUoMmNGK45qRTtctx+/nVjCbFQf/MrtoxYlDTDvPBThYcfzpmhX0XIDZrDjn89mrRQ0FNV5mBtzv96nSIqSALltx4hDTzjMDZrPiHI9H79UL8JkAD4dDOvW6bsVJU238nhYwZpAYi5hWrVw30sUB6s61gNmsOAhkqT2tdLC+uZ8KGOoNe1r5lxrFAyEVMOOeVvjlNd5Avp9/BMxoxZHe08pEMH0EHPa08rtrVsGSCBjqDVacEgNmNNL5ZsVRCtWVfxQcrDjlUK4C/wcw455WPlpxFEBd+QY4WHHKpV7AfwMc9rQqMeCwp1X54L4pmM1IhyXYMo+9amz+30VjcT3saVViBbMZ6Vzd00qprsiyEox05VSuCpIKrClMH/Nd3tNKQSmy/Ad3DHw4V6Gw8QAAAABJRU5ErkJggg==";
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64image
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    //Now data is decoded. You can convert them to UIImage
    UIImage *image = [UIImage imageWithData:data];
        
    return image;
}

- (void)restartAnimation:(NSNotification *)notification
{
    //[progressBarAnimationView.layer removeAllAnimations];
    //[UIView setAnimationsEnabled:YES];
    [self startProgressBarAnimation];
    
}

- (void)startProgressBarAnimation
{
    
    _barView.alpha = 0.9;

    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionCurveLinear |
                                 UIViewAnimationOptionRepeat)
                     animations:^(void){
                         
                         _progressBarAnimationView.frame = CGRectMake(0,
                                                                     0,
                                                                     _progressBarAnimationView.bounds.size.width,
                                                                     _progressBarAnimationView.bounds.size.height);
                     }
                     completion:^(BOOL finished){

                     }
     ];
}


- (void)showProgressBar {
        
        [UIView animateWithDuration:0.3
                              delay:0.4
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {

                             _barView.frame = _progressBarVisibleRect;
                         }
         
                         completion:^(BOOL finished) {
                             
                             [self incrementProgressBar];
                             
                         }];
}



- (void)incrementProgressBar {
    
    CGFloat targetWidth = _barView.bounds.size.width * 0.2;
    
    if(_progressBar.frame.size.width < targetWidth){
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _progressBar.frame = CGRectMake(0,
                                                            0,
                                                            targetWidth,
                                                            _barView.bounds.size.height);
                         } completion:^(BOOL finished) {
                             
                             [self continueProgressBar];
                             
                         }];
    }
}


- (void)continueProgressBar {
    
    int minDuration = 1;
    int maxDuration = 6;
    CGFloat duration = (arc4random() % (maxDuration - minDuration) + minDuration) * 1.0;
    CGFloat targetWidth = _barView.bounds.size.width * 0.90;
    
    if(_progressBar.frame.size.width < targetWidth){
        
        [UIView animateWithDuration:duration
                              delay:0.25
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _progressBar.frame = CGRectMake(0,
                                                            0,
                                                            targetWidth,
                                                            _barView.bounds.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
}


- (void)finishProgressViews
{
    
    if([[KairosSDKConfigManager sharedManager] progressViewType] == 0){

        [[KairosSDKCore sharedManager] finishImageCaptureAndCallback];

    }else if([[KairosSDKConfigManager sharedManager] progressViewType] == 1){
        
        [_progressSpinner stopAnimating];
        [[KairosSDKCore sharedManager] finishImageCaptureAndCallback];

    }else if([[KairosSDKConfigManager sharedManager] progressViewType] == 2){
        
        [self fillProgressBar];
        
    }
}


- (void)beginProgressViews
{
    
    if([[KairosSDKConfigManager sharedManager] progressViewType] == 1){

        // show spinner
        [_progressSpinner startAnimating];
    
    }else if([[KairosSDKConfigManager sharedManager] progressViewType] == 2){
        
        [self startProgressBarAnimation];
        [self showProgressBar];
    }
    
}


- (void)fillProgressBar
{
    
    CGFloat targetWidth = _barView.bounds.size.width;
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         _progressBar.frame = CGRectMake(0,
                                                        0,
                                                        targetWidth,
                                                        _barView.bounds.size.height);
                         
                     } completion:^(BOOL finished) {
                         
                         [self hideProgressBarAndFinish];
                         
                     }];
}

- (void)prepareShutterSoundIfNeeded
{
    NSString * filename = @"kairossdkshutter.wav";
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * path = [documentsPath stringByAppendingPathComponent:filename];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if(fileExists){
        return;
    }
    
    NSError *error = nil;

    NSData *soundData = [NSData dataFromBase64String:kShutterSound];
    
    BOOL succeeded = [soundData writeToFile:path
                                    options:NSDataWritingAtomic
                                      error:&error];
    
    if (succeeded) {
        //NSLog(@"Success at: %@",path);
    } else {
        //NSLog(@"Failed to store. Error: %@",error);
    }
}

- (void)playShutterSound
{

    [self prepareShutterSoundIfNeeded];
    
    NSString * filename = @"kairossdkshutter.wav";
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * path = [documentsPath stringByAppendingPathComponent:filename];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_shutterSoundID);
    AudioServicesPlaySystemSound(_shutterSoundID);
    
}

- (void)hideProgressBarAndFinish
{
    
    [UIView animateWithDuration:0.2
                          delay:0.25
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         
                         _barView.frame = _progressBarHiddenRect;
                     }
     
                     completion:^(BOOL finished) {
                         
                         _progressBar.frame = CGRectMake(0,
                                                         0,
                                                         0,
                                                 
                                                         _barView.bounds.size.height);
                         
                         dispatch_async(dispatch_get_main_queue(), ^(void) {
                             _barView.alpha = 0.0;
                         });
                         
                         [[KairosSDKCore sharedManager] finishImageCaptureAndCallback];
                     }];
}



#pragma mark New Framework Detection Code



- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {
        
        
        // Increment Progress
        if(self.view.alpha == 1.0){
            
            [[KairosSDKConfigManager sharedManager] incrementSessionFrames];
            captureProgress = [NSNumber numberWithInt:[captureProgress intValue] + 1];
        }
        
        
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
        CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer
                                                          options:(__bridge NSDictionary *)attachments];
        
        if (attachments)
            CFRelease(attachments);
        NSDictionary *imageOptions = nil;
        UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
        int exifOrientation;
        
        
        enum {
            PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1,
            PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2,
            PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3,
            PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4,
            PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5,
            PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6,
            PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7,
            PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8
        };
        
        switch (curDeviceOrientation) {
                
            case UIDeviceOrientationPortraitUpsideDown:
                exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
                break;
            case UIDeviceOrientationLandscapeLeft:
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
                break;
            case UIDeviceOrientationLandscapeRight:
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
                break;
            case UIDeviceOrientationPortrait:
            default:
                exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
                break;
        }
        
        NSNumber *orientationNum = [NSNumber numberWithInt:exifOrientation];
        
        if(IS_OS_7_OR_LATER){
            
            imageOptions = @{CIDetectorImageOrientation: orientationNum,
                             CIDetectorEyeBlink: @YES,
                             CIDetectorSmile: @YES
                             };
            
        }else{
            
            imageOptions = @{CIDetectorImageOrientation: orientationNum};
            
        }
        
        NSArray *features = [_faceDetector featuresInImage:ciImage
                                                   options:imageOptions];
        
        
        CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
        CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false
                                                               // originIsTopLeft == false
                                                               );
        
        
        // * * * Validation
        BOOL passedMainValidation = [self validateWithFeatures:features
                                                         image:ciImage
                                                          rect:clap];
        
        BOOL passedLivenessValidation;
        
        BOOL passedCaptureProgressValidation;
        
        if(passedMainValidation == YES){
            
            passedLivenessValidation        = [self validateLiveness];
            passedCaptureProgressValidation = [self validateCaptureProgress];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self drawFaceBoxesForFeatures:features
                               forVideoBox:clap
                               orientation:curDeviceOrientation
                                  mirrored:[connection isVideoMirrored]
                                     valid:passedMainValidation];
        });
        
        
        
        
        // * * * * * Do Stuff * * * * *
        
        if([[KairosSDKConfigManager sharedManager] maxMessageTimePassed] == YES){
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self tryHideFaceError];
            });
        }
        
        
        // * * * If validated, take the photo * * *
        if(passedMainValidation            == YES  &&
           passedLivenessValidation        == YES  &&
           passedCaptureProgressValidation == YES)
        {
            
            // * * * do one final validation for the position
            // to make sure it's not too far from the last frame's position
            CGRect r = [[features lastObject] bounds];
            CGPoint rPnt = CGPointMake(r.origin.x + (r.size.width / 2), r.origin.y + (r.size.height / 2));
            BOOL passedPositionValidation = [self validatePosition:rPnt];
            if(passedPositionValidation == NO)
                return;
            
            [[KairosSDKConfigManager sharedManager] setNumberOfFaceDetectionFrames:[captureProgress intValue]];
            captureProgress = @0;
            
            [[KairosSDKConfigManager sharedManager] setFaceYaw:0.0];
            [[KairosSDKConfigManager sharedManager] setFaceRoll:0.0];
            
            // * * * Quit Here If Needed * * * *
            if([[KairosSDKConfigManager sharedManager] canDetectFaces] == NO){
                return;
            }
            
            if([[KairosSDKConfigManager sharedManager] shutterSoundEnabled] == YES){
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    [self playShutterSound];
                });
            }
            
            [[KairosSDKConfigManager sharedManager] setCanDetectFaces:NO];
            [[KairosSDKConfigManager sharedManager] setCanShowFaceDetectBox:NO];
            
            
            CIImage *freeze = [ciImage imageByCroppingToRect:ciImage.extent];
            [self showStillWithImage:freeze];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {

                [self showFlashView];
                [self beginProgressViews];
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.didcaptureimage"
                                                                object:nil];
            
            [[KairosSDKCore sharedManager] completeWithImage:ciImage];
        
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self hideFaceError];
                
            });
        }
    }
}




#pragma mark VALIDATION

- (BOOL)validateWithFeatures:(NSArray *)features
                       image:(CIImage *)img
                        rect:(CGRect)box
{
    
    // Validate that screensaver is hidden, keypad not showing, etc
    if([self validateScreenContext] == NO)
        return NO;
    
    
    // Validate the rect size
    if([self validateRect] == NO)
        return NO;
    
    
    // Validate the features
    if([self validateFeatures:features] == NO)
        return NO;
    
    
    // Validate capture progress
    /*
     if([self validateCaptureProgress] == NO)
     return NO;
     */
    
    
    // Validate liveness
    /*
     if([self validateLiveness] == NO)
     return NO;
     */
    
    // Validate the image
    // TODO validate too dark or too bright
    
    
    return YES;
}

- (BOOL)validateScreenContext
{
    
    if(self.view.alpha < 1.0)
        return NO;
    
    if([KairosSDKConfigManager sharedManager].canShowFaceDetectBox == NO)
        return NO;
    
    
    return YES;
}


- (BOOL)validateCaptureProgress
{
    
    if(captureProgress.intValue < [[KairosSDKConfigManager sharedManager] minimumSessionFrames])
        return NO;
    
    return YES;
}


- (BOOL)validatePosition:(CGPoint)p1
{
    
    CGPoint p2 = [[KairosSDKConfigManager sharedManager] lastFaceCenterPoint];
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat currentDistance = sqrt((xDist * xDist) + (yDist * yDist));
    
    [[KairosSDKConfigManager sharedManager] setLastFaceCenterPoint:p1];
    
    CGFloat maxDistance = 0.15 * [UIScreen mainScreen].bounds.size.width;
    
    /*
     NSLog(@"======================================");
     NSLog(@"currentPoint = (%f,%f), lastPoint = (%f,%f)", p1.x, p1.y, p2.x, p2.y);
     NSLog(@"currentDistance (%f), maxDistance (%f)", currentDistance, maxDistance);
     NSLog(@"======================================");
     */
    
    
    if(currentDistance == 0.0)
    {
        // sometimes the points are identical
        // seems like an error
        // throw away
        captureProgress = @0;
        return NO;
    }
    else if(currentDistance > maxDistance)
    {
        //NSLog(@"DETECTED UNSTILL FRAME....");
        //NSLog(@"currentDistance (%f) > maxDistance (%f)", currentDistance, maxDistance);
        
        [[KairosSDKConfigManager sharedManager] incrementUnstillFrames];
        
        if([[KairosSDKConfigManager sharedManager] isTooManyUnstillFrames] == YES){
            
            
            [[KairosSDKConfigManager sharedManager] resetUnstillFrames];
            captureProgress = @0;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self tryShowFaceError:[[KairosSDKConfigManager sharedManager] faceErrorStringHoldStill]];
                
            });
            
        }
        return NO;
        
    }
    
    [[KairosSDKConfigManager sharedManager] resetUnstillFrames];
    
    return YES;
}


- (BOOL)validateFeatures:(NSArray *)features
{
    
	NSInteger featuresCount = [features count];
    
    if ( featuresCount == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self tryShowFaceError:[[KairosSDKConfigManager sharedManager] faceErrorStringFaceScreen]];
            
        });
		return NO;
	}
    
    return YES;
}

- (BOOL)validateLiveness
{
    
    // Pass if we don't use liveness detection
    /*
    if([[KARConfigManager sharedManager] usesLivenessDetection] == NO)
        return YES;
     */
    
    // Validate if liveness is enabled
    
    /*
     if([[KARConfigManager sharedManager] haveEnoughLivenessDetections] == NO){
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     [self tryShowFaceError:@"Please blink or smile"];
     });
     
     return NO;
     }
     */
    
    return YES;
}


- (BOOL)validateRect
{

    
    CALayer *featureLayer = nil;
    
    NSArray *sublayers = [NSArray arrayWithArray:[self.previewLayer sublayers]];
	NSInteger sublayersCount = [sublayers count];
    NSInteger currentSublayer = 0;
    
    // Find the feature layer
    while ( !featureLayer && (currentSublayer < sublayersCount) ) {
        CALayer *currentLayer = [sublayers objectAtIndex:currentSublayer++];
        if ( [[currentLayer name] isEqualToString:@"FaceLayer"] ) {
            featureLayer = currentLayer;
        }
    }
    
    CGRect box = featureLayer.bounds;
    
    //NSLog(@"%f", box.size.width);
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.95;
    CGFloat minWidth = [UIScreen mainScreen].bounds.size.width * 0.55;
    
    // allow larger minimum for iPad
    if((minWidth / 3) > 90.0){
        minWidth = 90.0 * 3;
    }
    
    if(box.size.width > maxWidth){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self tryShowFaceError:[[KairosSDKConfigManager sharedManager] faceErrorStringMoveAway]];
        });
        
        return NO;
    }
    
    if(box.size.width < minWidth){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self tryShowFaceError:[[KairosSDKConfigManager sharedManager] faceErrorStringMoveCloser]];
        });
        
        return NO;
        
    }
    
    return YES;
}

- (void)drawFaceBoxesForFeatures:(NSArray *)features
                     forVideoBox:(CGRect)clap
                     orientation:(UIDeviceOrientation)orientation
                        mirrored:(BOOL)isMirrored
                           valid:(BOOL)isValid
{
    
	NSArray *sublayers = [NSArray arrayWithArray:[self.previewLayer sublayers]];
	NSInteger sublayersCount = [sublayers count], currentSublayer = 0;
	NSInteger featuresCount = [features count];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	// hide all the face layers
	for ( CALayer *layer in sublayers ) {
		if ( [[layer name] isEqualToString:@"FaceLayer"] )
			[layer setHidden:YES];
	}
    
    // don't draw if not needed
    if([self validateScreenContext] == NO){
        [CATransaction commit];
        return;
    }
	
    //No Faces Found
	if ( featuresCount == 0) {
		[CATransaction commit];
		return;
	}
    
    
    //No Faces Found
	if ( featuresCount > 1) {
		[CATransaction commit];
        //NSLog(@"!!!!!!!!!! Multiple Faces detected !!!!!!!!!!");
        /*
         dispatch_async(dispatch_get_main_queue(), ^{
         [self tryShowFaceError:@"Move closer to screen"];
         });
         */
		return;
	}
    
	CGSize parentFrameSize = [self.previewLayer frame].size;
	NSString *gravity = [self.previewLayer videoGravity];
	CGRect previewBox = [self videoPreviewBoxForGravity:gravity
                                              frameSize:parentFrameSize
                                           apertureSize:clap.size];
    
    CIFaceFeature *ff = [features firstObject];
	
    //Detect Liveliness
    //[self detectLivelinessForFaceFeature:ff];
    
    CGRect faceRect = [ff bounds];
    
    // flip preview width and height
    CGFloat temp = faceRect.size.width;
    faceRect.size.width = faceRect.size.height;
    faceRect.size.height = temp;
    temp = faceRect.origin.x;
    faceRect.origin.x = faceRect.origin.y;
    faceRect.origin.y = temp;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
    CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
    faceRect.size.width *= widthScaleBy;
    faceRect.size.height *= heightScaleBy;
    faceRect.origin.x *= widthScaleBy;
    faceRect.origin.y *= heightScaleBy;
    
    
    
    if (!isMirrored) {
        
        faceRect = CGRectOffset(faceRect,
                                previewBox.origin.x + previewBox.size.width - faceRect.size.width - (faceRect.origin.x * 2),
                                previewBox.origin.y);
        
    } else {
        
        faceRect = CGRectOffset(faceRect,
                                previewBox.origin.x,
                                previewBox.origin.y);
    }
    
    
    
    
    // * * * Make Rectangular
    CGFloat oldHeight = faceRect.size.height;
    CGFloat newHeight = faceRect.size.height * 1.25;
    faceRect = CGRectMake(faceRect.origin.x,
                          faceRect.origin.y - ((newHeight - oldHeight) /2),
                          faceRect.size.width,
                          newHeight);
    
    
    
    
    CALayer *featureLayer = nil;
    
    // re-use an existing layer if possible
    while ( !featureLayer && (currentSublayer < sublayersCount) ) {
        CALayer *currentLayer = [sublayers objectAtIndex:currentSublayer++];
        if ( [[currentLayer name] isEqualToString:@"FaceLayer"] ) {
            featureLayer = currentLayer;
            [currentLayer setHidden:NO];
        }
    }
    
    
    //create a new one if necessary
    if ( !featureLayer ) {
        
        CGFloat thickness = [[KairosSDKConfigManager sharedManager] faceBoxBorderThickness];
        CGFloat opacity = [[KairosSDKConfigManager sharedManager] faceBoxBorderOpacity];
        featureLayer = [CALayer new];
        featureLayer.borderWidth = [UIScreen mainScreen].bounds.size.width * thickness;
        featureLayer.opacity = opacity;
        [featureLayer setName:@"FaceLayer"];
        [self.previewLayer addSublayer:featureLayer];
        
    }
    
    
    if(isValid == YES){
        
        [self resetNoFacesTimer];
        featureLayer.borderColor = [KairosSDKConfigManager sharedManager].faceBoxColorValid.CGColor;
        
    }else{
        
        // reset capture progress
        captureProgress = @0;
        featureLayer.borderColor = [KairosSDKConfigManager sharedManager].faceBoxColorInvalid.CGColor;
    }
    
    [featureLayer setFrame:faceRect];
    
    [[KairosSDKConfigManager sharedManager] setFaceBoxRect:faceRect];
    
	[CATransaction commit];
}


#pragma mark LIVENESS

- (void)detectLivelinessForFaceFeature:(CIFaceFeature *)faceFeature {
    
    if(IS_OS_7_OR_LATER == NO)
        return;
    
    if (faceFeature.trackingID != self.currentTrackingID) {
        [self resetLivelinessDetection];
        self.currentTrackingID = faceFeature.trackingID;
    } else {
        
        KARSessionConfig *config = [KARSessionConfig sharedSessionConfig];
        //Blinks
        if (self.blinkEventToCommit) {
            if ([self.framesSinceLastBlink intValue] >= config.minFramesBetweenBlinks) {
                [self.blinkEvents addObject:self.blinkEventToCommit];
                self.blinkEventToCommit = nil;
                //self.totalBlinkEventsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.blinkEvents.count];
            } else {
                self.framesSinceLastBlink = [NSNumber numberWithInt:self.framesSinceLastBlink.intValue + 1];
            }
        }
        
        //Blink Event in progress already
        if(self.currentBlinkEvent) {
            if (faceFeature.blinking) {
                self.currentBlinkEvent.numberOfFrames = [NSNumber numberWithInt:[self.currentBlinkEvent.numberOfFrames intValue] + 1];
            }
            else {
                if ([self.currentBlinkEvent.numberOfFrames intValue] < config.minLengthOfBlink) {
                    self.currentBlinkEvent = nil;
                } else {
                    //NSLog(@"**********> BLINKED %i", [[KairosSDKConfigManager sharedManager] numberOfLivenessDetections]);
                    [[KairosSDKConfigManager sharedManager] incrementLivenessDetections];
                    [self.currentBlinkEvent endWithFinishDate:[NSDate date]];
                    self.blinkEventToCommit = self.currentBlinkEvent;
                    self.framesSinceLastBlink = [NSNumber numberWithInt:0];
                    self.currentBlinkEvent = nil;
                }
            }
            
            //No current Blink Event in progress already
        } else {
            if (faceFeature.blinking) {
                if (self.blinkEventToCommit) {
                    self.blinkEventToCommit = nil;
                    self.framesSinceLastBlink = [NSNumber numberWithInt:0];
                } else {
                    LivelinessEvent *newBlinkEvent = [[LivelinessEvent alloc] initWithStartDate:[NSDate date]];
                    self.currentBlinkEvent.numberOfFrames = [NSNumber numberWithInt:1];
                    self.currentBlinkEvent = newBlinkEvent;
                }
            }
        }
        
        //Smiles
        if (self.smileEventToCommit) {
            if ([self.framesSinceLastSmile intValue] >= config.minFramesBetweenSmiles) {
                [self.smileEvents addObject:self.smileEventToCommit];
                self.smileEventToCommit = nil;
                //self.totalSmileEventsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.smileEvents.count];
            } else {
                self.framesSinceLastSmile = [NSNumber numberWithInt:self.framesSinceLastSmile.intValue + 1];
            }
        }
        
        //Smile Event in progress already
        if(self.currentSmileEvent) {
            if (faceFeature.hasSmile) {
                self.currentSmileEvent.numberOfFrames = [NSNumber numberWithInt:[self.currentSmileEvent.numberOfFrames intValue] + 1];
            }
            else {
                if ([self.currentSmileEvent.numberOfFrames intValue] < config.minLengthOfSmile) {
                    self.currentSmileEvent = nil;
                } else {
                    //NSLog(@"*****> SMILED %i", [[KairosSDKConfigManager sharedManager] numberOfLivenessDetections]);
                    [[KairosSDKConfigManager sharedManager] incrementLivenessDetections];
                    [self.currentSmileEvent endWithFinishDate:[NSDate date]];
                    self.smileEventToCommit = self.currentSmileEvent;
                    self.framesSinceLastSmile = [NSNumber numberWithInt:0];
                    self.currentSmileEvent = nil;
                }
            }
            
            //No current Smile Event in progress already
        } else {
            if (faceFeature.hasSmile) {
                if (self.smileEventToCommit) {
                    self.smileEventToCommit = nil;
                    self.framesSinceLastSmile = [NSNumber numberWithInt:0];
                } else {
                    LivelinessEvent *newSmileEvent = [[LivelinessEvent alloc] initWithStartDate:[NSDate date]];
                    self.currentSmileEvent.numberOfFrames = [NSNumber numberWithInt:1];
                    self.currentSmileEvent = newSmileEvent;
                }
            }
        }
    }
}

- (void)resetLivelinessDetection {
    self.blinkEvents = [NSMutableArray new];
    self.smileEvents = [NSMutableArray new];
    self.currentBlinkEvent = nil;
    self.currentSmileEvent = nil;
    self.totalBlinkEventsLabel.text = @"0";
    self.totalSmileEventsLabel.text = @"0";
    self.framesSinceLastBlink = [NSNumber numberWithInt:0];
    self.framesSinceLastSmile = [NSNumber numberWithInt:0];
    self.blinkEventToCommit = nil;
    self.smileEventToCommit = nil;
}



- (void)tryShowFaceError:(NSString *)errorMessage
{
    if([[KairosSDKConfigManager sharedManager] errorMessagesEnabled] == NO)
        return;
    
    // Can we show a message?
    if([[KairosSDKConfigManager sharedManager] canShowFaceDetectBox] == NO)
        return;
    
    // Is the minimum message time passed?
    if([[KairosSDKConfigManager sharedManager] minMessageTimePassed] == NO)
        return;
    
    // Is this message equal to the last message
    if(KARStringEqualsString(errorMessage, _errorMessageLabel.text) == YES &&
       IsEmpty(_errorMessageLabel.text) == NO)
    {
        return;
    }
    
    [self showFaceError:errorMessage];
    
}

- (void)showFaceError:(NSString *)errorMessage
{
    
    _errorMessageLabel.text = errorMessage;
    _errorMessageView.alpha = 1.0;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _errorMessageView.alpha = 1.0;
                         _errorMessageView.frame = _errorMessageVisibleRect;
                     }
     
                     completion:^(BOOL finished) {
                         
                         faceErrorHidden = NO;
                         [[KairosSDKConfigManager sharedManager] resetMessageDate];
                         
                     }];
}

- (void)tryHideFaceError
{
    if([[KairosSDKConfigManager sharedManager] errorMessagesEnabled] == NO)
        return;
    
    if([[KairosSDKConfigManager sharedManager] minMessageTimePassed] == NO)
        return;
    
    [self hideFaceError];
}

- (void)hideFaceError
{

    _errorMessageLabel.text = @"";
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _errorMessageView.alpha = 0.0;
                         _errorMessageView.frame = _errorMessageHiddenRect;
                     }
     
                     completion:^(BOOL finished) {
                         
                         faceErrorHidden = YES;
                         
                     }];
}



- (CGRect)videoPreviewBoxForGravity:(NSString *)gravity
                          frameSize:(CGSize)frameSize
                       apertureSize:(CGSize)apertureSize
{
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    
    CGSize size = CGSizeZero;
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        if (viewRatio > apertureRatio) {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        } else {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        if (viewRatio > apertureRatio) {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        } else {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResize]) {
        size.width = frameSize.width;
        size.height = frameSize.height;
    }
	
	CGRect videoBox;
	videoBox.size = size;
	if (size.width < frameSize.width)
		videoBox.origin.x = (frameSize.width - size.width) / 2;
	else
		videoBox.origin.x = (size.width - frameSize.width) / 2;
	
	if ( size.height < frameSize.height )
		videoBox.origin.y = (frameSize.height - size.height) / 2;
	else
		videoBox.origin.y = (size.height - frameSize.height) / 2;
    
    
	return videoBox;
}


- (void)resetNoFacesTimer {
    
    if (!noFacesTimer) {
        noFacesTimer = [NSTimer scheduledTimerWithTimeInterval:maxNoFacesTime
                                                        target:self
                                                      selector:@selector(noFacesTimerExceeded)
                                                      userInfo:nil
                                                       repeats:NO];
    }
    
    else {
        if (fabs([noFacesTimer.fireDate timeIntervalSinceNow]) < maxNoFacesTime) {
            [noFacesTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:maxNoFacesTime]];
        }
    }
}

- (void)noFacesTimerExceeded
{
    noFacesTimer = nil;
    //captureProgress = @0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self tryShowFaceError:[[KairosSDKConfigManager sharedManager] faceErrorStringFaceScreen]];
        
    });
}


- (void)detectMovement:(CGRect)faceRect
{
    
    bool test = [frameMovement isMoving:faceRect];
    
}



@end