//
//  TCPSocketVC.m
//  CloudStorage
//
//  Created by tranvanloc on 2/17/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

#import "TCPSocketVC.h"

@interface TCPSocketVC ()

@end

@implementation TCPSocketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _connectedLabel.text = @"Disconnected";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self loadDefaults];
}

- (IBAction) sendMessage {
    
    NSString *response  = [NSString stringWithFormat:@"msg:%@", _dataToSendText.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}

- (void) messageReceived:(NSString *)message {
    
    [messages addObject:message];
    
    _dataRecievedTextView.text = message;
    NSLog(@"%@", message);
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
            _connectedLabel.text = @"Connected";
            break;
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable])
                {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output)
                        {
                            NSLog(@"server said: %@", output);
                            
//                            [self sendMessage];
//                            [self messageReceived:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
//               [self sendMessage];
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"%@",[theStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            _connectedLabel.text = @"Disconnected";
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}

- (IBAction)connectToServer:(id)sender {
    
    NSLog(@"Setting up connection to %@ : %i", _ipAddressText.text, [_portText.text intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) _ipAddressText.text, [_portText.text intValue], &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    
    [self open];
}

- (IBAction)disconnect:(id)sender {
    
    [self close];
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
    
    _connectedLabel.text = @"Connected";
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
    
    _connectedLabel.text = @"Disconnected";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.ipAddressText.text forKey:@"ipAddressText"];
    [userDefaults setObject:self.portText.text forKey:@"portText"];
    [userDefaults synchronize];
}

-(void)loadDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *host = [userDefaults objectForKey:@"ipAddressText"];
    if(host){
        self.ipAddressText.text = host;
    }
    
    NSString *remotePort = [userDefaults objectForKey:@"portText"];
    if(remotePort){
        self.portText.text = remotePort;
    }
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    for (UIView *v in self.view.subviews) {
//        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
//            [v resignFirstResponder];
//           }
//    }
//    [super touchesEnded: touches withEvent: event];
//}

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

@end
