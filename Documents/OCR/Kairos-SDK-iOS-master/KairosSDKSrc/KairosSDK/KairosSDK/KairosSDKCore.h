//
//  KRManager.h
//  KairosSDK
//
//  Created by Eric Turner on 3/14/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KairosSDKConstants.h"

@interface KairosSDKCore : NSObject {
    
    NSString *base64;
    
}

@property (nonatomic, strong) NSString * appId;
@property (nonatomic, strong) NSString * appKey;

/*
 * Creates and returns the manager singleton */
+ (instancetype)sharedManager;

/*
 * make sure credentials are set */
- (BOOL)validateCredentials;

/*
 * Take a CIImage, convert into data for the API, pass onto selected API method */
- (void)completeWithImage:(CIImage*)ciimage;

/*
 * Convert an image to grayscale */
- (UIImage *)convertToGreyscale:(UIImage *)i;

/*
 * Fix Orientation */
- (UIImage *)fixOrientationForImage:(UIImage*)img;


/* Resize Image */
- (UIImage*)resizeImage:(UIImage*)image scaledToSize:(CGSize)newSize;


/*
 * Convert a UIImage to a CIImage */
- (UIImage*)uiimageFromCiimage:(CIImage*)ciimage andOrientation:(UIImageOrientation)orientation;



/* Internal method */
- (void)finishShowingUI;


/* Internal method */
- (void)finishImageCaptureAndCallback;


/* Internal method */
- (UIImage*)cropImage:(UIImage *)image toRect:(CGRect)rect;



#pragma mark - Image Picker Methods -
// These methods wrap our standard methods with an out-of-the-box image picker controller for your convinience.

/*
 * /enroll
 * Takes an image and stores it as a face template into a gallery you define */
- (void)imageCaptureEnrollWithSubjectId:(NSString*)subjectId
                            galleryName:(NSString*)galleryName
                                success:(void (^)(NSDictionary * response, UIImage * image))success
                                failure:(void (^)(NSDictionary * response, UIImage * image))failure;


/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
- (void)imageCaptureRecognizeWithThreshold:(NSString*)threshold
                               galleryName:(NSString*)galleryName
                                   success:(void (^)(NSDictionary * response, UIImage * image))success
                                   failure:(void (^)(NSDictionary * response, UIImage * image))failure;


/*
 * /detect
 * Takes an image and returns the facial features found within it */
- (void)imageCaptureDetectWithSelector:(NSString*)selector
                               success:(void (^)(NSDictionary * response, UIImage * image))success
                               failure:(void (^)(NSDictionary * response, UIImage * image))failure;



#pragma mark - Standard Methods -
// These are the standard methods wrapped with network requests.

/*
 * /enroll
 * Takes an image and stores it as a face template into a gallery you define */
- (void)enrollWithImage:(UIImage*)image
              subjectId:(NSString*)subjectId
            galleryName:(NSString*)galleryName
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure;


/*
 * /enroll
 * Takes a url to an image and stores it as a face template into a gallery you define */
- (void)enrollWithImageURL:(NSString*)imageURL
                 subjectId:(NSString*)subjectId
               galleryName:(NSString*)galleryName
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure;


/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
- (void)recognizeWithImage:(UIImage*)image
                 threshold:(NSString*)threshold
               galleryName:(NSString*)galleryName
                maxResults:(NSString*)maxResults
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure;



/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
- (void)recognizeWithImageURL:(NSString*)imageURL
                    threshold:(NSString*)threshold
                  galleryName:(NSString*)galleryName
                   maxResults:(NSString*)maxResults
                      success:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure;


/*
 * /detect
 * Takes an image and returns the facial features found within it */
- (void)detectWithImage:(UIImage*)image
               selector:(NSString*)selector
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure;


/*
 * /detect
 * Takes an image url string and returns the facial features found */
- (void)detectWithImageURL:(NSString*)imageURL
                  selector:(NSString*)selector
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure;


/*
 * /gallery/list_all
 * Lists out all the galleries you have subjects enrolled in */
- (void)galleryListAllWithSuccess:(void (^)(NSDictionary * response))success
                          failure:(void (^)(NSDictionary * response))failure;

/*
 * /gallery/view
 * Lists out all the subjects you have enrolled in a specified gallery */
- (void)galleryView:(NSString*)galleryName
            success:(void (^)(NSDictionary * response))success
            failure:(void (^)(NSDictionary * response))failure;


/*
 * /gallery/remove_subject
 * Removes a subject from a specified gallery */
- (void)galleryRemoveSubject:(NSString*)subjectId
                 fromGallery:(NSString*)galleryName
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure;



@end
