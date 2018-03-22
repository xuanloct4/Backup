//
//  KRManager.m
//  KairosSDK
//
//  Created by Eric Turner on 3/14/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import "KairosSDKCore.h"
#import "KairosSDKViewController.h"
#import "KairosSDKCommon.h"
#import "KR_AFHTTPClient.h"
#import "KairosSDKConfigManager.h"
#import <AudioToolbox/AudioToolbox.h>


@interface KairosSDKCore ()
@property (nonatomic, strong) KairosSDKViewController * krViewController;
@property (nonatomic, strong) UIWindow * oldKeyWindow;
@property (nonatomic, strong) UIWindow * myKeyWindow;
@property (strong, nonatomic) void __block (^copyOfSuccessBlock)(NSDictionary * response, UIImage *image);
@property (strong, nonatomic) void __block (^copyOfFailureBlock)(NSDictionary * response, UIImage *image);
@property (strong, nonatomic) NSString *selectedMethod;
@property (strong, nonatomic) NSString *selector;
@property (strong, nonatomic) NSString *subjectId;
@property (strong, nonatomic) NSString *galleryName;
@property (strong, nonatomic) NSString *threshold;
@property (strong, nonatomic) NSString *maxResults;
@property (strong, nonatomic) id        responseDict;
@property (assign, nonatomic) BOOL      responseDidSucceed;

@end

@implementation KairosSDKCore

///////////////////////////////////////////////////////////////
+ (instancetype)sharedManager
{
    static KairosSDKCore *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager _initialize];
    });
    return _sharedManager;
}

///////////////////////////////////////////////////////////////
-(void)_initialize
{
    

}

///////////////////////////////////////////////////////////////
-(void)recognize
{
    [self krViewController];
    [self showUI];
}

#pragma mark - General Methods -

///////////////////////////////////////////////////////////////
- (void)showUI
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.willshowimagecaptureview"
                                                        object:nil];

    [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
    
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.myKeyWindow                    = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.myKeyWindow.alpha              = 0.0;
    self.myKeyWindow.opaque             = NO;
    self.myKeyWindow.windowLevel        = UIWindowLevelAlert;
	self.myKeyWindow.backgroundColor    = [UIColor clearColor];
    self.myKeyWindow.hidden             = NO;
    [self.myKeyWindow makeKeyAndVisible];
    
    [KairosSDKConfigManager sharedManager].canShowFaceDetectBox = YES;
    
    self.myKeyWindow.rootViewController = [self krViewController];
    
}

- (void)finishShowingUI
{
    
    NSUInteger transitionType = [[KairosSDKConfigManager sharedManager] showImageCaptureViewTransitionType];
    
    if (transitionType == 0){
        
        [self transitionAlphaFadeIn];
        
    }else if (transitionType == 1){
        
        [self transitionSlideIn];
        
    }else if (transitionType == 2){
        
        [self transitionAlphaAndSlideIn];
    }
}

///////////////////////////////////////////////////////////////
- (void)hideUI
{
    
    if(!self.myKeyWindow)
        return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.willhideimagecaptureview"
                                                        object:nil];
    
    NSUInteger transitionType = [[KairosSDKConfigManager sharedManager] hideImageCaptureViewTransitionType];

    if (transitionType == 0){
        
        [self transitionAlphaFadeOut];
        
    }else if (transitionType == 1){
        
        [self transitionSlideOut];
        
    }else if (transitionType == 2){
        
        [self transitionAlphaAndSlideOut];
    }
}

#pragma mark - Transitions - 

///////////////////////////////////////////////////////////////
- (void)transitionAlphaFadeIn
{
    CGFloat duration = [[KairosSDKConfigManager sharedManager] showImageCaptureViewAnimationDuration];
    
    // fade in the window
	[UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         
                         _myKeyWindow.alpha     = 1;
                         _myKeyWindow.opaque    = YES;
                         
                     } completion:^(BOOL finished) {
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.didshowimagecaptureview" object:nil];
                         
                         [[KairosSDKConfigManager sharedManager] setCanDetectFaces:YES];
                         [[KairosSDKConfigManager sharedManager] setCanShowFaceDetectBox:YES];
                         
                     }];
}


