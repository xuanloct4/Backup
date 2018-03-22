//
//  KairosSDK.h
//  KairosSDK
//
//  Created by Eric Turner on 3/13/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/* Notifications You Can Observe */
extern NSString * const KairosWillShowImageCaptureViewNotification;
extern NSString * const KairosWillHideImageCaptureViewNotification;
extern NSString * const KairosDidShowImageCaptureViewNotification;
extern NSString * const KairosDidHideImageCaptureViewNotification;
extern NSString * const KairosDidCaptureImageNotification;



@interface KairosSDK : NSObject



#pragma mark - Authentication -



/*
 * Use this method to set your credentials
 * (you only need to do this once) */
+ (void)initWithAppId:(NSString*)appId appKey:(NSString*)appKey;



#pragma mark - Image-Capture Methods -
/* Note:
 * The following three methods wrap our standard methods
 * with an out-of-the-box image capture controller
 * for your convinience. */



/* Takes an image and stores it as a face template into a gallery you define
 @param subjectId The id of the subject
 @param galleryName The name of your gallery
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)imageCaptureEnrollWithSubjectId:(NSString*)subjectId
                            galleryName:(NSString*)galleryName
                                success:(void (^)(NSDictionary * response, UIImage * image))success
                                failure:(void (^)(NSDictionary * response, UIImage * image))failure;



/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define.
 @param threshold The minimum confidence threshold at which to return results (ex. 0.75)
 @param galleryName The name of your gallery
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)imageCaptureRecognizeWithThreshold:(NSString*)threshold
                               galleryName:(NSString*)galleryName
                                   success:(void (^)(NSDictionary * response, UIImage * image))success
                                   failure:(void (^)(NSDictionary * response, UIImage * image))failure;



/*
 * /detect
 * Takes an image and returns the facial features found within it.
 @param selector (Optional) a selector which will enhance the detector with the following options:
 - FACE: which is the default will provide only the face bounds.
 - EYES: will return face bounds, plus the eye location.
 - FULL: (Default) returns all face features.
 - SETPOSE: Same as FULL but also performs 2D to 3D rendering, pose correction, and normalization.
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)imageCaptureDetectWithSelector:(NSString*)selector
                               success:(void (^)(NSDictionary * response, UIImage * image))success
                               failure:(void (^)(NSDictionary * response, UIImage * image))failure;



#pragma mark - Standard Methods -
/* Note:
 * These are the standard methods wrapped with
 * network requests. For more detailed info see
 * the documentation at https://developer.kairos.com/docs */



/*
 * /enroll
 * Takes an image and stores it as a face template into a gallery you define.
 @param image an input image of the subject
 @param subjectId The id of the subject
 @param galleryName The name of your gallery
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)enrollWithImage:(UIImage*)image
              subjectId:(NSString*)subjectId
            galleryName:(NSString*)galleryName
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure;



/*
 * /enroll
 * Takes a url to an image and stores it as a face template into a gallery you define.
 @param imageURL a url to an external input image of the subject
 @param subjectId The id of the subject
 @param galleryName The name of your gallery
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)enrollWithImageURL:(NSString*)imageURL
                 subjectId:(NSString*)subjectId
               galleryName:(NSString*)galleryName
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure;



/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define.
 @param image an input image of the subject
 @param threshold The minimum confidence threshold at which to return results (ex. 0.75)
 @param galleryName The name of your gallery
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)recognizeWithImage:(UIImage*)image
                 threshold:(NSString*)threshold
               galleryName:(NSString*)galleryName
                maxResults:(NSString*)maxResults
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure;



/*
 * /recognize
 * Takes a url to an image and tries to match it against the already enrolled images in a gallery you define.
 @param imageURL a url to an external input image of the subject
 @param threshold The minimum confidence threshold at which to return results (ex. 0.75)
 @param galleryName The name of your gallery
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)recognizeWithImageURL:(NSString*)imageURL
                    threshold:(NSString*)threshold
                  galleryName:(NSString*)galleryName
                   maxResults:(NSString*)maxResults
                      success:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure;



/*
 * /detect
 * Takes an image and returns the facial features found within it.
 @param image an input image of the subject
 @param selector (Optional) a selector which will enhance the detector with the following options:
 - FACE: which is the default will provide only the face bounds.
 - EYES: will return face bounds, plus the eye location.
 - FULL: (Default) returns all face features.
 - SETPOSE: Same as FULL but also performs 2D to 3D rendering, pose correction, and normalization.
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)detectWithImage:(UIImage*)image
               selector:(NSString*)selector
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure;



/*
 * /detect
 * Takes an image and returns the facial features found within it.
 @param imageURL a url to an external input image of the subject
 @param selector (Optional) a selector which will enhance the detector with the following options:
 - FACE: which is the default will provide only the face bounds.
 - EYES: will return face bounds, plus the eye location.
 - FULL: (Default) returns all face features.
 - SETPOSE: Same as FULL but also performs 2D to 3D rendering, pose correction, and normalization.
 @param success Your success block
 @param failure Your failure block
 Note: The method returns a JSON response object and a copy of the image sent to the API */
