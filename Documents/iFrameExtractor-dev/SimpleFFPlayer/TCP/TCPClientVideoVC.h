//
//  TCPClientVideoVC.h
//  CloudStorage
//
//  Created by tranvanloc on 4/3/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ViewControllerTextView.h"
#import "FFDecoder.h"
#import "Utilities.h"

#include "libavformat/avformat.h"
#include "libswscale/swscale.h"

@interface TCPClientVideoVC : ViewControllerTextView<NSStreamDelegate>{
    FFDecoder *video;
    double lastFrameTime;
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
}
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *remotePortTextField;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *time;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end