///////////////////////////////////////////////////////////////
- (void)transitionSlideIn
{
    
    CGFloat duration = [[KairosSDKConfigManager sharedManager] showImageCaptureViewAnimationDuration];

    CGPoint originalCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                         [UIScreen mainScreen].bounds.size.height/2);
    
    _myKeyWindow.center = CGPointMake(originalCenter.x, originalCenter.y * 3);
    _myKeyWindow.alpha     = 1;
    _myKeyWindow.opaque    = YES;
    
    
    // fade in the window
	[UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         
                         _myKeyWindow.center = originalCenter;
                         
                     } completion:^(BOOL finished) {
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.didshowimagecaptureview" object:nil];
                         
                         [[KairosSDKConfigManager sharedManager] setCanDetectFaces:YES];
                         [[KairosSDKConfigManager sharedManager] setCanShowFaceDetectBox:YES];
                         
                     }];
}


///////////////////////////////////////////////////////////////
- (void)transitionAlphaAndSlideIn
{
    CGFloat duration = [[KairosSDKConfigManager sharedManager] showImageCaptureViewAnimationDuration];

    CGPoint originalCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                         [UIScreen mainScreen].bounds.size.height/2);
    
    _myKeyWindow.center = CGPointMake(originalCenter.x, originalCenter.y * 3);
    _myKeyWindow.alpha     = 0;
    _myKeyWindow.opaque    = NO;
    
    
    // fade in the window
	[UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         
                         _myKeyWindow.center = originalCenter;
                         _myKeyWindow.alpha     = 1;
                         _myKeyWindow.opaque    = YES;
                         
                     } completion:^(BOOL finished) {
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.didshowimagecaptureview" object:nil];
                         
                         [[KairosSDKConfigManager sharedManager] setCanDetectFaces:YES];
                         [[KairosSDKConfigManager sharedManager] setCanShowFaceDetectBox:YES];
                         
                     }];
}


///////////////////////////////////////////////////////////////
- (void)transitionAlphaFadeOut
{
    CGFloat duration = [[KairosSDKConfigManager sharedManager] hideImageCaptureViewAnimationDuration];

    __block KairosSDKCore* myself = self;
    __block UIView* myselfView = self.krViewController.view;
    
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         myselfView.window.alpha = 0;
                         self.krViewController.view.window.alpha = 0;
                     }
                     completion: ^(BOOL finished) {
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.didhideimagecaptureview" object:nil];
                         [myselfView removeFromSuperview];
                         //myselfView.alpha = 1;
                         [myself.oldKeyWindow makeKeyAndVisible];
                         myself.myKeyWindow  = nil;
                         myself.oldKeyWindow = nil;
                     }];
}


///////////////////////////////////////////////////////////////
- (void)transitionSlideOut
{
    
    CGFloat duration = [[KairosSDKConfigManager sharedManager] hideImageCaptureViewAnimationDuration];

    CGPoint originalCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                         [UIScreen mainScreen].bounds.size.height/2);
    
    __block KairosSDKCore* myself = self;
    __block UIView* myselfView = self.krViewController.view;
    
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         _myKeyWindow.center = CGPointMake(originalCenter.x, originalCenter.y * 3);
                     }
                     completion: ^(BOOL finished) {
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.didhideimagecaptureview" object:nil];
                         [myselfView removeFromSuperview];
                         [myself.oldKeyWindow makeKeyAndVisible];
                         myself.myKeyWindow  = nil;
                         myself.oldKeyWindow = nil;
                     }];
    
}


///////////////////////////////////////////////////////////////
- (void)transitionAlphaAndSlideOut
{
    CGFloat duration = [[KairosSDKConfigManager sharedManager] hideImageCaptureViewAnimationDuration];

    CGPoint originalCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                         [UIScreen mainScreen].bounds.size.height/2);
    
    __block KairosSDKCore* myself = self;
    __block UIView* myselfView = self.krViewController.view;

    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         _myKeyWindow.center = CGPointMake(originalCenter.x, originalCenter.y * 3);
                         myselfView.window.alpha = 0;
                         self.krViewController.view.window.alpha = 0;
                     }
                     completion: ^(BOOL finished) {
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.sdk.didhideimagecaptureview" object:nil];
                         [myselfView removeFromSuperview];
                         [myself.oldKeyWindow makeKeyAndVisible];
                         myself.myKeyWindow  = nil;
                         myself.oldKeyWindow = nil;
                     }];
}