+ (void)detectWithImageURL:(NSString*)url
                  selector:(NSString*)selector
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure;



/*
 * /gallery/list_all
 * Lists out all the galleries you have subjects enrolled in */
+ (void)galleryListAllWithSuccess:(void (^)(NSDictionary * response))success
                          failure:(void (^)(NSDictionary * response))failure;



/*
 * /gallery/view
 * Lists out all the subjects you have enrolled in a specified gallery.
 @param galleryName The name of your gallery */
+ (void)galleryView:(NSString*)galleryName
            success:(void (^)(NSDictionary * response))success
            failure:(void (^)(NSDictionary * response))failure;



/*
 * /gallery/remove_subject
 * Removes a subject from a specified gallery.
 @param subjectId The id of the subject
 @param galleryName The name of your gallery */
+ (void)galleryRemoveSubject:(NSString*)subjectId
                 fromGallery:(NSString*)galleryName
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure;



#pragma mark - Configuration Options -



/*
 * The minimum amount of frames to wait until capturing an image.
 * Enter a value between 1 - 9999
 * (Note: Default is 20) */
+ (void)setMinimumSessionFrames:(int)frames;



enum {
    KairosCameraFront                 = 0,
    KairosCameraBack                  = 1
};
typedef NSUInteger KairosCameraType;
/*
 * The desired camera to use (if available)
 * (Note: Used only for the image-capture methods)
 * (Note: Default is KairosCameraFront) */
+ (void)setPreferredCameraType:(KairosCameraType)cameraType;



/*
 * The color of the face detect box when validation is succeesful
 * (Default is green) */
+ (void)setFaceDetectBoxColorValid:(NSString*)hexColorCode;



/*
 * The color of the face detect box when validation is succeesful
 * (Default is red) */
+ (void)setFaceDetectBoxColorInvalid:(NSString*)hexColorCode;



/*
 * The thickness of the border of the face detect box
 * Enter a value between 1(thinnest) to 10(thickest)
 * (Default is 3) */
+ (void)setFaceDetectBoxBorderThickness:(NSUInteger)thickness;



/*
 * The opacity of the border of the face detect box
 * Enter a value between 0.0 to 1.0
 * (Default is 0.325) */
+ (void)setFaceDetectBoxBorderOpacity:(CGFloat)opacity;



/*
 * Whether or not the captured image is cropped
 * to the face detect box bounds before sending to the API.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableCropping:(BOOL)enabled;



/*
 * The speed (seconds) at which the Image Capture
 * view is animated in. Choose a value between 0-10 secs.
 * (Note: Used only for the image-capture methods) */
