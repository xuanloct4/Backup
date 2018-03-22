//
//  KairosSDK.m
//  KairosSDK
//
//  Created by Eric Turner on 3/13/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import "KairosSDK.h"
#import "KairosSDKCore.h"
#import "KairosSDKConfigManager.h"
#import "KairosSDKCommon.h"

NSString * const KairosWillShowImageCaptureViewNotification  = @"com.kairos.sdk.willshowimagecaptureview";
NSString * const KairosWillHideImageCaptureViewNotification  = @"com.kairos.sdk.willhideimagecaptureview";
NSString * const KairosDidShowImageCaptureViewNotification   = @"com.kairos.sdk.didshowimagecaptureview";
NSString * const KairosDidHideImageCaptureViewNotification   = @"com.kairos.sdk.didhideimagecaptureview";
NSString * const KairosDidCaptureImageNotification           = @"com.kairos.sdk.didcaptureimage";

@implementation KairosSDK

#pragma mark - Credentials -
// Set your credentials once
+ (void)initWithAppId:(NSString*)appId
               appKey:(NSString*)appKey
{
    
    [[KairosSDKCore sharedManager] setAppId:appId];
    [[KairosSDKCore sharedManager] setAppKey:appKey];
    
}

#pragma mark - Standard Kairos Methods Wrapped With Camera View -
// These methods wrap our standard methods with an out-of-the-box image picker controller for your convinience.

/*
 * /enroll
 * Takes an image and stores it as a face template into a gallery you define */
+ (void)imageCaptureEnrollWithSubjectId:(NSString*)subjectId
                            galleryName:(NSString*)galleryName
                                success:(void (^)(NSDictionary * response, UIImage * image))success
                                failure:(void (^)(NSDictionary * response, UIImage * image))failure
{
    [[KairosSDKCore sharedManager] imageCaptureEnrollWithSubjectId:subjectId
                                                    galleryName:galleryName
                                                        success:^(NSDictionary * response, UIImage * image) {
                                                            
                                                            success(response, image);
                                                            
                                                        } failure:^(NSDictionary * response, UIImage * image) {
                                                            
                                                            failure(response, image);
                                                            
                                                        }];
}


/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
+ (void)imageCaptureRecognizeWithThreshold:(NSString*)threshold
                               galleryName:(NSString*)galleryName
                                   success:(void (^)(NSDictionary * response, UIImage * image))success
                                   failure:(void (^)(NSDictionary * response, UIImage * image))failure
{
    
    [[KairosSDKCore sharedManager] imageCaptureRecognizeWithThreshold:threshold
                                                       galleryName:galleryName
                                                           success:^(NSDictionary *response, UIImage * image) {
                                                               
                                                               success(response, image);
                                                               
                                                           } failure:^(NSDictionary * response, UIImage * image) {
                                                               
                                                               failure(response, image);
                                                               
                                                           }];
    
}


/*
 * /detect
 * Takes an image and returns the facial features found within it */
+ (void)imageCaptureDetectWithSelector:(NSString*)selector
                               success:(void (^)(NSDictionary * response, UIImage * image))success
                               failure:(void (^)(NSDictionary * response, UIImage * image))failure
{
    
    [[KairosSDKCore sharedManager] imageCaptureDetectWithSelector:selector
                                                       success:^(NSDictionary * response, UIImage * image) {
                                                           
                                                           success(response, image);
                                                           
                                                       } failure:^(NSDictionary * response, UIImage * image) {
                                                           
                                                           failure(response, image);
                                                           
                                                       }];
    
}


#pragma mark - Standard Kairos Methods -
// These are the standard methods wrapped with network requests.

/*
 * /enroll
 * Takes an image and stores it as a face template into a gallery you define */
+ (void)enrollWithImage:(UIImage*)image
              subjectId:(NSString*)subjectId
            galleryName:(NSString*)galleryName
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] enrollWithImage:image
                                      subjectId:subjectId
                                    galleryName:galleryName
                                        success:^(NSDictionary *response) {
                                            
                                            success(response);
                                            
                                        } failure:^(NSDictionary * response) {
                                            
                                            failure(response);
                                            
                                        }];
}


/*
 * /enroll
 * Takes a url to an image and stores it as a face template into a gallery you define */
+ (void)enrollWithImageURL:(NSString*)imageURL
                 subjectId:(NSString*)subjectId
               galleryName:(NSString*)galleryName
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure
{
    
    
    [[KairosSDKCore sharedManager] enrollWithImageURL:imageURL
                                      subjectId:subjectId
                                    galleryName:galleryName
                                        success:^(NSDictionary *response) {
                                            
                                            success(response);
                                            
                                        } failure:^(NSDictionary * response) {
                                            
                                            failure(response);
                                            
                                        }];
    
}