/*
 * make sure credentials are set */
- (BOOL)validateCredentials
{
    if(!self.appKey)
        return NO;
    
    if(!self.appId)
        return NO;
    
    return YES;
}


#pragma mark - Accessors -
///////////////////////////////////////////////////////////////
-(KairosSDKViewController*)krViewController
{
    if(!_krViewController)
    {
        _krViewController = [[KairosSDKViewController alloc] init];
    }
    
    return _krViewController;
}



#pragma mark - Image Picker Methods -
// These methods wrap our standard methods with an out-of-the-box image picker controller for your convinience.

/*
 * /enroll
 * Takes an image and stores it as a face template into a gallery you define */
- (void)imageCaptureEnrollWithSubjectId:(NSString*)subjectId
                            galleryName:(NSString*)galleryName
                                success:(void (^)(NSDictionary * response, UIImage * image))success
                                failure:(void (^)(NSDictionary * response, UIImage * image))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e, nil);
        return;
    }
    
    if(!subjectId || !galleryName)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e, nil);
        return;
    }
    
    
    // store state
    _selectedMethod     = @"/enroll";
    _subjectId          = subjectId;
    _galleryName        = galleryName;
    _copyOfSuccessBlock = success;
    _copyOfFailureBlock = failure;
    
    [self showUI];
    
}


/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
- (void)imageCaptureRecognizeWithThreshold:(NSString*)threshold
                               galleryName:(NSString*)galleryName
                                   success:(void (^)(NSDictionary * response, UIImage * image))success
                                   failure:(void (^)(NSDictionary * response, UIImage * image))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e, nil);
        return;
    }
    
    if(!threshold || !galleryName)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e, nil);
        return;
    }
    
    // store state
    _selectedMethod     = @"/recognize";
    _threshold          = threshold;
    _galleryName        = galleryName;
    _copyOfSuccessBlock = success;
    _copyOfFailureBlock = failure;
    
    [self showUI];
}


/*
 * /detect
 * Takes an image and returns the facial features found within it */
- (void)imageCaptureDetectWithSelector:(NSString*)selector
                               success:(void (^)(NSDictionary * response, UIImage * image))success
                               failure:(void (^)(NSDictionary * response, UIImage * image))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e, nil);
        return;
    }
    
    if(!selector){
        
        selector = @"FULL";
    }
    
    // store state
    _selectedMethod     = @"/detect";
    _selector           = selector;
    _copyOfSuccessBlock = success;
    _copyOfFailureBlock = failure;
    
    [self showUI];
}


#pragma mark - Standard Methods -
// These are the standard methods wrapped with network requests.

/*
 * /enroll
 * Takes an image and stores it as a face template into a gallery you define */
- (void)enrollWithImage:(UIImage*)image
              subjectId:(NSString*)subjectId
            galleryName:(NSString*)galleryName
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary *response))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    
    if(!image || !subjectId || !galleryName)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    image = [self fixOrientationForImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if ([imageData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64 = [imageData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64 = [imageData base64Encoding];                              // pre iOS7
    }
    NSDictionary *data = @{@"image"      : base64,
                         @"subject_id"   : subjectId,
                         @"gallery_name" : galleryName};
    
    
    // (2) Launch Request
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/enroll"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             [self resetState];
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             [self resetState];
                                             
                                         }];
}

/*
 * /enroll
 * Takes a url to an image and stores it as a face template into a gallery you define */
- (void)enrollWithImageURL:(NSString*)imageURL
                 subjectId:(NSString*)subjectId
               galleryName:(NSString*)galleryName
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary *response))failure
{
    
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    
    if(!imageURL || !subjectId || !galleryName)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    
    NSDictionary *data = @{@"url"          : imageURL,
                           @"subject_id"   : subjectId,
                           @"gallery_name" : galleryName};
    

    // (2) Launch Request
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/enroll"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             [self resetState];
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             [self resetState];
                                             
                                         }];
}

