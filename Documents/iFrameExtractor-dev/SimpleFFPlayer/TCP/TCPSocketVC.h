//
//  TCPSocketVC.h
//  CloudStorage
//
//  Created by tranvanloc on 2/17/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerTextView.h"
@interface TCPSocketVC : ViewControllerTextView<NSStreamDelegate>
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
    
    NSMutableArray  *messages;
}

@property (weak, nonatomic) IBOutlet UITextField *ipAddressText;
@property (weak, nonatomic) IBOutlet UITextField *portText;
@property (weak, nonatomic) IBOutlet UITextField *dataToSendText;
@property (weak, nonatomic) IBOutlet UITextView *dataRecievedTextView;
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;



@end
