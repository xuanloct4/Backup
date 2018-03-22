//
//  TCPClientVideoVC.m
//  CloudStorage
//
//  Created by tranvanloc on 4/3/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

#import "TCPClientVideoVC.h"
#import "SimpleFFPlayer-Swift.h"

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)


//@class TCPClientOBJ;
//@class VideoFrameReceiver;
//@class VideoFrameTransfer;
//@protocol VideoReceiverDelegate;
//@protocol VideoTransferDelegate;

@interface TCPClientVideoVC ()<VideoReceiverDelegate>
@property TCPClientOBJ *client;
//@property VideoTransfer * transer;

@property NSMutableData *recData;

@property VideoFrameReceiver *receiver;
@end

@implementation TCPClientVideoVC

- (id)init{
    self = [super init];
    //change orientation
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    return self;
}

- (IBAction)stop:(id)sender {
    [self close];
}

- (IBAction)start:(id)sender {
    //    self.client = [[TCPClientOBJ alloc] initWithAddress:_hostTextField.text port:[_remotePortTextField.text intValue]];
    //   int32_t status = [_client connectWithTimeout:10];
    //    if (status >= 0){
    //    while (true) {
    //     NSArray<NSNumber *> * dat = [_client read:12288 timeout:10];
    //        NSLog(@"Data size = %ld", dat.count);
    //    }
    //    }
    
    
    NSLog(@"Setting up connection to %@ : %i", _hostTextField.text, [_remotePortTextField.text intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) _hostTextField.text, [_remotePortTextField.text intValue], &readStream, &writeStream);
    [self open];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    video = [[FFDecoder alloc] initWithVideo:[Utilities bundlePath:@"Jellyfish-3-Mbps-1080p-hevc.mkv"]];
    //video = [[FFDecoder alloc] initWithVideo:@"http://techslides.com/demos/sample-videos/small.mp4"];
    // set output image size
    //    video.outputWidth = 640;
    //    video.outputHeight = 480;
    
    video.outputWidth = 1920;
    video.outputHeight = 1080;
    
    
    // print some info about the video
    NSLog(@"video duration: %f",video.duration);
    NSLog(@"video size: %d x %d", video.sourceWidth, video.sourceHeight);
    
    // video images are landscape, so rotate image view 90 degrees
    //[_imageView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    [self loadDefaults];
    
    
    self.recData = [[NSMutableData alloc] init];
    
    
    self.receiver = [[VideoFrameReceiver alloc] initWithReceiverDelegate:self];
    
    //    NSArray *allBundles = [NSBundle allBundles];
    //     NSArray *allFrameworks = [NSBundle allFrameworks];
    //    NSBundle *bundle = [NSBundle mainBundle];
    //    NSString *localizeString = NSLocalizedString(@"War", nil);
    //    localizeString = NSLocalizedStringFromTable(@"Myster", @"Localizable2", nil);
    //    localizeString = NSLocalizedStringFromTableInBundle(@"Myster", @"Localizable2", bundle, nil);
    //    [self.playButton setTitle:localizeString forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self.transer loadVideoFromTime:0];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self saveDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonAction:(id)sender {
    
}

-(void)displayNextFrame:(NSTimer *)timer {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    if (![video stepFrame]) {
        [timer invalidate];
        [_playButton setEnabled:YES];
        return;
    }
    
    UIImage *currentImage = video.currentImage;
    double currentTime = video.currentTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = currentImage;
    });
    
    //    NSData *imgData = UIImagePNGRepresentation(video.currentImage);
    //    VideoFrameTransfer *transer = [[VideoFrameTransfer alloc] initWithData:imgData sendTime:[NSDate date] seekTime:video.currentTime fps:30 transferDelegate:self];
    
    dispatch_queue_t trans_queue = dispatch_queue_create("TransferQueue", 0);
    
    dispatch_async(trans_queue, ^{
        
        VideoFrameTransfer *transer = [[VideoFrameTransfer alloc] initWithImage:currentImage sendTime:[NSDate date] seekTime:currentTime fps:30 transferDelegate:self];
        [transer processFrameData];
        
        //    dispatch_queue_t q = dispatch_queue_create("abc", 0);
        //    dispatch_async(q, ^{
        //     [self sendData:UIImagePNGRepresentation(video.currentImage) :self.client];
        //    });
        
    });
    
    float frameTime = 1.0/([NSDate timeIntervalSinceReferenceDate]-startTime);
    if (lastFrameTime<0) {
        lastFrameTime = frameTime;
    } else {
        lastFrameTime = LERP(frameTime, lastFrameTime, 0.8);
    }
    [_label setText:[NSString stringWithFormat:@"%.0f",lastFrameTime]];
}


