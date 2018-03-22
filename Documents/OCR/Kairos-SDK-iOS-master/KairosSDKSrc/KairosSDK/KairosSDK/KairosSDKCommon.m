//
//  KRCommon.m
//  KairosSDK
//
//  Created by Eric Turner on 3/14/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import "KairosSDKCommon.h"
#import "KairosSDKConfigManager.h"


////////////////////////////////////////////
BOOL IsEmpty(id thing)
{
    
    if(thing == nil)
        return YES;
    
    if([thing isKindOfClass:[NSNull class]])
        return YES;
    
    if([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0)
        return YES;
    
    if([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0)
        return  YES;
    
    return NO;
}

////////////////////////////////////////////
NSString * KARTimeUTC(NSDate *date){
    
    NSDateFormatter *dateFormatterGMT=[[NSDateFormatter alloc] init];
    [dateFormatterGMT setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    dateFormatterGMT.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatterGMT setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *newDateString = [dateFormatterGMT stringFromDate:date];
    
    return newDateString;
}


////////////////////////////////////////////
NSString * KARTimeLocal(NSDate *date){
    
    NSDateFormatter *dateFormatterLocal=[[NSDateFormatter alloc] init];
    [dateFormatterLocal setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    dateFormatterLocal.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *localDateString = [dateFormatterLocal stringFromDate:date];
    
    return localDateString;
}


////////////////////////////////////////////
NSString * KARTimezone(){
    
    NSTimeZone *currentTimeZon = [NSTimeZone localTimeZone];
    NSString *systemTimeZone = [currentTimeZon name];
    return systemTimeZone;
}

////////////////////////////////////////////
NSNumber * KARTimeIsDaylightSavings(){
    
    NSTimeZone *currentTimeZon = [NSTimeZone localTimeZone];
    
    bool isDST = false;
    
    if ([currentTimeZon isDaylightSavingTime])
    {
        isDST = true;
    }
    
    return [[NSNumber alloc] initWithBool:isDST];
}


////////////////////////////////////////////
NSNumber * KARTimezoneOffset(NSDate *date){
    
    NSTimeZone *currentTimeZon = [NSTimeZone localTimeZone];
    
    bool isDST = false;
    
    if ([currentTimeZon isDaylightSavingTime])
    {
        isDST = true;
    }
    else
    {
        isDST = false;
        
    }
    
    NSTimeInterval timeZoneOffsetSeconds = [currentTimeZon secondsFromGMTForDate:date];
    
    double timeZoneOffsetMinsDouble = timeZoneOffsetSeconds / 60;
    
    NSNumber *timeZoneOffsetMinsNSNum = [NSNumber numberWithDouble:timeZoneOffsetMinsDouble];
    
    return timeZoneOffsetMinsNSNum;
    
}


////////////////////////////////////////////
BOOL KARStringEqualsString(NSString *stringA, NSString *stringB){
    
    BOOL same = [[stringA lowercaseString] isEqualToString:[stringB lowercaseString]];
    
    return same;
}


UIImage * KARColorImage(UIImage *source, UIColor *color)
{
    UIGraphicsBeginImageContextWithOptions(source.size, NO, source.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextClipToMask(context, rect, source.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


////////////////////////////////////////////
UIColor* colorWithHexString(NSString* hex)
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


////////////////////////////////////////////
NSNumber * KARFaceRoll(){
    
    CGFloat faceRoll = [[KairosSDKConfigManager sharedManager] faceRoll];
    return [NSNumber numberWithDouble:faceRoll];
}

////////////////////////////////////////////
NSNumber * KARFaceYaw(){
    
    CGFloat faceYaw = [[KairosSDKConfigManager sharedManager] faceYaw];
    return [NSNumber numberWithDouble:faceYaw];
}

////////////////////////////////////////////
NSString * KARBuildNumber(){
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}


////////////////////////////////////////////
NSString * KARDeviceModel(){
    
    NSString *deviceType = [UIDevice currentDevice].model;
    return deviceType;
    
}


////////////////////////////////////////////
NSString * KARiOSVersion(){
    
    return [[UIDevice currentDevice] systemVersion];
    
}

////////////////////////////////////////////
NSString * KARAppVersion(){
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}



////////////////////////////////////////////
id KARLatitude(){
    
    /*
    NSNumber *number = [[KARLocationManager sharedManager] latitude];
    if(!number)
    {
        return [NSNull null];
    }
    return number;
     */
    return [NSNull null];
}




////////////////////////////////////////////
id KARLongitude(){
    
    /*
    NSNumber *number = [[KARLocationManager sharedManager] longitude];
    if(!number)
    {
        return [NSNull null];
    }
    return number;
     */
    
    return [NSNull null];

}



////////////////////////////////////////////
id KARLocationAccuracy(){
    
    /*
    NSNumber *number = [[KARLocationManager sharedManager] accuracy];
    if(!number)
    {
        return [NSNull null];
    }
    
    return number;
     */
    
    return [NSNull null];

}


////////////////////////////////////////////
id KARLocationTimestamp(){
    
    /*
    NSString *time = [[KARLocationManager sharedManager] timestamp];
    if(!time)
    {
        return [NSNull null];
    }
    
    return time;
     */
    return [NSNull null];

}


////////////////////////////////////////////
id KARLocationError(){
    
    /*
    NSString *errorstr = [[KARLocationManager sharedManager] error];
    if(!errorstr)
    {
        return [NSNull null];
    }
    
    return errorstr;
     */
    return [NSNull null];

}


////////////////////////////////////////////
NSString * KARDeflateNullString(id obj){
    
    if([obj isMemberOfClass:[NSNull class]])
    {
        return @"NULL";
    }
    
    return obj;
}

////////////////////////////////////////////
id KARInflateNullString(NSString * str){
    
    if(KARStringEqualsString(str, @"NULL") == YES)
    {
        return [NSNull null];
        
    }
    
    return str;
}


////////////////////////////////////////////
NSString * KARDeflateNullNumber(id obj){
    
    if([obj isMemberOfClass:[NSNull class]])
    {
        return @"NULL";
    }
    
    NSNumber *n = (NSNumber *)obj;
    return [NSString stringWithFormat:@"%f", [n doubleValue]];
}

////////////////////////////////////////////
id KARInflateNullNumber(NSString * str){
    
    if(KARStringEqualsString(str, @"NULL") == YES)
    {
        return [NSNull null];
        
    }
    
    return [NSNumber numberWithDouble:[str doubleValue]];
}


////////////////////////////////////////////
NSNumber * KARLivenessTotalSessionFrames(){
    
    NSNumber *faceDetectFrames = [NSNumber numberWithInt:[[KairosSDKConfigManager sharedManager] numberOfFaceDetectionFrames]];
    
    return faceDetectFrames;
}


////////////////////////////////////////////
NSNumber * KARLivenessTotalEvents(){
    
    NSNumber *livenessEvents = [NSNumber numberWithInt:[[KairosSDKConfigManager sharedManager] numberOfLivenessDetections]];
    
    return livenessEvents;
}



