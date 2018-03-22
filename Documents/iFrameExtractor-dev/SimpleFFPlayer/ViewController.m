//
//  ViewController.m
//  SimpleFFPlayer
//
//  Created by  jefby on 16/1/13.
//  Copyright © 2016年 jefby. All rights reserved.
//

#import "ViewController.h"
#import "FFDecoder.h"
#import "Utilities.h"
#import "SimpleFFPlayer-Swift.h"

@interface ViewController ()<VideoTransferDelegate>
@end

@implementation ViewController


- (id)init{
    self = [super init];
    //change orientation 
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    return self;
}
- (IBAction)showTime:(id)sender {
    NSLog(@"current time: %f s ",video.currentTime);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    video = [[FFDecoder alloc] initWithVideo:[Utilities bundlePath:@"Jellyfish-3-Mbps-1080p-hevc.mkv"]];
    //video = [[FFDecoder alloc] initWithVideo:@"http://techslides.com/demos/sample-videos/small.mp4"];
    // set output image size
    video.outputWidth = 640;
    video.outputHeight = 480;
    
    // print some info about the video
    NSLog(@"video duration: %f",video.duration);
    NSLog(@"video size: %d x %d", video.sourceWidth, video.sourceHeight);
    
    // video images are landscape, so rotate image view 90 degrees
    //[_imageView setTransform:CGAffineTransformMakeRotation(M_PI/2)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonAction:(id)sender {
    [[self playButton] setEnabled:NO];
    [video seekTime:0.0];
    double preferredFramesPerSecond = 30.0f;
    [NSTimer scheduledTimerWithTimeInterval:1.0/preferredFramesPerSecond
                                     target:self
                                   selector:@selector(displayNextFrame:)
                                   userInfo:nil
                                    repeats:YES];

}

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

-(void)displayNextFrame:(NSTimer *)timer {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    if (![video stepFrame]) {
        [timer invalidate];
        [_playButton setEnabled:YES];
        return;
    }
    _imageView.image = video.currentImage;
    
    float frameTime = 1.0/([NSDate timeIntervalSinceReferenceDate]-startTime);
    if (lastFrameTime<0) {
        lastFrameTime = frameTime;
    } else {
        lastFrameTime = LERP(frameTime, lastFrameTime, 0.8);
    }
    [_label setText:[NSString stringWithFormat:@"%.0f",lastFrameTime]];
}



#pragma mark - VideoTransferDelegate
- (BOOL)transferBufferWithData:(NSData * _Nonnull)data{
    
    return true;
}

@end