/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
+ (void)recognizeWithImage:(UIImage*)image
                 threshold:(NSString*)threshold
               galleryName:(NSString*)galleryName
                maxResults:(NSString*)maxResults
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] recognizeWithImage:image
                                         threshold:threshold
                                       galleryName:galleryName
                                        maxResults:maxResults
                                           success:^(NSDictionary *response) {
                                               
                                               success(response);
                                               
                                           } failure:^(NSDictionary * response) {
                                               
                                               failure(response);
                                               
                                           }];
    
}



+ (void)recognizeWithImageURL:(NSString*)imageURL
                    threshold:(NSString*)threshold
                  galleryName:(NSString*)galleryName
                   maxResults:(NSString*)maxResults
                      success:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] recognizeWithImageURL:imageURL
                                            threshold:threshold
                                          galleryName:galleryName
                                           maxResults:maxResults
                                              success:^(NSDictionary *response) {
                                                  success(response);
                                              } failure:^(NSDictionary * response) {
                                                  failure(response);
                                              }];
    
}

/*
 * /detect
 * Takes an image and returns the facial features found within it */
+ (void)detectWithImage:(UIImage*)image
               selector:(NSString*)selector
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] detectWithImage:image
                                       selector:selector
                                        success:^(NSDictionary *response) {
                                            
                                            success(response);
                                            
                                        } failure:^(NSDictionary * response) {
                                            
                                            failure(response);
                                            
                                        }];
    
}

/*
 * /detect
 * Takes an image url string and returns the facial features found */
+ (void)detectWithImageURL:(NSString*)url
                  selector:(NSString*)selector
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] detectWithImageURL:url
                                          selector:selector
                                           success:^(NSDictionary *response) {
                                               
                                               success(response);
                                               
                                           } failure:^(NSDictionary * response) {
                                               
                                               failure(response);
                                               
                                           }];
}

/*
 * /gallery/list_all
 * Lists out all the galleries you have subjects enrolled in */
+ (void)galleryListAllWithSuccess:(void (^)(NSDictionary * response))success
                          failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] galleryListAllWithSuccess:^(NSDictionary *response) {
        
        success(response);
        
    } failure:^(NSDictionary * response) {
        
        failure(response);
        
    }];
    
}

/*
 * /gallery/view
 * Lists out all the subjects you have enrolled in a specified gallery */
+ (void)galleryView:(NSString*)gallery
            success:(void (^)(NSDictionary * response))success
            failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] galleryView:gallery
                                   success:^(NSDictionary *response) {
                                       
                                       success(response);
                                       
                                   } failure:^(NSDictionary * response) {
                                       
                                       failure(response);
                                       
                                   }];
}


/*
 * /gallery/remove_subject
 * Removes a subject from a specified gallery */
+ (void)galleryRemoveSubject:(NSString*)subjectId
                 fromGallery:(NSString*)galleryName
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure
{
    
    [[KairosSDKCore sharedManager] galleryRemoveSubject:subjectId
                                         fromGallery:galleryName
                                             success:^(NSDictionary *response) {
                                                 
                                                 success(response);
                                                 
                                             } failure:^(NSDictionary * response) {
                                                 
                                                 failure(response);
                                                 
                                             }];
}




#pragma mark - Configuration Options -

/*
 * The minimum amount of frames to wait until capturing an image
 * (Note: Default is 20) */
+ (void)setMinimumSessionFrames:(int)frames
{
    
    if(frames < 1)
    {
        frames = 1;
    }
    
    if(frames > 9999)
    {
        frames = 9999;
    }
    
    [[KairosSDKConfigManager sharedManager] setMinimumSessionFrames:frames];
    
}

/*
 * The desired camera to use (if available)
 * (Note: Used only for the image-capture methods)
 * (Note: Default is KairosCameraFront) */
+ (void)setPreferredCameraType:(KairosCameraType)cameraType
{
    
    if(cameraType > 1)
        return;
    
    [[KairosSDKConfigManager sharedManager] setPreferredCameraType:cameraType];
}



/*
 * The color of the face detect box when validation is succeesful
 * (Default is green) */
+ (void)setFaceDetectBoxColorValid:(NSString*)hexColorCode
{

    if(IsEmpty(hexColorCode))
        return;
    
    if(KARStringEqualsString(hexColorCode, @""))
        return;
    
    hexColorCode = [hexColorCode stringByReplacingOccurrencesOfString: @"#" withString:@""];
    
    UIColor *color = colorWithHexString(hexColorCode);
    [[KairosSDKConfigManager sharedManager] setFaceBoxColorValid:color];
}

/*
 * The color of the face detect box when validation is succeesful
 * (Default is red) */
