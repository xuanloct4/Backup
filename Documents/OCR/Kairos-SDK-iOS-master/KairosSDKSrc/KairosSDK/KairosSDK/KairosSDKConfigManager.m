//
//  KARConfigManager.m
//  TimeClock
//
//  Created by Eric Turner on 3/31/14.
//  Copyright (c) 2014 Kairos AR. All rights reserved.
//

#import "KairosSDKConfigManager.h"
#import "KairosSDKCommon.h"

@implementation KairosSDKConfigManager


static int supportingPhotoWidth = 80;

////////////////////////////////////////////////////////
+ (instancetype)sharedManager {
    static KairosSDKConfigManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager _initialize];
    });
    return _sharedManager;
}

////////////////////////////////////////////////////////
-(void) _initialize
{
    
    _supportingPhotos = [[NSMutableArray alloc] init];
    _numberOfLivenessDetections = 0;
    _numberOfFaceDetectionFrames = 0;
    _requiredLivenessDetections = 2;
    _minLengthOfBlink = 1;
    _minLengthOfSmile = 1;
    _minFramesBetweenBlinks = 5;
    _minFramesBetweenSmiles = 5;
    _canShowFaceDetectBox = NO;
    _canDetectFaces = YES;
    _minMessageTime = 1;
    _maxMessageTime = 4;
    _lastSupportingPhotoTakenAt = [NSDate dateWithTimeIntervalSinceNow:0.0];
    _supportingPhotoInterval = 0.85;
    _minimumSessionFrames = 20;
    _lastFaceCenterPoint = CGPointMake(0, 0);
    _unstillFrameCounter = 0;
    _grayscaleStillsEnabled = NO;
    _faceBoxColorValid = [UIColor greenColor];
    _faceBoxColorInvalid = [UIColor redColor];
    _croppingEnabled = YES;
    _showImageCaptureViewAnimationDuration = 0.35;
    _hideImageCaptureViewAnimationDuration = 0.35;
    _showImageCaptureViewTransitionType    = 2;
    _hideImageCaptureViewTransitionType    = 2;
    _shutterSoundEnabled = YES;
    _faceBoxBorderThickness = 0.025;
    _faceBoxBorderOpacity = 0.325;
    _errorMessagesEnabled = YES;
    _faceErrorStringFaceScreen = @"Face screen, please";
    _faceErrorStringHoldStill = @"Hold still, please";
    _faceErrorStringMoveAway = @"Move away from screen";
    _faceErrorStringMoveCloser = @"Move closer to screen";
    _errorMessageBackgroundColor = [UIColor redColor];
    _errorMessageTextColor = [UIColor whiteColor];
    _errorMessageTextSize = 22.0;
    _progressViewType = 2;
    _progressBarTintColor = colorWithHexString(@"6AC4E1");
    _progressBarTintColorOpacity = 0.65;
    _stillImageTintColor = nil;
    _stillImageTintColorOpacity = 0.35;
    _flashEnabled = YES;
    _preferredCameraType = 0;

    [self resetMessageDate];
    
    // get any pre-set config
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSNumber *ld_min_detections_required = [prefs objectForKey:@"ld_min_detections_required"];
    if(ld_min_detections_required){
        _requiredLivenessDetections = [ld_min_detections_required intValue];
    }
    
    NSNumber *ld_min_length_of_blink = [prefs objectForKey:@"ld_min_length_of_blink"];
    if(ld_min_length_of_blink){
        _minLengthOfBlink = [ld_min_length_of_blink intValue];
    }
    
    NSNumber *ld_min_length_of_smile = [prefs objectForKey:@"ld_min_length_of_smile"];
    if(ld_min_length_of_smile){
        _minLengthOfSmile = [ld_min_length_of_smile intValue];
    }
    
    NSNumber *ld_min_frames_between_blinks = [prefs objectForKey:@"ld_min_frames_between_blinks"];
    if(ld_min_frames_between_blinks){
        _minFramesBetweenBlinks = [ld_min_frames_between_blinks intValue];
    }
    
    NSNumber *ld_min_frames_between_smiles = [prefs objectForKey:@"ld_min_frames_between_smiles"];
    if(ld_min_frames_between_smiles){
        _minFramesBetweenSmiles = [ld_min_frames_between_smiles intValue];
    }
    

}


