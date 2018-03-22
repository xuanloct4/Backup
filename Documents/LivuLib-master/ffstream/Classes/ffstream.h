/*
 *  ffstream.h
 *
 *  Product: libffstream
 *
 *  Created by Steve on 12/14/10.
 *  Copyright 2010 Steve McFarlin. All rights reserved.
 *
 *  See the bottom of this file for licensing information. 
 *
 *  Note:   I was indecisive about Obj-C or Pure C, and ended up with a mix. It should not be terribly
 *          hard to remove the Obj-C code.
 */


#define MSG_ERROR_STREAM_TIMEOUT    1
#define MSG_ERROR_STREAM_SIGPIPE    1 << 1
#define MSG_ERROR_STREAM_HEADER     1 << 2
#define MSG_ERROR_INPUT_DECODE      1 << 3
#define MSG_ERROR_INPUT_BUFFER      1 << 4
#define MSG_ERROR_MALLOC            1 << 5
#define MSG_ERROR_CONFIG            1 << 6
#define MSG_ERROR_INIT              1 << 7
#define MSG_ERROR_START             1 << 8
#define MSG_ERROR_RTMP              1 << 9
#define MSG_ERROR_TERMINATED        1 << 10
#define MSG_ERROR_STREAM_CONNECT    1 << 11

#define MSG_INFO_RTMP               1       //RTMP message
#define MSG_INFO_INITIALIZED        1 << 2  
#define MSG_INFO_STARTED            1 << 3  
#define MSG_INFO_STOPPED            1 << 4    
#define MSG_INFO_NO_AUDIO           1 << 5
#define MSG_INFO_RTMP_SOCK_FULL     1 << 6
#define MSG_INFO_CONNECTING         1 << 7

/*!
 @abstract Structure to hold information about a buffer
 @discusson
     This holds information about bufferes passed to FFstream. FFstream takes ownership of each buffer
     passed to it. It will release the object and any variables within it. Make sure you do not place
     autoreleased objects, or any objects that you retain ownership over in this interface.
 */
@interface FFstreamBuffer : NSObject {
@public
    NSString *bufferLink;
    int number;
    BOOL last_buffer;
}
@end


/*!
 @protocol FFstreamMessageHandler
 @abstract Delegate message handler
 @discussion
    libffstream will post message to the following handlers. The one message that you can always
    count on is MSG_INFO_STOPPED. It is up to the handler to keep track of errors. So for instance
    if an error occurs handleError will be called 1 or more times. The last message will be 
    MSG_INFO_STOPPED. Do note that this message will only be called if start() has been involked.
*/
@protocol FFstreamMessageHandler

- (void) handleError:(NSString*)message withType:(int) type;
- (void) handleInfo:(NSString*)message withType:(int) type;
/*!
 @abstract Buffer processed notification
 @discusson 
    This will be called once FFstream has completed the buffer. Do not hold onto this object. It will
    be released right after this call. The bps calculation is a simple accumulator of time and bytes.
    
    
 @param buffer The buffer that has been processed (streamed)
 @param bps The very general bits per second.
 */
- (void) processedBuffer:(FFstreamBuffer*) buffer withBitRate:(double_t) bps;
//- (void) currentBitrate:(double_t) bps;
@end


@class FFstreamMessageHandler;

/*!
 @abstract
    Set the message handler
    
 @param handler The FFStreamMessageHandler
*/
void ffstream_set_message_handler(FFstreamMessageHandler *handler);


/*!
 @abstract 
    Set the link to the next buffer
 @discussion
    Append a buffer to be streamed. 
    
    After the library is done with a buffer it posts a MSG_INFO_BUFF_NEXT message to indicate it is processing the next 
    buffer. It will clean up the old buffer. However, if a library error occurs
    
 @param buffer A FFstreamBuffer

*/
//void ffstream_append_buffer(NSString *buff_link, bool last_buffer);

void ffstream_append_buffer(FFstreamBuffer *buffer);

/*!
 @abstract 
    This method initializes the FFmpeg libraries. 
 @discussion 
    Should only be called once per app execution. This library has not been tested with iOS multitasking. To be honest
    multitasking does not make a lot of sense for live broadcast software. Ohh let me take this call... brb.
*/
void ffstream_init_lib();

/*! 
 @abstract 
    Start the stream.

 @discussion
    This method blocks untill buffer_threashold buffers becomes available. 
    
 
 @param q_min number of queued buffers before streaming starts
 
*/
void ffstream_start(int q_min);

/*!
 @abstract initialize Ffstream.
 @discussion
    This method opens up the output stream. It will block untill a connection is successful or fails.
    
 @param url 
 @result 0 for fail, 1 for success. The callback will also be notified.
 */
int ffstream_init(const char* url);

/*!
 @abstract
    Stop the stream
    
 @discussion
    This method instructs libffstream to stop. This takes effect immediatly.
*/
void ffstream_stop();

/*!
    @abstract Force shutdown FFstream - before streaming has started.
 */
void ffstream_kill() ;

void sigpipe_handler(int sig);

/*
 The MIT License
 
 Copyright (c) 2010 Steve McFarlin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */