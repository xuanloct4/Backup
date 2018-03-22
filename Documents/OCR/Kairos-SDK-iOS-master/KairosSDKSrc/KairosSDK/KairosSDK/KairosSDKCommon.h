//
//  KRCommon.h
//  KairosSDK
//
//  Created by Eric Turner on 3/14/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>

/*!
 A more thorough emptyness test
 @params thing : a general object (strings, arrays, dictionaries)
 */
BOOL IsEmpty(id thing);

NSString * KARTimeUTC(NSDate *date);

NSString * KARTimeLocal(NSDate *date);

NSString * KARTimezone();

NSNumber * KARTimezoneOffset(NSDate *date);

NSNumber * KARTimeIsDaylightSavings();

UIImage * KARColorImage(UIImage *source, UIColor *color);

/*!
 Color with Hex
 @params hex : Hex color code ex.FFFFFF
 */
UIColor* colorWithHexString(NSString* hex);

/** Case insensitive String Compare ***/
BOOL KARStringEqualsString(NSString *stringA, NSString *stringB);

/*!
 Face Roll
 */
NSNumber * KARFaceRoll();

/*!
 Face Yaw
 */
NSNumber * KARFaceYaw();


NSNumber * KARLivenessTotalSessionFrames();


NSNumber * KARLivenessTotalEvents();


/*!
 Device Model (iPhone, iPad, etc)
 */
NSString * KARDeviceModel();

/*!
 Build number
 */
NSString* KARBuildNumber();

/*!
 iOS Version
 */
NSString * KARiOSVersion();

/*!
 App Version
 */
NSString * KARAppVersion();


/*!
 Latitude (Returns NSNumber or NSNull)
 */
id KARLatitude();


/*!
 Longitude (Returns NSNumber or NSNull)
 */
id KARLongitude();


/*!
 Location Accuracy (Returns NSNumber or NSNull)
 */
id KARLocationAccuracy();


/*!
 Location Time (Returns NSString or NSNull)
 */
id KARLocationTimestamp();


/*!
 Location Error (Returns NSString or NSNull)
 */
id KARLocationError();

/*
 Change [NSNull null] String values into strings (or vice versa) for local storage
 */
NSString * KARDeflateNullString(id obj);
id KARInflateNullString(NSString * str);

NSString * KARDeflateNullNumber(id obj);
id KARInflateNullNumber(NSString * str);