+ (void)setShowImageCaptureViewAnimationDuration:(CGFloat)seconds;



/*
 * The speed (seconds) at which the Image Capture
 * view is animated out. Choose a value between 0-10 secs.
 * (Note: Used only for the image-capture methods) */
+ (void)setHideImageCaptureViewAnimationDuration:(CGFloat)seconds;



enum {
    
    KairosTransitionTypeAlphaFade     = 0,
    KairosTransitionTypeSlide         = 1,
    KairosTransitionTypeAlphaAndSlide = 2
};
typedef NSUInteger KairosTransitionType;
/*
 * The transition used to
 * show the Image Capture view.
 * Use one of the KairosTransitionTypes listed above
 * (Note: Used only for the image-capture methods) */
+ (void)setShowImageCaptureViewTransitionType:(KairosTransitionType)type;



/*
 * The transition used to
 * hide the Image Capture view.
 * Use one of the KairosTransitionTypes listed above
 * (Note: Used only for the image-capture methods) */
+ (void)setHideImageCaptureViewTransitionType:(KairosTransitionType)type;



/*
 * Whether to show a grayscale version
 * of the captured image.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is NO) */
+ (void)setEnableGrayscaleStills:(BOOL)enabled;



/*
 * The color of the captured image still displayed
 * (Note: Used only for the image-capture methods */
+ (void)setStillImageTintColor:(NSString*)hexColorCode;



/*
 * The opacity of the tint color of the
 * captured image still displayed.
 * (Note: Used only for the image-capture methods */
+ (void)setStillImageTintOpacity:(CGFloat)opacity;



/*
 * Whether to display error messages
 * to help users take ideal images.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableErrorMessages:(BOOL)enabled;



/*
 * The background color of the error message view
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setErrorMessageBackgroundColor:(NSString*)hexColorCode;



/*
 * The text color of the error message label
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setErrorMessageTextColor:(NSString*)hexColorCode;



/*
 * The font size color of the error message label
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setErrorMessageFontSize:(CGFloat)size;



/*
 * Error message to display when user is
 * not in picture or otherwise out of position.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Face screen, please") */
+ (void)setErrorMessageFaceScreen:(NSString*)message;



/*
 * Error message to display when user is
 * moving around too much to get a clear shot.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Hold still, please") */
+ (void)setErrorMessageHoldStill:(NSString*)message;



/*
 * Error message to display when user is
 * too far away to get an ideal shot.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Move closer to the screen") */
+ (void)setErrorMessageMoveCloser:(NSString*)message;



/*
 * Error message to display when user is
 * too near to get an ideal shot.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is "Move away from the screen") */
+ (void)setErrorMessageMoveAway:(NSString*)message;



enum {
    KairosProgressViewTypeNone     = 0,
    KairosTransitionTypeSpinner    = 1,
    KairosTransitionTypeBar        = 2
};
typedef NSUInteger KairosProgressViewType;
/*
 * The type of progress view used to
 * show a busy state of the Image Capture view
 * after capturing an image.
 * (Note: Used only for the image-capture methods) */
+ (void)setProgressViewTransitionType:(KairosProgressViewType)type;



/*
 * The color of the progress bar
 * (Note: Used only for the image-capture methods,
 * and progress view of KairosTransitionTypeBar) */
+ (void)setProgressBarTintColor:(NSString*)hexColorCode;



/*
 * The opacity of the progress bar tint color
 * (Note: Used only for the image-capture methods,
 * and progress view of KairosTransitionTypeBar) */
+ (void)setProgressBarTintOpacity:(CGFloat)opacity;



/*
 * Whether to display a flash animation
 * on screen at time of image capture.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableFlash:(BOOL)enabled;



/*
 * Whether to play the shutter sound
 * at time of image capture.
 * (Note: Used only for the image-capture methods)
 * (Note: Default is YES) */
+ (void)setEnableShutterSound:(BOOL)enabled;



@end