/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
- (void)recognizeWithImage:(UIImage*)image
                 threshold:(NSString*)threshold
               galleryName:(NSString*)galleryName
                maxResults:(NSString*)maxResults
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary *response))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    
    if(!image || !threshold || !galleryName)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    image = [self fixOrientationForImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if ([imageData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64 = [imageData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64 = [imageData base64Encoding];                              // pre iOS7
    }
    NSDictionary *data = @{@"image"      : base64,
                           @"threshold"   : threshold,
                           @"gallery_name" : galleryName};
    
    if(maxResults){
        
        data = @{@"image"      : base64,
                 @"threshold"   : threshold,
                 @"gallery_name" : galleryName,
                 @"max_num_results" : maxResults};
    }
    
    
    // (2) Launch Request
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/recognize"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             [self resetState];
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             [self resetState];
                                             
                                         }];
}


/*
 * /recognize
 * Takes an image and tries to match it against the already enrolled images in a gallery you define */
- (void)recognizeWithImageURL:(NSString*)imageURL
                    threshold:(NSString*)threshold
                  galleryName:(NSString*)galleryName
                   maxResults:(NSString*)maxResults
                      success:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary *response))failure
{
    
    
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    
    if(!imageURL || !threshold || !galleryName)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    NSDictionary *data = @{@"url"      : imageURL,
                           @"threshold"   : threshold,
                           @"gallery_name" : galleryName};
    
    if(maxResults){
        
        data = @{@"url"      : imageURL,
                 @"threshold"   : threshold,
                 @"gallery_name" : galleryName,
                 @"max_num_results" : maxResults};
    }
    
    
    // (2) Launch Request
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/recognize"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             [self resetState];
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             [self resetState];
                                             
                                         }];
    
    
}



/*
 * /detect
 * Takes an image and returns the facial features found within it */
- (void)detectWithImage:(UIImage*)image
               selector:(NSString*)selector
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary *response))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    
    if(!image)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    
    if(!selector){
        
        selector = @"FULL";
    }
    
    image = [self fixOrientationForImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if ([imageData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64 = [imageData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64 = [imageData base64Encoding];                              // pre iOS7
    }
    NSDictionary *data = @{@"image"      : base64,
                           @"selector"   : selector};

    
    // (2) Launch Request
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/detect"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             [self resetState];
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             [self resetState];
                                             
                                         }];
    
}


/*
 * /detect
 * Takes an image url string and returns the facial features found */
- (void)detectWithImageURL:(NSString*)imageURL
                  selector:(NSString*)selector
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary *response))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    if(!imageURL)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    
    if(!selector){
        
        selector = @"FULL";
    }
    
    
    NSDictionary *data = @{@"url"      : imageURL,
                           @"selector" : selector};
    
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/detect"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             
                                         }];
    
}



/*
 * /gallery/list_all
 * Lists out all the galleries you have subjects enrolled in */
- (void)galleryListAllWithSuccess:(void (^)(NSDictionary * response))success
                          failure:(void (^)(NSDictionary *response))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/gallery/list_all"
                                      parameters:nil
                                         success:^(id response){
                                             
                                             success(response);
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             
                                         }];
}

/*
 * /gallery/view
 * Lists out all the subjects you have enrolled in a specified gallery */
- (void)galleryView:(NSString*)galleryName
            success:(void (^)(NSDictionary * response))success
            failure:(void (^)(NSDictionary *response))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    if(!galleryName)
    {
        NSDictionary *e = @{@"NSLocalizedDescriptionKey":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    NSDictionary *data = @{@"gallery_name" : galleryName};
    
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/gallery/view"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             
                                         }];
    
}


/*
 * /gallery/remove_subject
 * Removes a subject from a specified gallery */
- (void)galleryRemoveSubject:(NSString*)subjectId
                 fromGallery:(NSString*)galleryName
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary *response))failure
{
    if([self validateCredentials] == NO)
    {
        NSDictionary *e = @{@"error":@"Empty app id or app key."};
        failure(e);
        return;
    }
    
    if(!galleryName || !subjectId)
    {
        NSDictionary *e = @{@"error":@"Empty API parameters."};
        failure(e);
        return;
    }
    
    NSDictionary *data = @{@"gallery_name" : galleryName,
                           @"subject_id"   : subjectId};
    
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:@"/gallery/remove_subject"
                                      parameters:data
                                         success:^(id response){
                                             
                                             success(response);
                                             
                                         }
                                         failure:^(id response){
                                             
                                             failure(response);
                                             
                                         }];
    
    
}