////////////////////////////////////////////////////////
- (void)setConfigurationDictionary:(NSDictionary *)clientConfig
{
    
    // Set Config
    NSString *wfmType                        = clientConfig[@"wfm_type"];
    NSNumber *facialEnabled                  = clientConfig[@"enable_facial_recognition"];
    NSNumber *twofactorEnabled               = clientConfig[@"enable_2fa"];
    NSNumber *livenessDetectionEnabled       = clientConfig[@"enable_liveness_detection"];
    NSNumber *ld_min_detections_required     = clientConfig[@"ld_min_detections_required"];
    NSNumber *ld_min_length_of_blink         = clientConfig[@"ld_min_length_of_blink"];
    NSNumber *ld_min_length_of_smile         = clientConfig[@"ld_min_length_of_smile"];
    NSNumber *ld_min_frames_between_blinks   = clientConfig[@"ld_min_frames_between_blinks"];
    NSNumber *ld_min_frames_between_smiles   = clientConfig[@"ld_min_frames_between_smiles"];

    
    [self set2faEnabled:twofactorEnabled];
    [self setFacialEnabled:facialEnabled];
    [self setLivenessDetectionEnabled:livenessDetectionEnabled];
    
    _requiredLivenessDetections = [self setIntegerValue:_requiredLivenessDetections ifExists:ld_min_detections_required];
    _minLengthOfBlink = [self setIntegerValue:_minLengthOfBlink ifExists:ld_min_length_of_blink];
    _minLengthOfSmile = [self setIntegerValue:_minLengthOfSmile ifExists:ld_min_length_of_smile];
    _minFramesBetweenBlinks = [self setIntegerValue:_minFramesBetweenBlinks ifExists:ld_min_frames_between_blinks];
    _minFramesBetweenSmiles = [self setIntegerValue:_minFramesBetweenSmiles ifExists:ld_min_frames_between_smiles];
    
    // Store locally
    [[NSUserDefaults standardUserDefaults] setObject:twofactorEnabled forKey:@"twoFactorAuthEnabled"];
    [[NSUserDefaults standardUserDefaults] setObject:facialEnabled forKey:@"facialRecEnabled"];
    [[NSUserDefaults standardUserDefaults] setObject:livenessDetectionEnabled forKey:@"livenessEnabled"];
    [[NSUserDefaults standardUserDefaults] setObject:ld_min_detections_required forKey:@"ld_min_detections_required"];
    [[NSUserDefaults standardUserDefaults] setObject:ld_min_length_of_blink forKey:@"ld_min_length_of_blink"];
    [[NSUserDefaults standardUserDefaults] setObject:ld_min_length_of_smile forKey:@"ld_min_length_of_smile"];
    [[NSUserDefaults standardUserDefaults] setObject:ld_min_frames_between_blinks forKey:@"ld_min_frames_between_blinks"];
    [[NSUserDefaults standardUserDefaults] setObject:ld_min_frames_between_smiles forKey:@"ld_min_frames_between_smiles"];


    [[NSUserDefaults standardUserDefaults] synchronize];

    [self setWFMType:wfmType];

}

////////////////////////////////////////////////////////
- (int)setIntegerValue:(int)integerValue ifExists:(NSNumber *)numberObj
{

    if(numberObj)
    {
        integerValue = [numberObj intValue];
    }
    
    return integerValue;
}

////////////////////////////////////////////////////////
- (void)setLivenessDetectionEnabled:(NSNumber *)enableLivenessDetection
{
    
    _usesLivenessDetection = [enableLivenessDetection boolValue];
}

////////////////////////////////////////////////////////
- (void)set2faEnabled:(NSNumber *)enable2fa
{
    _uses2FactorAuthentication = [enable2fa boolValue];
}

////////////////////////////////////////////////////////
- (void)setFacialEnabled:(NSNumber *)facialEnabled
{
    //_clientConfig.facialEnabled = facialEnabled;
}

////////////////////////////////////////////////////////
- (void)setWFMType:(NSString *)wfmType
{
    
    //_clientConfig.WFMType = wfmType;
}

////////////////////////////////////////////////////////
- (void)resetLivenessDetections
{
    
    _numberOfLivenessDetections = 0;
    //NSLog(@"RESET LIVENESS DETECTIONS");
    //NSLog(@"number of liveness detections == %i", _numberOfLivenessDetections);
}

////////////////////////////////////////////////////////
- (void)incrementLivenessDetections
{
    
    _numberOfLivenessDetections++;
}


////////////////////////////////////////////////////////
- (BOOL)haveEnoughLivenessDetections
{
    return _numberOfLivenessDetections >= _requiredLivenessDetections;
}

////////////////////////////////////////////////////////
- (void)reset2FA
{
    
    _badgeNumberFor2FA = nil;
    _is2FAFirstStageSuccessfull = NO;
}


- (BOOL)minMessageTimePassed
{
    int elapsed = [[NSDate date] timeIntervalSinceDate:_lastMessageStartedAt];
    if(elapsed > _minMessageTime){
        return YES;
    }
    
    return NO;
}

- (BOOL)maxMessageTimePassed
{
    int elapsed = [[NSDate date] timeIntervalSinceDate:_lastMessageStartedAt];
    if(elapsed > _maxMessageTime){
        return YES;
    }
    
    return NO;
}

- (void)resetMessageDate
{
    _lastMessageStartedAt = [NSDate dateWithTimeIntervalSinceNow:0.0];
}

#pragma mark photo record

