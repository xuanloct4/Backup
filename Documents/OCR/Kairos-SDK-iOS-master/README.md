Kairos SDK (iOS)
==============

Kairos is the easist way add **Face-Recognition** to your iOS apps. Our API provides a full-featured and robust Face-Recognition backend, right out of the box. This is the iOS wrapper for the [Kairos Facial Recognition API](https://www.kairos.com). The package includes both the **SDK** as well as an **example app project**. Continue reading to learn how to integrate Kairos into your iOS apps.

_Thanks to contributions by some of our customers, we also have [Javascript](https://github.com/kairosinc/Kairos-SDK-Javascript), [Android](https://github.com/kairosinc/Kairos-SDK-Android) and [PHP](https://github.com/kairosinc/Kairos-SDK-PHP) SDKs, and wrappers for [Ruby](https://github.com/kany/kairos-api) and [.NET](https://github.com/humbywan/Kairos.Net)._

## What You'll Need
* An XCode iOS app project targeting 6.1 or greater
* An iOS device (6.1+) with a camera
* Internet connectivity for your device



---



## How to do a Quick Demo
If you just want to do a quick test run, open the **example app project** that is included with the SDK and follow these steps:

1. [Create your free developer account](https://www.kairos.com/signup)
2. Log into the Kairos Developer Dashboard
3. Create an application and copy your **App Id** & **App Key**
3. Paste them into the authentication method in AppDelegate.m 
4. Run the app on your **device**, and tap the test button (**Note:** At this time the example app only compiles for the device (not the simulator))



---


## How to Install Kairos in your own App

1. [Create your free Kairos developer account](https://www.kairos.com/signup) if you don't already have one.
2. Log into the [dashboard](https://www.kairos.com/login) and create a new app.
3. Copy your **App ID** & **App Key** (you'll need them later).
4. [Download](https://github.com/kairosinc/Kairos-SDK-iOS) the SDK and unzip the package.
5. Open the folder named **Kairos-SDK-iOS** containing the SDK library and header files.
6. Drag the SDK library file (**libKairosSDK.a**) into your xcode project.
7. Drag the SDK header file (**KairosSDK.h**) into your xcode project.
8. In the "Build Phases" section of your project target, navigate to "**Link Binary with Libraries**" and add libKairosSDK.a to the list (if not already there).
9. While you're still in "Link Binary with Libraries" add the frameworks: 
	* UIKit.framework
	* Foundation.framework
	* CoreImage.framework
	* CoreMedia.framework
	* CoreGraphics.framework
	* AVFoundation.framework
	* AudioToolbox.framework


10. **IMPORTANT**: In the "Build Settings" section of your project target, navigate to "Other Linker Flags" and add '-all_load' if not already present.
  
11. Import the framework header wherever you want to use the SDK

```
 #import "KairosSDK.h"
```

## Authenticate Once

Before you can make API calls you'll need to pass Kairos your credentials **App Id** and **App Key** (You only need to do this once). Paste your App Id and App Key into the init method initWithAppId:appKey:

```
[KairosSDK initWithAppId:@"appID" appKey:@"appKey"];
```



## Image-Capture & 'Enroll'

The **Enroll** method **registers a face for later recognitions**. Here's an example of enrolling a face (subject) using one of the image-capture methods. This method displays an image-capture view in your app, captures an image of a face, and enrolls it:    

```
[KairosSDK imageCaptureEnrollWithSubjectId:@"12" 
                               galleryName:@"gallery1" 
                                   success:^(NSDictionary *response, UIImage *image) {
                                    
                                       NSLog(@"%@", response); 
                                   } 
                                   failure:^(NSDictionary *response, UIImage *image) {
                                    
                                       NSLog(@"%@", response); 
                                   }];
```


## Image-Capture & 'Recognize'

The **Recognize** method takes an image of a subject and **attempts to match it against a given gallery of previously-enrolled subjects**. Here's an example of recognizing a subject using an image-capture method. This method displays an image-capture view in your app, captures an image of a face, sends it to the API, and returns a match and confidence value:    

```
[KairosSDK imageCaptureRecognizeWithThreshold:@".75"
                                  galleryName:@"gallery1"
                                      success:^(NSDictionary *response, UIImage *image){
                                      
											NSLog(@"%@", response);
									   } 
									   failure:^(NSDictionary *response, UIImage *image) {
									   
                                           NSLog(@"%@", response);     
                                      }];
```
    
    
    
## Image-Capture & 'Detect'

The **Detect** method takes an image of a subject and **returns various attributes pertaining to the face features**. The detect methods also accept an optional 'selector' parameter, allowing you to tweak the scope of the response ([see docs](https://www.kairos.com/docs/face-recognition) for more info on the detect selector). Here's an example of using detect via an image-capture method to retrieve the face attributes:    

```
[KairosSDK imageCaptureDetectWithSelector:nil
                                  success:^(NSDictionary *response, UIImage *image){
                                  
                                  		NSLog(@"%@", response);
                                  }
                                  failure:^(NSDictionary *response, UIImage *image){
                                  
                                      NSLog(@"%@", response);
                                  }];
```
    
## Standard Methods

The three methods introduced above are all 'Image-Capture' methods. Meaning, they all present a view that captures an image from the camera for you. But if you'd like to provide your own images, or want to develop your own image capture view, Kairos provides unwrapped versions of these methods as well. Below you'll see an example of two flavors of the recognize method, one accepts an image (UIImage), another accepts a URL (NSString) to an external image.

```
// This recognize method accepts an image
UIImage *localImage = [UIImage imageNamed:@"sample.jpg"];
[KairosSDK recognizeWithImage:localImage
                    threshold:@".75"
                  galleryName:@"gallery1"
                   maxResults:@"10"
                      success:^(NSDictionary *response) {
                              
                          NSLog(@"%@", response);
                      } 
                      failure:^(NSDictionary *response) {
                              
                          NSLog(@"%@", response);
                      }];
                      
                          
// This recognize method accepts a url                          
NSString *imageURL = @"http://media.kairos.com/liz.jpg";
[KairosSDK recognizeWithImageURL:imageURL
                       threshold:@".75"
                     galleryName:@"gallery1"
                      maxResults:@"10"
                         success:^(NSDictionary *response) {
                                 
                             NSLog(@"%@", response);
                         } 
                         failure:^(NSDictionary *response) {
                                 
                             NSLog(@"%@", response);
                         }];
```
    
    
## Optional Customization

The Kairos SDK offers options for configuring and customizing the tool to fit your use-case. You're able to specify colors, font size, transition duration and type, camera preferences, localization strings, and more. Below are just a few examples of how you can configure Kairos. (See KairosSDK.h for the full list of available configuration options):    

```
    [KairosSDK setPreferredCameraType:KairosCameraFront];
    [KairosSDK setEnableFlash:YES];
    [KairosSDK setEnableCropping:NO];
    [KairosSDK setEnableShutterSound:NO];
    [KairosSDK setStillImageTintColor:@"DBDB4D"];
    [KairosSDK setProgressBarTintColor:@"FFFF00"];
    [KairosSDK setErrorMessageMoveCloser:@"ちょっと近づいてね"];
```


    
## Available Notification Events
Optionally register for Kairos SDK events by adding your controller as an observer to the following SDK notifications:



#####KairosWillShowImageCaptureViewNotification
	Fires before the image-capture view is displayed

#####KairosWillHideImageCaptureViewNotification
	Fires before the image-capture view is hidden

#####KairosDidShowImageCaptureViewNotification
	Fires after the image-capture view has been displayed

#####KairosDidHideImageCaptureViewNotification
	Fires after the image-capture view has been hidden

#####KairosDidCaptureImageNotification
	Fires after an image has been captured



## View the Examples

Also see provided example app project **KairosSDKExampleApp** included in the SDK download bundle. It contains clear examples on how to use all of the available methods in the file AppDelegate.m. Also, check out the API documentation at [https://developer.kairos.com/docs](https://www.kairos.com/docs/face-recognition)

[![Stack Share](http://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](http://stackshare.io/kairos-api/kairos-facial-recognition-api)

---

## Source Code

Note: We have added the raw source code to the SDK so that you can make any changes / modifications as needed.  In the future we plan to add better documentation around the source code, build instructions, etc. but we wanted to get it out there as soon as possible as requested by a number of our customers. Feel free to use / modify / redistribute this as needed in your apps.

If you see anything you'd like to change, fix, etc. please feel free to submit a pull request, that we will happily accept.


---


##Support 
Have an issue? Visit our [Support page](http://www.kairos.com/support) or [create an issue on GitHub](https://github.com/kairosinc/Kairos-SDK-iOS)


