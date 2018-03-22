//
//  ViewController.h
//  SimpleFFPlayer
//
//  Created by  jefby on 16/1/13.
//  Copyright © 2016年 jefby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFDecoder;

@interface ViewController : UIViewController{
    FFDecoder *video;
    double lastFrameTime;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *time;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)playButtonAction:(id)sender;
- (IBAction)showTime:(id)sender;

@end

