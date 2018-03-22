//
//  AppDelegate.m
//  KairosSDKExample
//
//  Created by Eric Turner on 3/13/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import "AppDelegate.h"
#import <KairosSDK/KairosSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    
#pragma mark - Kairos SDK (Authentication)

    /*************** Authentication ****************
     * Set your credentials once and then call one *
     * of the API methods listed below             *
     ***********************************************/
    [KairosSDK initWithAppId:@"app_id" appKey:@"app_key"];

    
#pragma mark - Kairos SDK (Configuration Options)

    
    /********** Configuration Options **************
     * Set your options. These are just a few      *
     * of the available options. See the complete  *
     * documentation in KairosSDK.h                *
     ***********************************************/
    [KairosSDK setStillImageTintColor:@"DBDB4D"];
    [KairosSDK setProgressBarTintColor:@"FFFF00"];
    [KairosSDK setFaceDetectBoxColorValid:@"CCFF33"];
    [KairosSDK setFaceDetectBoxColorInvalid:@"333333"];
    [KairosSDK setFaceDetectBoxBorderThickness:8];
    [KairosSDK setErrorMessageBackgroundColor:@"999900"];
    [KairosSDK setErrorMessageFontSize:26];

#pragma mark - Kairos SDK (Notifications)

    
    /**************** Notifications ****************
     * Register for any of the available           *
     * notifications                               *
     ***********************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kairosNotifications:)
                                                 name:KairosDidCaptureImageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kairosNotifications:)
                                                 name:KairosWillShowImageCaptureViewNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kairosNotifications:)
                                                 name:KairosWillHideImageCaptureViewNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kairosNotifications:)
                                                 name:KairosDidHideImageCaptureViewNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kairosNotifications:)
                                                 name:KairosDidShowImageCaptureViewNotification
                                               object:nil];
    
    
    
#pragma mark - Kairos SDK (Image-Capture View API Methods)
    
    /************ Image Capture Enroll *************
     * This /enroll call will display an image     *
     * capture view, and send the captured image   *
     * to the API to enroll the image.             *
     ***********************************************
    [KairosSDK imageCaptureEnrollWithSubjectId:@"12"
                                   galleryName:@"gallery1"
                                       success:^(NSDictionary *response, UIImage *image) {
                                           
                                           NSLog(@"%@", response);
                                           
                                       } failure:^(NSDictionary *response, UIImage *image) {
                                           
                                           NSLog(@"%@", response);
                                           
                                       }];*/
    
    
    /********* Image Capture Recognize *************
     * This /recognize call will display an image  *
     * capture view, and send the captured image   *
     * to the API to match against your galleries  *
     ***********************************************
    [KairosSDK imageCaptureRecognizeWithThreshold:@".75"
                                      galleryName:@"gallery1"
                                          success:^(NSDictionary *response, UIImage *image) {
     
                                              NSLog(@"%@", response);
                                              
                                          } failure:^(NSDictionary *response, UIImage *image) {
                                              
                                              NSLog(@"%@", response);
                                              
                                          }];*/
    
    
    
    /************ Image Capture Detect *************
     * This /detect call will display an image     *
     * capture view, and send the captured image   *
     * to the API and return face attributes       *
     ***********************************************
    [KairosSDK imageCaptureDetectWithSelector:@"SETPOSE"
                                      success:^(NSDictionary *response, UIImage *image) {
                                          
                                          NSLog(@"%@", response);
                                          
                                      } failure:^(NSDictionary *response), UIImage *image) {
                                          
                                          NSLog(@"%@", response);
                                          
                                      }];*/
    
    
    
    