- (void)addSupportingPhoto:(CIImage*)photo
{
    
    @autoreleasepool {
        
    CIContext *context = [CIContext contextWithOptions:nil];

    struct CGImage * cgiImage = [context createCGImage:photo fromRect:photo.extent];
    
    UIImage * uiimage = [UIImage imageWithCGImage:cgiImage
                                            scale:1.0
                                      orientation:UIImageOrientationRight];
    
    CGFloat aspectRatio = uiimage.size.height / uiimage.size.width;
    
    CGSize newSize = CGSizeMake(supportingPhotoWidth, supportingPhotoWidth*aspectRatio);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [uiimage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_supportingPhotos addObject:newImage];
    _lastSupportingPhotoTakenAt = [NSDate dateWithTimeIntervalSinceNow:0.0];
        
    if(cgiImage)
        CFRelease(cgiImage);
        
    //NSLog(@"Added to photo-record collection (%i total)", self.supportingPhotos.count);
        
    }
}

- (void)resetSupportingPhotoArray
{
    
    [_supportingPhotos removeAllObjects];
    
}

- (BOOL)canTakeSupportingPhoto
{
    int elapsed = [[NSDate date] timeIntervalSinceDate:_lastSupportingPhotoTakenAt];
    if(elapsed > _supportingPhotoInterval){
        return YES;
    }
    
    return NO;
}

- (NSData *)compiledSupportingPhotos
{
    @autoreleasepool {

    if(_supportingPhotos.count == 0)
    {
        return nil;
    }
    
    int offset;
    int photoCount = _supportingPhotos.count;
    if(photoCount <= 10){
        offset = 1;
    }else{
        offset = floor(_supportingPhotos.count / 10);
    }

    
    NSMutableArray *newSet = [[NSMutableArray alloc] initWithCapacity:10];
    
    int subCounter = 1;
    for(int i = 0; i < photoCount-1; i++)
    {
        
        UIImage *uiimg = [_supportingPhotos objectAtIndex:i];
        
        // 0-28
        if(subCounter >= offset){
            
            [newSet addObject:uiimg];
            subCounter = 1;
            
        }
        
        subCounter++;
        
        if(newSet.count == 10)
            break;
    }
    
    UIImage *sampleImage = [newSet objectAtIndex:0];
    CGSize imgSize = sampleImage.size;
    
    int newSetCount = [newSet count];
    if(newSetCount < 10)
    {
        int diff = (10 - newSetCount);
        
        UIImage *empty = [self emptyImageForSize:imgSize];
        
        for(int i = 0; i < diff; i++)
        {
            [newSet addObject:empty];
        }
    }
    
    
    CGSize newSize = CGSizeMake(imgSize.width * 5, imgSize.height*2);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    int row = 0;
    int col = 0;
    for(int i=0; i<10; i++)
    {
        
        UIImage *currentImg = [newSet objectAtIndex:i];
        
        CGRect newRect = CGRectMake(col * imgSize.width,
                                    row * imgSize.height,
                                    imgSize.width,
                                    imgSize.height);
        
        [currentImg drawInRect:newRect];
        
        //NSLog(@"drawing img %i in rect %@", i, NSStringFromCGRect(newRect));

        col++;
        if(i == 4){
            row++;
            col=0;
        }
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    newImage = [self drawText:dateString inImage:newImage atPoint:CGPointMake(0, 0)];
        
    [self resetSupportingPhotoArray];
    
    return UIImageJPEGRepresentation(newImage, 1.0);
        
    }
}

-(UIImage*)drawText:(NSString*)text
            inImage:(UIImage*)image
            atPoint:(CGPoint)point
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)trimSupportingPhotoArrayIfMoreThan:(int)threshold
{
    if(_supportingPhotos.count > threshold) {
        
        int count = (int)[_supportingPhotos count];
        int diff = count - 5;
        
        _supportingPhotos = [self removeObjects:diff fromArray:_supportingPhotos];
        
    }
}


- (NSMutableArray*)removeObjects:(int)numberOfObjects fromArray:(NSMutableArray*)array
{
    
    for(int i = 0; i < numberOfObjects; i++){
        
        [array removeLastObject];
        
    }
    
    return array;
}
            
- (UIImage *)emptyImageForSize:(CGSize)size
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor darkGrayColor];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)supportingPhotoHighFrequencyMode{
    
    _supportingPhotoInterval = 0.5;
}

- (void)supportingPhotoLowFrequencyMode{
    
    _supportingPhotoInterval = 1.5;
}


- (void)incrementSessionFrames
{
    
    _numberOfFaceDetectionFrames++;
}

- (void)incrementUnstillFrames
{
    
    _unstillFrameCounter++;
}

- (void)resetUnstillFrames
{
    
    _unstillFrameCounter=0;
}

- (BOOL)isTooManyUnstillFrames
{
    
    return (_unstillFrameCounter >= 1);
}

@end
