//
//  FFDecoder.h
//  SimpleFFPlayer
//
//  Created by  jefby on 16/1/13.
//  Copyright © 2016年 jefby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "SimpleFFPlayer-Swift.h"

#include "libavformat/avformat.h"
#include "libswscale/swscale.h"

@interface FFDecoder : NSObject{
    AVFormatContext *pFormatCtx;
    AVCodecContext *pCodecCtx;
    AVFrame *pFrame;
    AVPacket packet;
    AVPicture picture;
    int videoStream;
    struct SwsContext *img_convert_ctx;
    int sourceWidth, sourceHeight;
    int outputWidth, outputHeight;
    UIImage *currentImage;
    double duration;
    double currentTime;
}

@property (nonatomic, readonly) UIImage *currentImage;
@property (nonatomic, readonly) int sourceWidth, sourceHeight;
@property (nonatomic) int outputWidth, outputHeight;
@property (nonatomic, readonly) double duration;
@property (nonatomic, readonly) double currentTime;

//Initialize with movie at moviePath. Output dimensions are set to source dimensions
-(id)initWithVideo:(NSString *)moviePath;
//Read the next frame from the video stream. Returns false if no frame read(video end)
-(BOOL)stepFrame;
//Seek to closet keyframe near specified time
-(void)seekTime:(double)seconds;


@end