#pragma mark - Kairos SDK (Standard API Methods) -
    
    /************** Enroll With Image **************
     * This /enroll call accepts a local image and *
     * sends it to the API to enroll in your       *
     * gallery.                                    *
     ***********************************************
    UIImage *localImage = [UIImage imageNamed:@"liz.jpg"];
    [KairosSDK enrollWithImage:localImage
                     subjectId:@"13"
                   galleryName:@"gallery1"
                       success:^(NSDictionary *response) {
                           
                           NSLog(@"%@", response);
                           
                       } failure:^(NSDictionary *response)) {
                           
                           NSLog(@"%@", response);
                           
                       }];*/
    
    
    
    /************** Enroll With URL ****************
     * This /enroll call accepts a URL to an       *
     * external image and sends it to the API      *
     * to enroll in your gallery.                  *
     ***********************************************
    NSString *imageURL = @"http://media.kairos.com/liz.jpg";
    [KairosSDK enrollWithImageURL:imageURL
                        subjectId:@"13"
                      galleryName:@"gallery2"
                          success:^(NSDictionary *response) {
                              
                              NSLog(@"%@", response);
                              
                          } failure:^(NSDictionary *response)) {
                              
                              NSLog(@"%@", response);
                              
                          }];*/
    
    
    
    
    /************ Recognize With Image *************
     * This /recognize call accepts an image,      *
     * sends the image to the API to match against *
     * your galleries                              *
     ***********************************************
    UIImage *localImage = [UIImage imageNamed:@"liz.jpg"];
    [KairosSDK recognizeWithImage:localImage
                        threshold:@".75"
                      galleryName:@"gallery1"
                       maxResults:@"10"
                          success:^(NSDictionary *response) {
                              
                              NSLog(@"%@", response);
                              
                          } failure:^(NSDictionary *response)) {
                              
                              NSLog(@"%@", response);
                              
                          }];*/
    
    
    
    /********* Recognize With Image URL ************
     * This /recognize call accepts a URL to an    *
     * image, sends the image to the API to match  *
     * against your galleries                      *
     ***********************************************
    NSString *imageURL = @"http://media.kairos.com/liz.jpg";
    [KairosSDK recognizeWithImageURL:imageURL
                           threshold:@".75"
                         galleryName:@"gallery1"
                          maxResults:@"10"
                             success:^(NSDictionary *response) {
                                 
                                 NSLog(@"%@", response);
                                 
                             } failure:^(NSDictionary *response)) {
                                 
                                 NSLog(@"%@", response);
                                 
                             }];*/
    
    
    

    /************** Detect With Image **************
     * This /detect call uses a local image        *
     ***********************************************
     UIImage *localImage = [UIImage imageNamed:@"liz.jpg"];
    [KairosSDK detectWithImage:localImage
                      selector:@"SETPOSE"
                       success:^(NSDictionary *response) {
                           
                           NSLog(@"%@", response);
                           
                       } failure:^(NSDictionary *response)) {
                           
                           NSLog(@"%@", response);
                           
                       }];*/
    
    
    
    
    
     /************** Detect With URL ***************
     * This /detect call sends a URL string to an  *
     * external image resource to the API and      *
     * return face attributes                      *
     ***********************************************
    NSString *imageURL = @"http://media.kairos.com/liz.jpg";
    [KairosSDK detectWithImageURL:imageURL
                         selector:@"SETPOSE"
                          success:^(NSDictionary *response) {
                              
                              NSLog(@"%@", response);
                              
                          } failure:^(NSDictionary *response)) {
                              
                              NSLog(@"%@", response);
                              
                          }];*/
    
    
    
    

    /************** List Galleries *****************
     * This /gallery/list_all call returns a list  *
     * of all galleries you have created           *
     ***********************************************
    [KairosSDK galleryListAllWithSuccess:^(NSDictionary *response) {
     
        NSLog(@"%@", response);
     
    } failure:^(NSDictionary *response)) {
     
        NSLog(@"%@", response);
     
    }];*/
    
    
    
    

    
    /************** View Gallery *******************
     * This /gallery/view call returns a list of   *
     * all subjects enrolled in a given gallery    *
     ***********************************************
    [KairosSDK galleryView:@"gallery1"
                   success:^(NSDictionary *response) {
                       
                       NSLog(@"%@", response);
                       
                   } failure:^(NSDictionary *response)) {
                       
                       NSLog(@"%@", response);
                       
                   }];*/
    
    
    
  
    
    /******** Remove Subject From Gallery **********
     * This /gallery/remove_subject call removes a *
     * give subject from a given gallery           *
     ***********************************************
    [KairosSDK galleryRemoveSubject:@"13"
                        fromGallery:@"gallery1"
                            success:^(NSDictionary *response) {
                                
                                NSLog(@"%@", response);
                                
                            } failure:^(NSDictionary *response)) {
                                
                                NSLog(@"%@", response);
                                
                            }];*/
    


    return YES;
}

#pragma mark    Kairos SDK Test Button -

- (void)kairosSDKStartMethod
{
    
    /************ Image Capture Enroll *************
     * This /enroll call will display an image     *
     * capture view, and send the captured image   *
     * to the API to enroll the image.             *
     ***********************************************
    [KairosSDK imageCaptureEnrollWithSubjectId:@"eric4"
                                   galleryName:@"ericsGallery3"
                                       success:^(NSDictionary *response, UIImage *image) {
                                           
                                           // Response in JSON format
                                           NSLog(@"%@", response);
                                           
                                           // (Optional) View the captured image in your Photo Album
                                           //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

                                           
                                       } failure:^(NSDictionary *response, UIImage *image) {
                                           
                                           NSLog(@"%@", response);
                                           
                                       }];*/

    
    
    /************** View Gallery *******************
     * This /gallery/view call returns a list of   *
     * all subjects enrolled in a given gallery    *
     ***********************************************
    [KairosSDK galleryView:@"ericsGallery3"
                   success:^(NSDictionary *response) {
                       
                       NSLog(@"%@", response);
                       
                   } failure:^(NSDictionary *response) {
                       
                       NSLog(@"%@", response);
                       
                   }];*/
    

    
    /************** Detect With Image **************
     * This /detect call uses a local image        *
     ***********************************************
    UIImage *localImage = [UIImage imageNamed:@"liz.jpg"];
    
    [KairosSDK detectWithImage:localImage
                      selector:@"SETPOSE"
                       success:^(NSDictionary *response) {
                           
                           NSLog(@"%@", response);
                           
                       } failure:^(NSDictionary *response) {
                           
                           NSLog(@"%@", response);
                           
                       }];*/
    
}


- (void)kairosNotifications:(id)sender
{
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
