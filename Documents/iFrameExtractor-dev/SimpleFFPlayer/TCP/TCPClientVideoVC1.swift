//
//  TCPClientVC.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/26/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

import UIKit

class TCPClientVideoVC1: ViewControllerTextView,StreamDelegate,VideoReceiverDelegate {
    var video:FFDecoder!
    var lastFrameTime:Double!
    
    var readStream:CFReadStream!
    var writeStream:CFWriteStream!
    var inputStream:InputStream!
    var outputStream:OutputStream!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func start()
    {
//        NSLog(@"Setting up connection to %@ : %i", _hostTextField.text, [_remotePortTextField.text intValue]);
//        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) _hostTextField.text, [_remotePortTextField.text intValue], &readStream, &writeStream);
//        [self open];
        
      CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,"192.168.43.65" as CFString, 8088, UnsafeMutablePointer<Unmanaged<CFReadStream>>(readStream), UnsafeMutablePointer<Unmanaged<CFWriteStream>>(writeStream));
    }
    
    func receiverBuffer(data:Data) -> Bool{
    return true
    }
    
    
    func open() {
   print("Opening streams.")
    outputStream = writeStream;
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

}
