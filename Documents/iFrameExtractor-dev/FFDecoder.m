//
//  FFDecoder.m
//  SimpleFFPlayer
//
//  Created by  jefby on 16/1/13.
//  Copyright © 2016年 jefby. All rights reserved.
//

#import "FFDecoder.h"
@interface FFDecoder()
-(void)convertFrameToRGB;
-(UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height;
-(void)setupScaler;
@end

@implementation FFDecoder

@synthesize outputWidth, outputHeight;

-(void)setOutputWidth:(int)newWidth{
    if (outputWidth == newWidth)
        return;
    
    outputWidth = newWidth;
    [self setupScaler];
    
}
-(void)setOutputHeight:(int)newHeight{
    if (outputHeight == newHeight)
        return;
    outputHeight = newHeight;
    [self setupScaler];
}

-(UIImage *)currentImage{
    if (!pFrame->data[0]) {
        return nil;
    }
    [self convertFrameToRGB];
    return [self imageFromAVPicture:picture width:outputWidth height:outputHeight];
}

-(double)duration{
    return (double)pFormatCtx->duration / AV_TIME_BASE;
}

-(double)currentTime{
    AVRational timeBase = pFormatCtx->streams[videoStream]->time_base;
    return packet.pts * (double)timeBase.num / timeBase.den;
}

-(int)sourceHeight{
    return pCodecCtx->height;
}

-(int)sourceWidth  {
    return pCodecCtx->width;
}



-(void)setupScaler {
    
    // Release old picture and scaler
    avpicture_free(&picture);
    sws_freeContext(img_convert_ctx);
    
    // Allocate RGB picture
    avpicture_alloc(&picture, PIX_FMT_RGB24, outputWidth, outputHeight);
    
    // Setup scaler
    static int sws_flags =  SWS_FAST_BILINEAR;
    img_convert_ctx = sws_getContext(pCodecCtx->width,
                                     pCodecCtx->height,
                                     pCodecCtx->pix_fmt,
                                     outputWidth,
                                     outputHeight,
                                     PIX_FMT_RGB24,
                                     sws_flags, NULL, NULL, NULL);
    
}
+ (void)initialize
{
    avcodec_register_all();
    av_register_all();
    avformat_network_init();

}

-(id)initWithVideo:(NSString *)moviePath{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    pFormatCtx = avformat_alloc_context();
    AVCodec * pCodec = NULL;

    
    
    if(avformat_open_input(&pFormatCtx, [moviePath cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL) != 0){
        av_log(NULL, AV_LOG_ERROR, "Couldn't open file\n");
        goto initError;
    }
    
    if (avformat_find_stream_info(pFormatCtx, NULL) < 0) {
        avformat_close_input(&pFormatCtx);
        av_log(NULL, AV_LOG_ERROR, "Couldn't find stream information\n");
        goto  initError;
    }
    av_dump_format(pFormatCtx, 0, [moviePath.lastPathComponent cStringUsingEncoding:NSUTF8StringEncoding], false);
    
    videoStream = -1;

    for (int i = 0 ; i < pFormatCtx->nb_streams; ++i ) {
        if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO && videoStream < 0) {
            videoStream = i;
        }
    }
    if (videoStream == -1) {
        av_log(NULL, AV_LOG_ERROR, "Didn't find a video stream");
        goto initError;
    }
    pCodecCtx = pFormatCtx->streams[videoStream]->codec;
    pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
    if (!pCodec) {
        av_log(NULL, AV_LOG_ERROR, "unsupported codec\n");
        goto initError;
    }
    
    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0) {
        av_log(NULL, AV_LOG_ERROR, "Can't open video decoder\n");
        goto initError;
    }
    
    pFrame = av_frame_alloc();
    outputWidth = pCodecCtx->width;
    outputHeight = pCodecCtx->height;
    return self;
    
initError:
    return nil;
}
- (void)seekTime:(double)seconds {
    AVRational timeBase = pFormatCtx->streams[videoStream]->time_base;
    int64_t targetFrame = (int64_t)((double)timeBase.den / timeBase.num * seconds);
    avformat_seek_file(pFormatCtx, videoStream, targetFrame, targetFrame, targetFrame, AVSEEK_FLAG_FRAME);
    avcodec_flush_buffers(pCodecCtx);
}

- (BOOL)stepFrame
{
    int frameFinished = 0;
    while (!frameFinished && av_read_frame(pFormatCtx, &packet) >= 0) {
        if (packet.stream_index == videoStream) {
            //decode video frame
            avcodec_decode_video2(pCodecCtx, pFrame, &frameFinished, &packet);
        }
    }
    return frameFinished != 0;
}

- (void)convertFrameToRGB
{
    sws_scale(img_convert_ctx, pFrame->data, pFrame->linesize, 0, pCodecCtx->height, picture.data, picture.linesize);
}

-(UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height {
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       pict.linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);
    
    return image;
}


@end