#pragma mark - Network Helpers - 

///////////////////////////////////////////////////////////////////////////////////////////////////
- (KR_AFHTTPRequestOperation*)enqueuePlainRequestOperationWithMethod:(NSString *)method
                                                                path:(NSString *)path
                                                          parameters:(NSDictionary *)parameters
                                                             success:(void (^)(id responseObject))success
                                                             failure:(void (^)(NSDictionary *response))failure
{
    
    NSURL *apiURL = [NSURL URLWithString:kKairosSDKAPIEndpointHost];
    KR_AFHTTPClient *client = [[KR_AFHTTPClient alloc] initWithBaseURL:apiURL];
    [client setParameterEncoding:KR_AFJSONParameterEncoding];
    [client setDefaultHeader:@"app_id" value:self.appId];
    [client setDefaultHeader:@"app_key" value:self.appKey];
    
    NSMutableURLRequest *request = [client requestWithMethod:method
                                                      path:path
                                                parameters:parameters];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [client setDefaultHeader:@"Content-Encoding" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Encoding" value:@"application/json"];
    
    KR_AFHTTPRequestOperation *requestOperation =
    [client HTTPRequestOperationWithRequest:request
                                  success:^(KR_AFHTTPRequestOperation *operation, id responseObject){
                                      
                                      NSError *error = nil;
                                      NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      if (error){
                                          
                                          failure(@{@"error":@"an unknown error occured"});
                                          
                                      }else{
                                          
                                          if(JSON[@"errors"] || JSON[@"error"])
                                          {
                                              
                                              failure(JSON);
                                              
                                          }else{
                                          
                                              success(JSON);
                                              
                                          }
                                      }
                                      
                                  } failure:^(KR_AFHTTPRequestOperation *operation, NSError *error) {
                                      failure(@{@"error" : error.localizedRecoverySuggestion});
                                  }];
    
    [client enqueueHTTPRequestOperation:requestOperation];
    
    return requestOperation;
}


#pragma mark - Image Helpers -
/*
 * Take a CIImage, convert into data for the API, pass onto selected API method */
- (void)completeWithImage:(CIImage*)ciimage
{
    
    NSData *compressedImageData = [self compressCIImage:ciimage];
    
    if ([compressedImageData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64 = [compressedImageData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64 = [compressedImageData base64Encoding];                              // pre iOS7
    }
    
    [self beginAPIRequest];
    
}


- (NSData *)compressCIImage:(CIImage *)coreImage {
    
    // Get UIImage
    UIImage *face = [self uiimageFromCiimage:coreImage andOrientation:UIImageOrientationRight];
    
    // Fix Orientation
    face = [self fixOrientationForImage:face];
    
    // Resize to screen size
    face = [self resizeImage:face scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,
                                                          [UIScreen mainScreen].bounds.size.height)];

    // Crop to rect if needed
    if([[KairosSDKConfigManager sharedManager] croppingEnabled] == YES)
    {
        
        face = [self cropImage:face toRect:[[KairosSDKConfigManager sharedManager] faceBoxRect]];
        
    }
    
    CGFloat ratio = 240 / face.size.width;
    CGFloat newWidth  = face.size.width * ratio;
    CGFloat newHeight = face.size.height * ratio;

    face = [self resizeImage:face scaledToSize:CGSizeMake(newWidth, newHeight)];
    
    [[KairosSDKConfigManager sharedManager] setCapturedImage:face];
    
    face = [self convertToGreyscale:face];
    
    NSData *compressedImageData = UIImageJPEGRepresentation(face, 0.55f);
    
    if(!compressedImageData)
    {
        NSLog(@"PROBLEM");
    }
    
    return compressedImageData;
    
}


- (UIImage*)cropImage:(UIImage *)image toRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

- (UIImage*)uiimageFromCiimage:(CIImage*)ciimage andOrientation:(UIImageOrientation)orientation
{
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    struct CGImage * cgiImage = [context createCGImage:ciimage fromRect:ciimage.extent];
    
    UIImage *uiimage = [UIImage imageWithCGImage:cgiImage
                                           scale:1.0
                                     orientation:orientation];
    
    if(cgiImage)
        CFRelease(cgiImage);
    
    return uiimage;
}



- (UIImage *)fixOrientationForImage:(UIImage*)img
{
    
    // No-op if the orientation is already correct
    if (img.imageOrientation == UIImageOrientationUp)
    {
        return img;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            //NSLog(@"s1.c1");
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            //NSLog(@"s1.c2");

            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            //NSLog(@"s1.c3");

            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            //NSLog(@"s1.c4");

            break;
    }
    
    switch (img.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            //NSLog(@"s2.c1");

            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            //NSLog(@"s2.c2");

            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            //NSLog(@"s2.c3");

            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             img.size.width,
                                             img.size.height,
                                             CGImageGetBitsPerComponent(img.CGImage),
                                             0,
                                             CGImageGetColorSpace(img.CGImage),
                                             CGImageGetBitmapInfo(img.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage);
            //NSLog(@"draw1");

            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage);
            //NSLog(@"draw2");

            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    return img;
    
    
    //return [self scaleAndRotateImage:img];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


- (UIImage *)convertToGreyscale:(UIImage *)i
{
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}


- (UIImage*)resizeImage:(UIImage*)image
           scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark - General Helpers -

- (void)beginAPIRequest
{
    
    if(!_selectedMethod){
        
        if(_copyOfFailureBlock){
            
            NSDictionary *e = @{@"error":@"Empty api method."};
            _copyOfFailureBlock(e, nil);
        }
        return;
    }
    
    
    if(!base64){
        
        if(_copyOfFailureBlock){
            
            NSDictionary *e = @{@"error":@"Image data null."};
            _copyOfFailureBlock(e, nil);
        }
        return;
    }
    
    
    // (1) Prepare params based on the selected API method
    NSDictionary *data;
    
    if(KARStringEqualsString(_selectedMethod, @"/enroll")){
        
        data = @{@"image"    : base64,
                 @"subject_id" : _subjectId,
                 @"gallery_name" : _galleryName};
    }
    
    if(KARStringEqualsString(_selectedMethod, @"/recognize")){
        
        data = @{@"image"    : base64,
                 @"threshold" : _threshold,
                 @"gallery_name" : _galleryName};
        
        if(_maxResults){
            
            data = @{@"image"    : base64,
                     @"threshold" : _threshold,
                     @"gallery_name" : _galleryName,
                     @"max_num_results" : _maxResults};
        }
    }
    
    if(KARStringEqualsString(_selectedMethod, @"/detect")){
        
        data = @{@"image"    : base64,
                 @"selector" : _selector};
        
    }
    

    // (2) Launch Request
    [self enqueuePlainRequestOperationWithMethod:@"POST"
                                            path:_selectedMethod
                                      parameters:data
                                         success:^(id response){
                                             
                                             /*
                                             _copyOfSuccessBlock(response);
                                             [self resetState];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [self hideUI];
                                             });
                                              */
                                             _responseDidSucceed = YES;
                                             _responseDict = response;
                                             
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.internal.requestreturned"
                                                                                                 object:nil];

                                         }
                                         failure:^(id response){
                                             
                                             /*
                                             _copyOfFailureBlock(response);
                                             [self resetState];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [self hideUI];
                                             });
                                              */
                                             _responseDidSucceed = NO;
                                             _responseDict = response;

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"com.kairos.internal.requestreturned"
                                                                                                 object:nil];
                                         }];
    
}


- (void)finishImageCaptureAndCallback
{
    // should never happen but just in case
    if(!_responseDict)
        return;
    
    UIImage *image = [[KairosSDKConfigManager sharedManager] capturedImage];
    
    if(_responseDidSucceed == YES){
        
        _copyOfSuccessBlock(_responseDict, image);
        
    }else{
        
        _copyOfFailureBlock(_responseDict, image);
    }
    
    [self resetState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideUI];
    });
}

- (void)resetState
{
    
    _copyOfFailureBlock = nil;
    _copyOfSuccessBlock = nil;
    _selector           = nil;
    _selectedMethod     = nil;
    _subjectId          = nil;
    _galleryName        = nil;
    _threshold          = nil;
    _maxResults         = nil;
    _responseDict       = nil;
    _responseDidSucceed = NO;
    [[KairosSDKConfigManager sharedManager] setCapturedImage:nil];
    
}

@end