-(void)saveDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.hostTextField.text forKey:@"remoteHost"];
    [userDefaults setObject:self.remotePortTextField.text forKey:@"remotePort"];
    [userDefaults synchronize];
}

-(void)loadDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *host = [userDefaults objectForKey:@"remoteHost"];
    if(host){
        self.hostTextField.text = host;
    }
    
    NSString *remotePort = [userDefaults objectForKey:@"remotePort"];
    if(remotePort){
        self.remotePortTextField.text = remotePort;
    }
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    if (theStream == inputStream) {
        NSLog(@"Input Stream");
    }else{
        NSLog(@"Output Stream");
    }
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                NSInteger len;
                
                while ([inputStream hasBytesAvailable])
                {
                    uint8_t buffer[1024*12];
                    
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSLog(@"server return data length: %ld", (long)len);
                        NSMutableArray * bytes = [[NSMutableArray alloc] init];
                        for(int i = 0; i < len; i++)
                        {
                            [bytes addObject:[NSNumber numberWithUnsignedChar:buffer[i]]];
                        }
                        
                        //                        [self.receiver dataHandleWithBytes:bytes];
                        
                        //                        // Copy the bytes from our file input stream buffer
                        //                        void *base64buffer = malloc(buffer[len]);
                        //                        // Convert the bytes to NSData for the base64 encode
                        //                        NSData *dataToEncode = [NSData dataWithBytesNoCopy:base64buffer length:len freeWhenDone:YES];
                        //
                        //                        //                        NSMutableData *dataToEncode = [[NSMutableData alloc] init];
                        //                        //                        [dataToEncode appendBytes:(const void *)buffer length:len];
                        //                      double seekTime =  [VideoTransUtils findSeekTimeInfoWithData:bytes];
                        //                        double fps = [VideoTransUtils findSendTimeInfoWithData:bytes];
                        //                        double order = [VideoTransUtils findOrderInfoWithData:bytes];
                        //
                        //                        NSLog(@"SeekTime: %f, fps: %f, order: %f", seekTime, fps, order);
                        ////                        [self.receiver dataHandleWithData:dataToEncode];
                        
                        uint8_t buff[len];
                        memcpy(buff, buffer, len);
                        
                        NSMutableData *data = [[NSMutableData alloc]  initWithBytes:buff length:len];
                        [self.recData appendData:data];
                        
                        
//                        [self.receiver dataHandleWithData:data];
                        
                        
                    }
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"%@",[theStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}


- (void)open {
    NSLog(@"Opening streams.");
    outputStream = (__bridge NSOutputStream *)writeStream;
    inputStream = (__bridge NSInputStream *)readStream;
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream open];
    [inputStream open];
}

- (void)close {
    NSLog(@"Closing streams.");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    inputStream = nil;
    outputStream = nil;
}



// MARK: - TextViewDelegate, TextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self saveDefaults];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self saveDefaults];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self saveDefaults];
    return YES;
}

#pragma mark - VideoReceiverDelegate
- (BOOL)receiverBufferWithData:(NSData * _Nonnull)data{
    UIImage *img = [[UIImage alloc] initWithData:data];
    if(img){
        _imageView.image = img;
    }
    return true;
}


@end