+ (void)setFaceDetectBoxColorInvalid:(NSString*)hexColorCode
{
    
    if(IsEmpty(hexColorCode))
        return;
    
    if(KARStringEqualsString(hexColorCode, @""))
        return;
    
    hexColorCode = [hexColorCode stringByReplacingOccurrencesOfString: @"#" withString:@""];
    
    UIColor *color = colorWithHexString(hexColorCode);
    [[KairosSDKConfigManager sharedManager] setFaceBoxColorInvalid:color];
}


/*
 * The thickness of the border of the face detect box
 * Enter a value between 1(thinnest) to 10(thickest)
 * (Default is 3) */
+ (void)setFaceDetectBoxBorderThickness:(NSUInteger)thickness
{
    
    if(thickness < 1)
        thickness = 1;
    
    if(thickness > 10)
        thickness = 10;
    
    CGFloat constant = 0.0083;
    
    [[KairosSDKConfigManager sharedManager] setFaceBoxBorderThickness:thickness * constant];

}



/*
 * The opacity of the border of the face detect box
 * Enter a value between 0.0 to 1.0
 * (Default is 0.325) */
+ (void)setFaceDetectBoxBorderOpacity:(CGFloat)opacity
{
    
    if(opacity < 0.0)
        opacity = 0.0;
    
    if(opacity > 1.0)
        opacity = 1.0;
    
    [[KairosSDKConfigManager sharedManager] setFaceBoxBorderOpacity:opacity];

}



/*
 * Whether or not the captured image is cropped
 * to the face detect box bounds before sending to the API.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableCropping:(BOOL)enabled
{
    
    [[KairosSDKConfigManager sharedManager] setCroppingEnabled:enabled];
    
}

/*
 * The speed at which the Image Capture
 * view is animated in.
 * (Note: Used only for the image-capture methods) */
+ (void)setShowImageCaptureViewAnimationDuration:(CGFloat)seconds
{
    if(seconds < 0)
        seconds = 0.0;
    
    if(seconds > 10.0)
        seconds = 10.0;
    
    [[KairosSDKConfigManager sharedManager] setShowImageCaptureViewAnimationDuration:seconds];

}

/*
 * The speed at which the Image Capture
 * view is animated out.
 * (Note: Used only for the image-capture methods) */
+ (void)setHideImageCaptureViewAnimationDuration:(CGFloat)seconds
{
    
    if(seconds < 0)
        seconds = 0.0;
    
    if(seconds > 10.0)
        seconds = 10.0;
    
    [[KairosSDKConfigManager sharedManager] setShowImageCaptureViewAnimationDuration:seconds];
    
}



/*
 * The transition used to
 * show the Image Capture view.
 * Use one of the KairosTransitionTypes listed above
 * (Note: Used only for the image-capture methods) */
+ (void)setShowImageCaptureViewTransitionType:(KairosTransitionType)type
{
    if(type > 2)
        return;

    [[KairosSDKConfigManager sharedManager] setShowImageCaptureViewTransitionType:type];
}



/*
 * The transition used to
 * hide the Image Capture view.
 * Use one of the KairosTransitionTypes listed above
 * (Note: Used only for the image-capture methods) */
+ (void)setHideImageCaptureViewTransitionType:(KairosTransitionType)type
{
    if(type > 2)
        return;
    
    [[KairosSDKConfigManager sharedManager] setHideImageCaptureViewTransitionType:type];
}


/*
 * Whether to show a grayscale version
 * of the captured image.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is NO) */
+ (void)setEnableGrayscaleStills:(BOOL)enabled
{
    
    [[KairosSDKConfigManager sharedManager] setGrayscaleStillsEnabled:enabled];
    
}




/*
 * The color of the captured image still displayed
 * (Note: Used only for the image-capture methods */
+ (void)setStillImageTintColor:(NSString*)hexColorCode
{
    if(IsEmpty(hexColorCode))
        return;
    
    if(KARStringEqualsString(hexColorCode, @""))
        return;
    
    hexColorCode = [hexColorCode stringByReplacingOccurrencesOfString: @"#" withString:@""];
    
    UIColor *color = colorWithHexString(hexColorCode);
    [[KairosSDKConfigManager sharedManager] setStillImageTintColor:color];
    
}




/*
 * The opacity of the tint color of the 
 * captured image still displayed.
 * (Note: Used only for the image-capture methods */
+ (void)setStillImageTintOpacity:(CGFloat)opacity
{
    
    if(opacity < 0)
        opacity = 0;
    
    if(opacity > 1.0)
        opacity = 1.0;
    
    [[KairosSDKConfigManager sharedManager] setStillImageTintColorOpacity:opacity];
    
}



