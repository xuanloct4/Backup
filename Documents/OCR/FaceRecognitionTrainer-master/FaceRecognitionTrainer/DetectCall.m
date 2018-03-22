//
//  DetectCall.m
//  FaceRecognitionTrainer
//
//  Created by Frederik Jacques on 29/01/12.
//  Copyright (c) 2012 dev-dev. All rights reserved.
//

#import "DetectCall.h"

@implementation DetectCall

@synthesize imageData;
@synthesize faceDetectVO;

- (id)initWithImageData:(NSData *)theImageData {
    self = [super initWithTheUrl:[NSURL URLWithString:FACE_DETECT_URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeOut:180.0];
    
    if( self != nil ){
        NSLog(@"[DetectCall] Init");
        self.imageData = theImageData;
        [self setHTTPBody:[self createHTTPBody]];
    }
    
    return self;
}

- (NSData *)createHTTPBody {
    NSLog(@"[DetectCall] Create HTTPBody");
    NSMutableData *theData = [NSMutableData data];
    NSString *beginLine = [NSString stringWithFormat:@"--%@\r\n", self.boundary];
    NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", self.boundary];
    
    [self utfAppendBody:theData data:beginLine];
    [self utfAppendBody:theData
                   data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_key\"\r\n\r\n"]];
    [self utfAppendBody:theData data:FACE_API_KEY];
    [self utfAppendBody:theData data:endLine];
    
    [self utfAppendBody:theData
                   data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_secret\"\r\n\r\n"]];
    [self utfAppendBody:theData data:FACE_API_SECRET];
    [self utfAppendBody:theData data:endLine];
    
    [self utfAppendBody:theData
                   data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"urls\"\r\n\r\n"]];
    [self utfAppendBody:theData data:@""];
    [self utfAppendBody:theData data:endLine];
    
    [self utfAppendBody:theData
                   data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"format\"\r\n\r\n"]];
    [self utfAppendBody:theData data:@"json"];
    [self utfAppendBody:theData data:endLine];
    
    [self utfAppendBody:theData
                   data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"attributes\"\r\n\r\n"]];
    [self utfAppendBody:theData data:@"all"];
    [self utfAppendBody:theData data:endLine];
    
    [self utfAppendBody:theData
                   data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"thePicture\"; filename=\"i_look_good.jpg\"\r\n"]];
    [self utfAppendBody:theData
                   data:[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"]];
    
    [theData appendData:UIImageJPEGRepresentation([UIImage imageWithData:imageData], 1.0)];
    [self utfAppendBody:theData data:endLine];
        
    return theData;
    
}

- (void)execute {
    NSLog(@"[DetectCall] Execute");
    
    [NSURLConnection sendAsynchronousRequest:self queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *theResponse, NSData *theData, NSError *theError) {
        
        if( theData != nil ){
            NSLog(@"[DetectCall] Got JSON data from server");
            
            NSLog(@"[DetectCall] Parsing JSON");
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:theData
                                  options:kNilOptions error:&theError];
            
            NSLog(@"[DetectCall] %@", json);
            
            NSArray *photoData = [json objectForKey:@"photos"];
            NSLog(@"[DetectCall] Converted json to array");
            NSDictionary *photoDict = [photoData objectAtIndex:0];
            NSLog(@"[DetectCall] Converted array to dict");
            self.faceDetectVO = [[[FaceDetectVO alloc] initWithDictionary:photoDict] autorelease];
            NSLog(@"[DetectCall] Parsed");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DETECTING_COMPLETE" object:self];
        }
        
    }];
}

- (void)dealloc {
    NSLog(@"[DetectCall] Dealloc");
    [imageData release];
    imageData = nil;
    
    [faceDetectVO release];
    faceDetectVO = nil;
    
    [super dealloc];
}

@end