/*
 * Whether to display error messages
 * to help users take ideal images.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableErrorMessages:(BOOL)enabled
{
    
    [[KairosSDKConfigManager sharedManager] setErrorMessagesEnabled:enabled];
    
}





/*
 * The background color of the error message view
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setErrorMessageBackgroundColor:(NSString*)hexColorCode
{
    
    if(IsEmpty(hexColorCode))
        return;
    
    if(KARStringEqualsString(hexColorCode, @""))
       return;
    
    hexColorCode = [hexColorCode stringByReplacingOccurrencesOfString: @"#" withString:@""];
    
    UIColor *color = colorWithHexString(hexColorCode);
    
    [[KairosSDKConfigManager sharedManager] setErrorMessageBackgroundColor:color];
}




/*
 * The text color of the error message label
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setErrorMessageTextColor:(NSString*)hexColorCode
{
    if(IsEmpty(hexColorCode))
        return;
    
    if(KARStringEqualsString(hexColorCode, @""))
        return;
    
    hexColorCode = [hexColorCode stringByReplacingOccurrencesOfString: @"#" withString:@""];
    
    UIColor *color = colorWithHexString(hexColorCode);
    
    [[KairosSDKConfigManager sharedManager] setErrorMessageTextColor:color];
}




/*
 * The font size color of the error message label
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setErrorMessageFontSize:(CGFloat)size
{
    if(size < 1)
        size = 1;
    
    if(size > 60)
        size = 60;
    
    [[KairosSDKConfigManager sharedManager] setErrorMessageTextSize:size];
}




/*
 * Error message to display when user is
 * not in picture or otherwise out of position.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Face screen, please") */
+ (void)setErrorMessageFaceScreen:(NSString*)message
{
    
    if(IsEmpty(message))
        return;
    
    if(KARStringEqualsString(message, @""))
        return;
    
    [[KairosSDKConfigManager sharedManager] setFaceErrorStringFaceScreen:message];
}



/*
 * Error message to display when user is
 * moving around too much to get a clear shot.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Hold still, please") */
+ (void)setErrorMessageHoldStill:(NSString*)message
{
    
    if(IsEmpty(message))
        return;
    
    if(KARStringEqualsString(message, @""))
        return;
    
    [[KairosSDKConfigManager sharedManager] setFaceErrorStringHoldStill:message];
}


/*
 * Error message to display when user is
 * too far away to get an ideal shot.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Move closer to the screen") */
+ (void)setErrorMessageMoveCloser:(NSString*)message
{
    
    if(IsEmpty(message))
        return;
    
    if(KARStringEqualsString(message, @""))
        return;
    
    [[KairosSDKConfigManager sharedManager] setFaceErrorStringMoveCloser:message];
}



/*
 * Error message to display when user is
 * too near to get an ideal shot.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Move away from the screen") */
+ (void)setErrorMessageMoveAway:(NSString*)message
{
    
    if(IsEmpty(message))
        return;
    
    if(KARStringEqualsString(message, @""))
        return;
    
    [[KairosSDKConfigManager sharedManager] setFaceErrorStringMoveAway:message];
}



/*
 * The type of progress view used to
 * show a busy state of the Image Capture view
 * after capturing an image.
 * (Note: Used only for the image-capture methods) */
+ (void)setProgressViewTransitionType:(KairosProgressViewType)type
{
    
    
    
}




/*
 * The color of the progress bar
 * (Note: Used only for the image-capture methods,
 * and progress view of KairosTransitionTypeBar) */
+ (void)setProgressBarTintColor:(NSString*)hexColorCode
{
    if(IsEmpty(hexColorCode))
        return;
    
    if(KARStringEqualsString(hexColorCode, @""))
        return;
    
    hexColorCode = [hexColorCode stringByReplacingOccurrencesOfString: @"#" withString:@""];
    
    UIColor *color = colorWithHexString(hexColorCode);
    [[KairosSDKConfigManager sharedManager] setProgressBarTintColor:color];
    
}


/*
 * The opacity of the progress bar tint color
 * (Note: Used only for the image-capture methods,
 * and progress view of KairosTransitionTypeBar) */
+ (void)setProgressBarTintOpacity:(CGFloat)opacity
{
    
    if(opacity < 0)
        opacity = 0;
    
    if(opacity > 1.0)
        opacity = 1.0;
    
    [[KairosSDKConfigManager sharedManager] setProgressBarTintColorOpacity:opacity];
    
}




/*
 * Whether to display a flash animation
 * on screen at time of image capture.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableFlash:(BOOL)enabled
{
    
    [[KairosSDKConfigManager sharedManager] setFlashEnabled:enabled];
}



/*
 * Whether to play the shutter sound
 * at time of image capture.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableShutterSound:(BOOL)enabled
{
    [[KairosSDKConfigManager sharedManager] setShutterSoundEnabled:enabled];
}

@end
