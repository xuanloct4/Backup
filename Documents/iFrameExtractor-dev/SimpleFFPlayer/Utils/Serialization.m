//
//  Serialization.m
//  BUILDAC
//
//  Created by tiennv on 1/23/14.
//  Modified by LocTV on 7/27/16 v1.01
//  Copyright (c) 2014 TSDV. All rights reserved.
//

#import "Serialization.h"
#import <zlib.h>

#define TC_STRING           0x74
#define TC_NULL             0x70
#define TC_ENDBLOCKDATA     0x78
#define TC_OBJECT           0x73
#define TC_Q     0x71

static const NSUInteger ChunkSize = 16384;


@implementation Serialization

// Compress data with GZIP
+ (NSData *)gzippedDataWithCompressionLevel:(float)level data:(NSData *)data
{
    if ((data != nil) && [data length]) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[data length];
        stream.next_in = (Bytef *)[data bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)(roundf(level*9));
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
            NSMutableData *retData = [NSMutableData dataWithLength:ChunkSize];
            while (stream.avail_out == 0) {
                if (stream.total_out >= [retData length]) {
                    retData.length += ChunkSize;
                }
                stream.next_out = (uint8_t *)[retData mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([retData length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            retData.length = stream.total_out;
            return retData;
        }
    }
    return nil;
}

// Compress data with GZIP
+ (NSData *)gzippedData:(NSData *)data
{
    return [self gzippedDataWithCompressionLevel:-1.0f data:data];
}

// Decompress data with GZIP
+ (NSData *)gunzippedData:(NSData *)data
{
    if ((data != nil) && [data length]) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[data length];
        stream.next_in = (Bytef *)[data bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *retData = [NSMutableData dataWithLength:(NSUInteger)([data length]*1.5)];
        if (inflateInit2(&stream, 47) == Z_OK) {
            int status = Z_OK;
            while (status == Z_OK) {
                if (stream.total_out >= [retData length]) {
                    retData.length += [data length]*0.5;
                }
                stream.next_out = (uint8_t *)[retData mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([retData length] - stream.total_out);
                status = inflate(&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK) {
                if (status == Z_STREAM_END) {
                    retData.length = stream.total_out;
                    return retData;
                }
            }
        }
    }
    return nil;
}

// Decompress data with ZIP
+ (NSData *)zunzippedData:(NSData *)data
{
    if ((data != nil) && [data length]) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[data length];
        stream.next_in = (Bytef *)[data bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *retData = [NSMutableData dataWithLength:(NSUInteger)([data length]*1.5)];
        if (inflateInit(&stream) == Z_OK) {
            int status = Z_OK;
            while (status == Z_OK){
                if (stream.total_out >= [retData length]) {
                    retData.length += [data length]*0.5;
                }
                stream.next_out = (uint8_t *)[retData mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([retData length] - stream.total_out);
                status = inflate(&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK) {
                if (status == Z_STREAM_END){
                    retData.length = stream.total_out;
                    return retData;
                }
            }
        }
    }
    return nil;
}


/*+ (BOOL)readBooleanObject:(NSMutableData *)data
 {
 if ((data != nil) && [data length]){
 if ([data length] < 47){
 return NO;
 }
 // Remove 46 bytes from front
 [data replaceBytesInRange:NSMakeRange(0, 46) withBytes:NULL length:0];
 // Get the 47th byte
 BOOL byteArray[1];
 [data getBytes:&byteArray length:1];
 // Remove the 47th byte
 [data replaceBytesInRange:NSMakeRange(0, 1) withBytes:NULL length:0];
 // return result
 return (BOOL)byteArray[0];
 }
 
 return NO;
 }
 
 
 + (void)writeBooleanObject:(NSMutableData *)data object:(BOOL)object
 {
 // 2 bytes for STREAM_MAGIC
 [data appendBytes:(char[]){0xac, 0xed} length:2];
 // 2 bytes for STREAM_VERSION
 [data appendBytes:(char[]){0x00, 0x05} length:2];
 // 1 byte for TC_OBJECT
 [data appendBytes:(char[]){0x73} length:1];
 // 1 byte for TC_CLASSDESC
 [data appendBytes:(char[]){0x72} length:1];
 // 2 bytes for lenght of class name
 [data appendBytes:(char[]){0x00, 0x11} length:2];
 // 17 bytes for class name
 [data appendBytes:(char[]){0x6a, 0x61, 0x76, 0x61, 0x2e, 0x6c, 0x61, 0x6e, 0x67, 0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x65, 0x61, 0x6e} length:17];
 // 8 bytes for SerialVersionID
 [data appendBytes:(char[]){0xcd, 0x20, 0x72, 0x80, 0xd5, 0x9c, 0xfa, 0xee} length:8];
 // 1 bytes for SC_SERIALIZABLE
 [data appendBytes:(char[]){0x02} length:1];
 // 2 bytes for number of fields
 [data appendBytes:(char[]){0x00, 0x01} length:2];
 // 1 bytes for type of field 1
 [data appendBytes:(char[]){0x5a} length:1];
 // 2 bytes for length of field 1 name
 [data appendBytes:(char[]){0x00, 0x05} length:2];
 // 5 bytes for name of field 1
 [data appendBytes:(char[]){0x76, 0x61, 0x6c, 0x75, 0x65} length:5];
 // 1 byte for TC_ENDBLOCKDATA
 [data appendBytes:(char[]){0x78} length:1];
 // 1 byte for TC_NULL
 [data appendBytes:(char[]){0x70} length:1];
 // 1 byte for Boolean value
 char value = object ? 0x01 : 0x00;
 [data appendBytes:(char[]){value} length:1];
 }*/

// Get boolean value from a byte stream
+ (BOOL)getBoolValue:(NSMutableData *)data
{
    // Get first byte from front
    Byte boolValue[1];
    [data getBytes:&boolValue length:1];
    // Remove 1 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 1) withBytes:NULL length:0];
    return (boolValue[0] != 0);
}

// Get integer value from a byte stream
+ (int)getIntValue:(NSMutableData *)data
{
    Byte byteArray[4];
    [data getBytes:&byteArray length:4];
    // Remove 4 bytes from front
    
    // Modify by LocTV v1.02
    if (data.length >= 4) {
        
        [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:NULL length:0];
        
    }else{
        [data replaceBytesInRange:NSMakeRange(0, data.length) withBytes:NULL length:0];
    }
    // End modify
    
    // Return value
    return ((byteArray[0] << 24)
            + (byteArray[1] << 16)
            + (byteArray[2] << 8)
            + byteArray[3]);
}

// Get short value from a byte stream
+ (int)getInt16Value:(NSMutableData *)data
{
    Byte byteArray[2];
    [data getBytes:&byteArray length:2];
    // Remove 2 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 2) withBytes:NULL length:0];
    // Return value
    return ((byteArray[0] << 8) + byteArray[1]);
}

// Get double value from a byte stream
+ (double)getDoubleValue:(NSMutableData *)data
{
    // Get 8 first bytes
    Byte byteArray[8];
    [data getBytes:&byteArray length:8];
    // Remove 8 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 8) withBytes:NULL length:0];
    // Swap order
    Byte doubleBytes[8];
    for (int idx = 0; idx < 8; idx ++) {
        doubleBytes[idx] = byteArray[7 - idx];
    }
    // Return value
    double val;
    memcpy(&val, doubleBytes, sizeof(val));
    return val;
}

// Get long value from a byte stream
+ (long long)getLongValue:(NSMutableData *)data
{
    // Get 8 first bytes
    Byte byteArray[8];
    [data getBytes:&byteArray length:8];
    // Remove 8 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 8) withBytes:NULL length:0];
    // Swap order
    Byte longBytes[8];
    for (int idx = 0; idx < 8; idx ++) {
        longBytes[idx] = byteArray[7 - idx];
    }
    // Return value
    long long val;
    memcpy(&val, longBytes, sizeof(val));
    return val;
}

// Get float value from a byte stream
+ (float)getFloatValue:(NSMutableData *)data
{
    // Get 8 first bytes
    Byte byteArray[4];
    [data getBytes:&byteArray length:4];
    // Remove 8 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:NULL length:0];
    // Swap order
    Byte floatBytes[4];
    for (int idx = 0; idx < 4; idx ++) {
        floatBytes[idx] = byteArray[3 - idx];
    }
    // Return value
    float val;
    memcpy(&val, floatBytes, sizeof(val));
    return val;
}

// Get string value from a byte stream
+ (NSString *)getStringValue:(NSMutableData *)data
{
    // Get the first byte
    Byte type[2];
    [data getBytes:&type length:2];
    // Remove 1 bytes from front
    
    // Modify by LocTV v1.02
    if (data.length >= 1) {
        [data replaceBytesInRange:NSMakeRange(0, 1) withBytes:NULL length:0];
    }else{
        [data replaceBytesInRange:NSMakeRange(0, data.length) withBytes:NULL length:0];
    }
    if (type[0] == TC_STRING) {
        // Get length of string
        int length = [Serialization getInt16Value:data];
        if (length == 0) {
            return @"";
        }
        // Get string
        Byte stringByte[length];
        [data getBytes:&stringByte length:length];
        NSMutableData *stringData = [[NSMutableData alloc] initWithBytes:stringByte length:length];
        // Remove lenght bytes from front
        [data replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
        // Return result
        @try {
            [Serialization validateStringData:stringData];
            NSString *string =
            [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
            return string;
        }
        @catch (NSException *exception) {
            return @"";
        }
    }else if (type[0] == 0x71){
        [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:NULL length:0];
    }else if ((type[0] == 0x73) && (type[1] == 0x71)){
        [data replaceBytesInRange:NSMakeRange(0, 5) withBytes:NULL length:0];
    }
    return @"";
}

+(void)validateStringData:(NSMutableData *)data
{
    @try {
        //        NSMutableData *tempData = [[NSMutableData alloc] initWithData:[data copy]];
        //                                   Data:data];
        
        int len = (int)data.length;
        for (int idx = 0; idx < (len - 1); idx ++) {
            // Check 2 first bytes
            Byte bytes[2];
            //            [tempData getBytes:&bytes length:2];
            
            [data getBytes:&bytes range:NSMakeRange(idx, 2)];
            
            if ((bytes[0] == 0xc0) && (bytes[1] == 0x80)) {
                [data replaceBytesInRange:NSMakeRange(idx, 2) withBytes:NULL length:0];
                //Start modified by LocTV v1.01
                //           return;      //deleted by LocTV
                if (idx >=1) {
                    idx -= 2;
                } else {
                    idx = -1;
                }
                //End LocTV
            }
            
            // Remove first byte from front
            //            [tempData replaceBytesInRange:NSMakeRange(0, 1) withBytes:NULL length:0];
        }
        //        if (tempData.length != 0) {
        //         [tempData replaceBytesInRange:NSMakeRange(0, tempData.length) withBytes:NULL length:0];
        //        }
        //        tempData = nil;
    }
    @catch (NSException *exception) {
        
    }
}

// Write a string object to a byte stream
+ (void)writeStringValue:(NSString *)string
                    data:(NSMutableData *)data
{
    if (string == nil) {
        [data appendBytes:(char[]){TC_NULL} length:1];
    } else if ([string isEqualToString:@""]) {
        [data appendBytes:(char[]){TC_STRING, 0x00, 0x00} length:3];
    } else {
        // Write string data
        NSData* stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
        // 1 byte for TC_STRING
        [data appendBytes:(char[]){TC_STRING} length:1];
        // 2 bytes for string length
        [Serialization writeInt16Value:(int)[stringData length] data:data];
        [data appendData:stringData];
    }
}

// Write an integer to a byte stream
+ (void)writeIntValue:(int)value
                 data:(NSMutableData *)data
{
    uint32_t writeValue = htonl((uint32_t)value);
    [data appendBytes:&writeValue length:4];
}

// Write an short value to a byte stream
+ (void)writeInt16Value:(int)value
                   data:(NSMutableData *)data
{
    uint16_t writeValue = htons((uint16_t)value);
    [data appendBytes:&writeValue length:2];
}

// Write an integer to a byte stream
+ (void)writeLongValue:(long long)value
                  data:(NSMutableData *)data
{
    NSMutableData *longData = [NSMutableData dataWithBytes:&value
                                                    length:sizeof(value)];
    // Append with reverse order
    for (int idx = 0; idx < 8; idx ++) {
        [data appendBytes:&longData.bytes[7 - idx]
                   length:1];
    }
}

// Write Graphic menu request object to a byte stream
+ (void)writeGraphicRequestPageInfoObject:(NSMutableData *)data
                              offsetIndex:(int)offset
                              requestSize:(int)size
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 1 byte for TC_OBJECT
    [data appendBytes:(char[]){0x73} length:1];
    // 1 byte for TC_CLASSDESC
    [data appendBytes:(char[]){0x72} length:1];
    // 2 bytes for lenght of class name
    [data appendBytes:(char[]){0x00, 0x31} length:2];
    // 49 bytes for class name
    [data appendBytes:(char[]){
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x67, 0x72, 0x61, 0x70, 0x68, 0x69,
        0x63, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x47, 0x72, 0x61,
        0x70, 0x68, 0x69, 0x63, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73,
        0x74, 0x50, 0x61, 0x67, 0x65, 0x49, 0x6e, 0x66, 0x6f
    } length:49];
    // 8 bytes for SerialVersionID
    [data appendBytes:(char[]){
        0xde, 0xcd, 0x89, 0x65, 0x98, 0x54, 0xce, 0x64
    } length:8];
    // 1 bytes for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    // 2 bytes for number of fields
    [data appendBytes:(char[]){0x00, 0x02} length:2];
    // 1 byte for type of field 1
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for lenght of field 1 name
    [data appendBytes:(char[]){0x00, 0x0c} length:2];
    // 12 bytes for field 1 name
    [data appendBytes:(char[]){
        0x6f, 0x66, 0x66, 0x73, 0x65, 0x74, 0x49, 0x6e, 0x64, 0x65,
        0x78, 0x5f
    } length:12];
    // 1 byte for type of field 2
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for lenght of field 2 name
    [data appendBytes:(char[]){0x00, 0x0c} length:2];
    // 12 bytes for field 2 name
    [data appendBytes:(char[]){
        0x72, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x53, 0x69, 0x7a,
        0x65, 0x5f
    } length:12];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    // 4 byte for offsetIndex value
    [Serialization writeIntValue:offset data:data];
    // 4 byte for requestSize value
    [Serialization writeIntValue:size data:data];
}

// Write graphic image request object to a byte stream
+ (void)writeGraphicRequestImageObject:(NSMutableData *)data
                           requestType:(int)type
                              screenID:(int)ID
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 1 byte for TC_OBJECT
    [data appendBytes:(char[]){0x73} length:1];
    // 1 byte for TC_CLASSDESC
    [data appendBytes:(char[]){0x72} length:1];
    // 2 bytes for lenght of class name
    [data appendBytes:(char[]){0x00, 0x2e} length:2];
    // 46 bytes for class name
    [data appendBytes:(char[]){
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x67, 0x72, 0x61, 0x70, 0x68, 0x69,
        0x63, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x47, 0x72, 0x61,
        0x70, 0x68, 0x69, 0x63, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73,
        0x74, 0x49, 0x6d, 0x61, 0x67, 0x65
    } length:46];
    // 8 bytes for SerialVersionID
    [data appendBytes:(char[]){
        0xb4, 0xff, 0x44, 0xb0, 0x5b, 0x73, 0x46, 0x6b
    } length:8];
    // 1 bytes for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    // 2 bytes for number of fields
    [data appendBytes:(char[]){0x00, 0x02} length:2];
    // 1 byte for type of field 1
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for length of field 1 name
    [data appendBytes:(char[]){0x00, 0x0c} length:2];
    // 12 bytes for field 1 name
    [data appendBytes:(char[]){
        0x72, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x54, 0x79, 0x70,
        0x65, 0x5f
    } length:12];
    // 1 byte for type of field 2
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for length of field 2 name
    [data appendBytes:(char[]){0x00, 0x09} length:2];
    // 9 bytes for field 2 name
    [data appendBytes:(char[]){
        0x73, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x49, 0x44, 0x5f
    } length:9];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    // 4 byte for screenID value
    [Serialization writeIntValue:type data:data];
    // 4 byte for requestType value
    [Serialization writeIntValue:ID data:data];
}


/*+ (void)getListOfBUILDACGraphicScreenImageObjects:(NSMutableData *)data list:(NSMutableArray *)list
 {
 if ((data == nil) || (![data length]) || (list == nil)) {
 return;
 }
 
 // Remove 64 bytes from front
 [data replaceBytesInRange:NSMakeRange(0, 64) withBytes:NULL length:0];
 
 // Get number of all images
 int imgNum = [BUILDACSerialization getIntValue:data];
 // Get images list
 for (int idx = 0; idx < imgNum; idx ++) {
 if (idx == 0) {
 // Remove 98 bytes from front
 [data replaceBytesInRange:NSMakeRange(0, 98) withBytes:NULL length:0];
 // Get data size
 int dataSize = [BUILDACSerialization getIntValue:data];
 // Get data type
 int dataType = [BUILDACSerialization getIntValue:data];
 
 // Remove 19 bytes from front
 [data replaceBytesInRange:NSMakeRange(0, 19) withBytes:NULL length:0];
 // Get image size
 int imgSize = [BUILDACSerialization getIntValue:data];
 // Get image data
 Byte imgBytes[imgSize];
 [data getBytes:&imgBytes length:imgSize];
 NSData *imgData = [NSData dataWithBytes:&imgBytes length:imgSize];
 
 // Remove imgSize bytes from front
 [data replaceBytesInRange:NSMakeRange(0, imgSize) withBytes:NULL length:0];
 
 // Create new image
 BUILDACGraphicScreenImage *scrImg = [[BUILDACGraphicScreenImage alloc] initWithDataType:dataType dataSize:dataSize];
 [scrImg setImageData:imgData];
 [list addObject:scrImg];
 } else {
 // Remove 5 bytes from front
 [data replaceBytesInRange:NSMakeRange(0, 5) withBytes:NULL length:0];
 // Get data size
 int dataSize = [BUILDACSerialization getIntValue:data];
 // Get data type
 int dataType = [BUILDACSerialization getIntValue:data];
 
 // Remove 6 bytes from front
 [data replaceBytesInRange:NSMakeRange(0, 6) withBytes:NULL length:0];
 // Get image size
 int imgSize = [BUILDACSerialization getIntValue:data];
 // Get image data
 Byte imgBytes[imgSize];
 [data getBytes:&imgBytes length:imgSize];
 NSData *imgData = [NSData dataWithBytes:&imgBytes length:imgSize];
 
 // Remove imgSize bytes from front
 [data replaceBytesInRange:NSMakeRange(0, imgSize) withBytes:NULL length:0];
 
 // Create new image
 BUILDACGraphicScreenImage *scrImg = [[BUILDACGraphicScreenImage alloc] initWithDataType:dataType dataSize:dataSize];
 [scrImg setImageData:imgData];
 [list addObject:scrImg];
 }
 }
 
 }*/


//Get Report Valid term
+(NSMutableArray *)getReportValidTerm:(NSMutableData *)data
{
    if ((data == nil) || (![data length])) {
        return nil;
    }
    // Remove 27 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 27) withBytes:NULL length:0];
    long long startTime = [Serialization getLongValue:data]/1000;
    long long endTime = [Serialization getLongValue:data]/1000;
    NSMutableArray *term = [NSMutableArray new];
    [term addObject:[NSNumber numberWithLongLong:startTime]];
    [term addObject:[NSNumber numberWithLongLong:endTime]];
    return term;
}

// Write graphic symbol hit request object to a byte stream
+ (void)writeGraphicRequestSymbolHit:(NSMutableData *)data
                            screenID:(NSString *)screenID
                             readyNo:(int)readyNo
                            hitPoint:(CGPoint)hitPoint
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 1 byte for TC_OBJECT
    [data appendBytes:(char[]){0x73} length:1];
    // 1 byte for TC_CLASSDESC
    [data appendBytes:(char[]){0x72} length:1];
    // 2 bytes for lenght of class name
    [data appendBytes:(char[]){0x00, 0x32} length:2];
    // 50 bytes for class name
    [data appendBytes:(char[]){
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x67, 0x72, 0x61, 0x70, 0x68, 0x69,
        0x63, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x47, 0x72, 0x61,
        0x70, 0x68, 0x69, 0x63, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73,
        0x74, 0x53, 0x79, 0x6d, 0x62, 0x6f, 0x6c, 0x48, 0x69, 0x74
    } length:50];
    
    // 8 bytes for SerialVersionID
    [data appendBytes:(char[]){
        0x5c, 0xcd, 0x0e, 0x4a, 0xb0, 0x81, 0x6d, 0xa5
    } length:8];
    // 1 bytes for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    // 2 bytes for number of fields
    [data appendBytes:(char[]){0x00, 0x03} length:2]; // 3 field
    
    // 1 byte for type of field 1
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for length of field 1 name
    [data appendBytes:(char[]){0x00, 0x08} length:2];
    // 8 bytes for field 1 name
    [data appendBytes:(char[]){
        0x72, 0x65, 0x61, 0x64, 0x79, 0x4e, 0x6f, 0x5f
    } length:8];
    
    // 1 byte for type of field 2
    [data appendBytes:(char[]){0x4c} length:1];
    // 2 bytes for length of field 2 name
    [data appendBytes:(char[]){0x00, 0x09} length:2];
    // 9 bytes for field 2 name
    [data appendBytes:(char[]){
        0x68, 0x69, 0x74, 0x50, 0x6f, 0x69, 0x6e, 0x74, 0x5f
    } length:9];
    // 1 byte for TC_STRING
    [data appendBytes:(char[]){TC_STRING} length:1];
    // 2 bytes for length of string
    [data appendBytes:(char[]){0x00, 0x10} length:2];
    // 16 byte for string
    [data appendBytes:(char[]){
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x61, 0x77, 0x74, 0x2f,
        0x50, 0x6f, 0x69, 0x6e, 0x74, 0x3b
    } length:16];
    
    // 1 byte for type of field 3
    [data appendBytes:(char[]){0x4c} length:1];
    // 2 bytes for length of field 2 name
    [data appendBytes:(char[]){0x00, 0x09} length:2];
    // 9 bytes for field 2 name
    [data appendBytes:(char[]){
        0x73, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x49, 0x44, 0x5f
    } length:9];
    // 1 byte for TC_STRING
    [data appendBytes:(char[]){TC_STRING} length:1];
    // 2 bytes for length of string
    [data appendBytes:(char[]){0x00, 0x12} length:2];
    // 18 byte for string
    [data appendBytes:(char[]){
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e, 0x67,
        0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:18];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // 4 bytes for readyNo
    [Serialization writeIntValue:readyNo data:data];
    
    // Next 39 bytes
    [data appendBytes:(char[]){
        0x73, 0x72, 0x00, 0x0e, 0x6a, 0x61, 0x76, 0x61, 0x2e, 0x61,
        0x77, 0x74, 0x2e, 0x50, 0x6f, 0x69, 0x6e, 0x74, 0xb6, 0xc4,
        0x8a, 0x72, 0x34, 0x7e, 0xc8, 0x26, 0x02, 0x00, 0x02, 0x49,
        0x00, 0x01, 0x78, 0x49, 0x00, 0x01, 0x79, 0x78, 0x70
    } length:39];
    
    // 4 bytes for point.x
    [Serialization writeIntValue:(int)hitPoint.x data:data];
    // 4 bytes for point.y
    [Serialization writeIntValue:(int)hitPoint.y data:data];
    
    // Write screen ID string
    if (screenID != nil) {
        [Serialization writeStringValue:screenID data:data];
    } else {
        [data appendBytes:(char[]){TC_NULL} length:1];
    }
}

// Write graphic request search signal object to a byte stream
+ (void)writeGraphicRequestSearchSignal:(NSMutableData *)data
                               screenID:(int)screenID
                                  index:(int)index
                                readyNo:(int)readyNo
                            dataPointer:(NSString *)dpid
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 1 byte for TC_OBJECT
    [data appendBytes:(char[]){0x73} length:1];
    // 1 byte for TC_CLASSDESC
    [data appendBytes:(char[]){0x72} length:1];
    // 2 bytes for lenght of class name
    [data appendBytes:(char[]){0x00, 0x35} length:2]; // 53 bytes
    // 53 bytes for class name
    [data appendBytes:(char[]){
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x67, 0x72, 0x61, 0x70, 0x68, 0x69,
        0x63, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x47, 0x72, 0x61,
        0x70, 0x68, 0x69, 0x63, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73,
        0x74, 0x53, 0x65, 0x61, 0x72, 0x63, 0x68, 0x53, 0x69, 0x67,
        0x6e, 0x61, 0x6c
    } length:53];
    
    // 8 bytes for SerialVersionID
    [data appendBytes:(char[]){
        0xa2, 0x28, 0x1b, 0x79, 0x6b, 0x03, 0xf1, 0xb8
    } length:8];
    // 1 bytes for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of fields
    [data appendBytes:(char[]){0x00, 0x04} length:2]; // 4 field
    
    // 1 byte for type of field 1
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for length of field 1 name
    [data appendBytes:(char[]){0x00, 0x0c} length:2]; // 12 bytes
    // 12 bytes for field 1 name (offset_index)
    [data appendBytes:(char[]){
        0x6f, 0x66, 0x66, 0x73, 0x65, 0x74, 0x5f, 0x69, 0x6e, 0x64,
        0x65, 0x78
    } length:12];
    
    // 1 byte for type of field 2
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for length of field 2 name
    [data appendBytes:(char[]){0x00, 0x0a} length:2]; // 10 bytes
    // 10 bytes for field 2 name (offset_sid)
    [data appendBytes:(char[]){
        0x6f, 0x66, 0x66, 0x73, 0x65, 0x74, 0x5f, 0x73, 0x69, 0x64
    } length:10];
    
    
    // 1 byte for type of field 3
    [data appendBytes:(char[]){0x49} length:1];
    // 2 bytes for length of field 3 name
    [data appendBytes:(char[]){0x00, 0x08} length:2]; // 8 bytes
    // 8 bytes for field 3 name (readyNo_)
    [data appendBytes:(char[]){
        0x72, 0x65, 0x61, 0x64, 0x79, 0x4e, 0x6f, 0x5f
    } length:8];
    
    // 1 byte for type of field 4
    [data appendBytes:(char[]){0x4c} length:1];
    // 2 bytes for length of field 4 name
    [data appendBytes:(char[]){0x00, 0x05} length:2]; // 5 bytes
    // 5 bytes for field 4 name (dpid_)
    [data appendBytes:(char[]){
        0x64, 0x70, 0x69, 0x64, 0x5f
    } length:5];
    // 21 bytes for field 4 type
    [data appendBytes:(char[]){
        0x74, 0x00, 0x12, 0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c,
        0x61, 0x6e, 0x67, 0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67,
        0x3b
    } length:21];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // 4 bytes for screen index
    [Serialization writeIntValue:(int)index data:data];
    // 4 bytes for screen ID
    [Serialization writeIntValue:(int)screenID data:data];
    // 4 bytes for readyNo
    [Serialization writeIntValue:(int)readyNo data:data];
    // Write data pointer string
    NSString *str = (dpid != nil) ? dpid : @"";
    [Serialization writeStringValue:str data:data];
}


// Get an array of string from a byte stream
+ (NSMutableArray *)getStringArray:(NSMutableData *)data
{
    //    NSMutableData *clonedDat = [NSMutableData dataWithData:data];
    Byte object[6];
    [data getBytes:&object length:6];
    if ((object[0] == 0x50) && (object[1] == 0x61) && (object[2] == 0x72) && (object[3] == 0x61) && (object[4] == 0x5f) && (object[5] == 0x71)){
        [data replaceBytesInRange:NSMakeRange(0, 16) withBytes:NULL length:0];
    }
    
    // Get the first byte
    Byte objectValue[1];
    [data getBytes:&objectValue length:1];
    // Check the first byte
    if (objectValue[0] == TC_NULL) {
        // Remove 1 bytes from front
        [data replaceBytesInRange:NSMakeRange(0, 1) withBytes:NULL length:0];
        // Return null value
        return nil;
    } else {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        // Remove 32 bytes from front
        [data replaceBytesInRange:NSMakeRange(0, 36) withBytes:NULL length:0];
        // Get array count
        int count = [Serialization getIntValue:data];
        for (int idx = 0; idx < count; idx ++) {
            NSString * str = [Serialization getStringValue:data];
            [array addObject:str];
        }
        return array;
    }
}

// Get alarm state from a byte stream
+ (NSMutableArray *)getAlarmState:(NSMutableData *)data
{
    // Remove 6 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 6) withBytes:NULL length:0];
    // Get process alarm state
    NSNumber *processAlarm = [NSNumber numberWithInt:[Serialization getIntValue:data]];
    // Get system alarm state
    NSNumber *systemAlarm = [NSNumber numberWithInt:[Serialization getIntValue:data]];
    // Get communication state
    NSNumber *commState = [NSNumber numberWithInt:[Serialization getIntValue:data]];
    
    // Remove 32 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 32) withBytes:NULL length:0];
    // Get alarm level
    int t = [Serialization getIntValue:data];
    NSNumber *alarmLevel = [NSNumber numberWithInt:t];
    // return
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:processAlarm];
    [array addObject:systemAlarm];
    [array addObject:commState];
    [array addObject:alarmLevel];
    return array;
}

+ (void)writeRequestAlarmState:(NSMutableData *)data
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // Write string alarm
    [Serialization writeStringValue:@"Alarm" data:data];
}

+ (void)writeRequestLogoff:(NSMutableData *)data
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // Write string logoff
    [Serialization writeStringValue:@"Logoff" data:data];
}

+ (void)writeRequestStopAlarm:(NSMutableData *)data
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // Write string
    [Serialization writeStringValue:@"StopAlarm" data:data];
}

+ (void)removeRedundantBytes:(NSMutableData *)data
{
    if (data.length == 0) {
        return ;
    }
    NSMutableData *tempData = [NSMutableData dataWithData:data];
    for (int i = 0; i < tempData.length; i++) {
        if (data.length >= 1){
            Byte type[1];
            [data getBytes:&type length:1];
            if (type[0] != 0x74) {
                [data replaceBytesInRange:NSMakeRange(0, 1) withBytes:NULL length:0];
            }else{
                tempData = nil;
                return;
            }
        }
        {
            tempData = nil;
            return;
        }
    }
    
}

// TREND FUNCTION
+ (void)writeRequestTrendGroupIndexObject:(NSMutableData *)data
                              offsetIndex:(int)offset
                              requestSize:(int)size
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 48 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x2e,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x49, 0x6e, 0x64, 0x65, 0x78
    } length:48];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0x67, 0xd4, 0x71, 0xad, 0x36, 0xbb, 0x4a, 0x61
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x02} length:2];
    // 15 bytes for name of field 1
    [data appendBytes:(char[]){
        0x49, 0x00, 0x0c, 0x5f, 0x6f, 0x66, 0x66, 0x73, 0x65, 0x74,
        0x49, 0x6e, 0x64, 0x65, 0x78
    } length:15];
    // 15 bytes for name of field 2
    [data appendBytes:(char[]){
        0x49, 0x00, 0x0c, 0x5f, 0x72, 0x65, 0x71, 0x75, 0x65, 0x73,
        0x74, 0x53, 0x69, 0x7a, 0x65
    } length:15];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write offset index
    [Serialization writeIntValue:offset data:data];
    // Write request size
    [Serialization writeIntValue:size data:data];
}

// Get string value from a byte stream with UTF-8 encoding
+ (NSString *)getUTFStringValue:(NSMutableData *)data
{
    // Get length of string
    int length = [Serialization getInt16Value:data];
    if (length == 0) {
        return @"";
    }
    // Get string
    Byte stringByte[length];
    [data getBytes:&stringByte length:length];
    NSData *stringData = [[NSData alloc] initWithBytes:stringByte length:length];
    // Remove lenght bytes from front
    [data replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
    // Return result
    @try {
        NSString *string = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
        return string;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (void)writeRequestTrendGroupDef:(NSMutableData *)data
                      requestType:(int)type
                          groupNo:(int)groupNo
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 46 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x2c,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x44, 0x65, 0x66
    } length:46];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0x89, 0x6a, 0xd0, 0x20, 0xdc, 0xb2, 0xce, 0x24
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x03} length:2];
    // 11 bytes for name of field 1 (groupNo)
    [data appendBytes:(char[]){
        0x49, 0x00, 0x08,
        0x5f, 0x67, 0x72, 0x6f, 0x75, 0x70, 0x4e, 0x6f
    } length:11];
    // 15 bytes for name of field 2 (requestType)
    [data appendBytes:(char[]){
        0x49, 0x00, 0x0c, 0x5f, 0x72, 0x65, 0x71, 0x75, 0x65, 0x73,
        0x74, 0x54, 0x79, 0x70, 0x65
    } length:15];
    // 12 bytes for name of field 3 (groupDef)
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x09,
        0x5f, 0x67, 0x72, 0x6f, 0x75, 0x70, 0x44, 0x65, 0x66
    } length:12];
    // 44 bytes for type of field 3
    [data appendBytes:(char[]){
        0x74, 0x00, 0x29,
        0x4c, 0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2f, 0x6a,
        0x70, 0x77, 0x65, 0x62, 0x2f, 0x74, 0x72, 0x65, 0x6e, 0x64,
        0x6e, 0x2f, 0x75, 0x74, 0x69, 0x6c, 0x2f, 0x54, 0x72, 0x65,
        0x6e, 0x64, 0x57, 0x65, 0x62, 0x47, 0x72, 0x6f, 0x75, 0x70,
        0x3b
    } length:44];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write group number
    [Serialization writeIntValue:groupNo data:data];
    // Write request type
    [Serialization writeIntValue:type data:data];
    // 1 byte for null
    [data appendBytes:(char[]){0x70} length:1];
}

+ (void)writeRequestGroupInitialize:(NSMutableData *)data
                        dataPointer:(NSMutableArray *)dpid
                        timescaleNo:(int)timeScale
                          containSU:(BOOL)suContainFlag
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 53 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x33,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x49, 0x6e, 0x69, 0x74, 0x69, 0x61, 0x6c, 0x69, 0x7a,
        0x65
    } length:53];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0x84, 0xa3, 0xa7, 0xbe, 0x9d, 0xcc, 0x32, 0x14
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x03} length:2];
    // 17 bytes for name of field 1 (suContainFlag)
    [data appendBytes:(char[]){
        0x5a, 0x00, 0x0e,
        0x5f, 0x73, 0x75, 0x43, 0x6f, 0x6e, 0x74, 0x61, 0x69, 0x6e,
        0x46, 0x6c, 0x61, 0x67
    } length:17];
    // 15 bytes for name of field 2 (timeScaleNo)
    [data appendBytes:(char[]){
        0x49, 0x00, 0x0c,
        0x5f, 0x74, 0x69, 0x6d, 0x65, 0x73, 0x63, 0x61, 0x6c, 0x65,
        0x4e, 0x6f
    } length:15];
    // 8 bytes for name of field 3 (dpid)
    [data appendBytes:(char[]){
        0x5b, 0x00, 0x05,
        0x5f, 0x64, 0x70, 0x69, 0x64
    } length:8];
    // 22 bytes for type of field 3
    [data appendBytes:(char[]){
        0x74, 0x00, 0x13,
        0x5b, 0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e,
        0x67, 0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:22];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write su contain flag
    [data appendBytes:(char[]){suContainFlag ? 0x01 : 0x00} length:1];
    // Write time scale no
    [Serialization writeIntValue:timeScale data:data];
    
    // Write dpdi
    // 23 bytes for class name
    [data appendBytes:(char[]){
        0x75, 0x72,
        0x00, 0x13,
        0x5b, 0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2e, 0x6c, 0x61, 0x6e,
        0x67, 0x2e, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:23];
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xad, 0xd2, 0x56, 0xe7, 0xe9, 0x1d, 0x7b, 0x47
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    // next 4 bytes
    [data appendBytes:(char[]){
        0x00, 0x00, 0x78, 0x70
    } length:4];
    
    int count = (int)[dpid count];
    [Serialization writeIntValue:count data:data];
    for (int idx = 0; idx < count; idx ++) {
        NSString *string = (NSString *)[dpid objectAtIndex:idx];
        [Serialization writeStringValue:string data:data];
    }
}

+ (long long)getTrendBaseTime:(NSMutableData *)data
{
    // Remove 6 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 6) withBytes:NULL length:0];
    return [Serialization getLongValue:data];
}


+ (void)writeRequestLastestData:(NSMutableData *)data
                           date:(long long)date
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 53 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x33,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x4c, 0x61, 0x74, 0x65, 0x73, 0x74, 0x44, 0x61, 0x74,
        0x61
    } length:53];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xfa, 0x09, 0x28, 0x61, 0x65, 0x01, 0x2e, 0x66
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x01} length:2];
    // 8 bytes for name of field 1 (date)
    [data appendBytes:(char[]){
        0x4a, 0x00, 0x05,
        0x5f, 0x64, 0x61, 0x74, 0x65
    } length:8];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write date
    [Serialization writeLongValue:date data:data];
}

+ (void)writeRequestLoginLevelCheck:(NSMutableData *)data
{
    // 91 bytes
    [data appendBytes:(char[]){
        0xac, 0xed, 0x00, 0x05, 0x73, 0x72, 0x00, 0x33, 0x6e, 0x78,
        0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70, 0x77, 0x65,
        0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e, 0x2e, 0x75,
        0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52, 0x65, 0x71,
        0x75, 0x65, 0x73, 0x74, 0x4c, 0x6f, 0x67, 0x69, 0x6e, 0x4c,
        0x65, 0x76, 0x65, 0x6c, 0x43, 0x68, 0x65, 0x63, 0x6b, 0x05,
        0xaf, 0x9a, 0x89, 0x27, 0x56, 0x53, 0x7b, 0x02, 0x00, 0x01,
        0x49, 0x00, 0x0c, 0x5f, 0x72, 0x65, 0x71, 0x75, 0x65, 0x73,
        0x74, 0x54, 0x79, 0x70, 0x65, 0x78, 0x70, 0x00, 0x00, 0x00,
        0x00
    } length:91];
}

+ (BOOL)getLoginLevelCheck:(NSMutableData *)data
{
    // Remove 4 bytes from front (STREAM_MAGIC)
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:NULL length:0];
    // Remove 2 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 2) withBytes:NULL length:0];
    // Get bool value
    return [Serialization getBoolValue:data];
}

+ (void)writeRequestGroupData:(NSMutableData *)data
                         date:(long long)date
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 47 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x2d,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x44, 0x61, 0x74, 0x61
    } length:47];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0x9b, 0x51, 0x60, 0x1b, 0x54, 0xb1, 0x89, 0x1c
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x01} length:2];
    // 9 bytes for name of field 1 (date)
    [data appendBytes:(char[]){
        0x4a, 0x00, 0x06,
        0x5f, 0x73, 0x64, 0x61, 0x74, 0x65
    } length:9];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write date
    [Serialization writeLongValue:date data:data];
}

+ (void)writeRequestChangeTimeScale:(NSMutableData *)data
                        timeScaleNo:(int)timeScaleNo
                          containSu:(BOOL)suContainFlag;
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 58 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x38,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x43, 0x68, 0x61, 0x6e, 0x67, 0x65, 0x54, 0x69, 0x6d,
        0x65, 0x53, 0x63, 0x61, 0x6c, 0x65
    } length:58];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xc9, 0x84, 0x49, 0x57, 0xa7, 0xb7, 0x8a, 0xed
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x02} length:2];
    
    // 17 bytes for field 1
    [data appendBytes:(char[]){
        0x5a, 0x00, 0x0e,
        0x5f, 0x73, 0x75, 0x43, 0x6f, 0x6e, 0x74, 0x61, 0x69, 0x6e,
        0x46, 0x6c, 0x61, 0x67
    } length:17];
    
    // 15 bytes for field 2
    [data appendBytes:(char[]){
        0x49, 0x00, 0x0c,
        0x5f, 0x74, 0x69, 0x6d, 0x65, 0x73, 0x63, 0x61, 0x6c, 0x65,
        0x4e, 0x6f
    } length:15];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    [data appendBytes:(char[]){suContainFlag ? 0x01 : 0x00} length:1];
    [Serialization writeIntValue:timeScaleNo data:data];
}

+ (void)writeRequestValidTerm:(NSMutableData *)data
                  requestType:(int)requestType
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 51 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x31,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x54, 0x65, 0x72, 0x6d, 0x49, 0x6e, 0x66, 0x6f
    } length:51];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xd5, 0xf7, 0xeb, 0x91, 0x9a, 0xed, 0x53, 0x7d
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x01} length:2];
    
    // 15 bytes for field 1
    [data appendBytes:(char[]){
        0x49, 0x00, 0x0c,
        0x5f, 0x72, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x54, 0x79,
        0x70, 0x65
    } length:15];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    [Serialization writeIntValue:requestType data:data];
}

+ (NSMutableArray *)getTrendValidTerm:(NSMutableData *)data
{
    // Remove 4 bytes from front (STREAM_MAGIC)
    [data replaceBytesInRange:NSMakeRange(0, 4) withBytes:NULL length:0];
    // Remove 2 bytes from front
    [data replaceBytesInRange:NSMakeRange(0, 2) withBytes:NULL length:0];
    // Get bool value
    if (![Serialization getBoolValue:data]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    long long val1 =  [Serialization getLongValue:data];
    long long val2 =  [Serialization getLongValue:data];
    [array addObject:[NSNumber numberWithLongLong:val1]];
    [array addObject:[NSNumber numberWithLongLong:val2]];
    //     NSString *time1 = [Utility getTimeString:val1];
    //     NSString *time2 = [Utility getTimeString:val2];
    return array;
}

+ (void)writeRequestTrendGroupWithSignal:(NSMutableData *)data
                                 groupNo:(int)groupNo
                           dataPointerID:(NSString *)dpid
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 56 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x36,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x74, 0x72, 0x65, 0x6e, 0x64, 0x6e,
        0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x69, 0x6f, 0x2e, 0x52,
        0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x47, 0x72, 0x6f, 0x75,
        0x70, 0x44, 0x65, 0x66, 0x57, 0x69, 0x74, 0x68, 0x53, 0x69,
        0x67, 0x6e, 0x61, 0x6c
    } length:56];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xcb, 0x98, 0xb6, 0x4e, 0xda, 0x4f, 0x01, 0x4a
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x02} length:2];
    
    // 11 bytes for field 1
    [data appendBytes:(char[]){
        0x49, 0x00, 0x08,
        0x5f, 0x67, 0x72, 0x6f, 0x75, 0x70, 0x4e, 0x6f
    } length:11];
    
    // 29 bytes for field 2
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x05,
        0x5f, 0x64, 0x70, 0x49, 0x44,
        0x74, 0x00, 0x12,
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e, 0x67,
        0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:29];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    [Serialization writeIntValue:groupNo data:data];
    [Serialization writeStringValue:dpid data:data];
}


+ (void)writeFpRequestDispInfoObject:(NSMutableData *)data
                                para:(NSMutableArray *)para
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 55 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x35,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
        0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x46,
        0x61, 0x63, 0x65, 0x50, 0x6c, 0x61, 0x74, 0x65, 0x52, 0x65,
        0x71, 0x75, 0x65, 0x73, 0x74, 0x44, 0x69, 0x73, 0x70, 0x49,
        0x6e, 0x66, 0x6f
    } length:55];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0x85, 0x1f, 0x15, 0x6f, 0x19, 0x1b, 0x4d, 0x3c
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x02} length:2];
    
    // 31 bytes for field 1
    [data appendBytes:(char[]){
        0x5b, 0x00, 0x06,
        0x70, 0x61, 0x72, 0x61, 0x6d, 0x5f,
        0x74, 0x00, 0x13,
        0x5b, 0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e,
        0x67, 0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:31];
    
    // 31 bytes for field 2
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x07,
        0x75, 0x6e, 0x69, 0x74, 0x49, 0x44, 0x5f,
        0x74, 0x00, 0x12,
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e, 0x67,
        0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:31];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Next 34 bytes
    [data appendBytes:(char[]){
        0x75, 0x72,
        0x00, 0x13,
        0x5b, 0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2e, 0x6c, 0x61, 0x6e,
        0x67, 0x2e, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b,
        0xad, 0xd2, 0x56, 0xe7, 0xe9, 0x1d, 0x7b, 0x47, 0x02,
        0x00, 0x00
    } length:34];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write para
    int count = (int)[para count];
    [Serialization writeIntValue:count data:data];
    for (int idx = 0; idx < count; idx ++) {
        NSString *string = [para objectAtIndex:idx];
        [Serialization writeStringValue:string data:data];
    }
    // 1 byte for null object
    [data appendBytes:(char[]){0x70} length:1];
}

+ (void)writeFpRequestTagInfoObject:(NSMutableData *)data
                                key:(NSString *)key
                               flag:(BOOL)flag
                              value:(short)value
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 54 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x34,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
        0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x46,
        0x61, 0x63, 0x65, 0x50, 0x6c, 0x61, 0x74, 0x65, 0x52, 0x65,
        0x71, 0x75, 0x65, 0x73, 0x74, 0x54, 0x61, 0x67, 0x49, 0x6e,
        0x66, 0x6f
    } length:54];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xc3, 0x39, 0xec, 0x0c, 0x4f, 0x81, 0x9a, 0x7d
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x03} length:2];
    
    // 8 bytes for field 1
    [data appendBytes:(char[]){
        0x5a, 0x00, 0x05,
        0x66, 0x6c, 0x61, 0x67, 0x5f
    } length:8];
    
    // 9 bytes for field 2
    [data appendBytes:(char[]){
        0x53, 0x00, 0x06,
        0x76, 0x61, 0x6c, 0x75, 0x65, 0x5f
    } length:9];
    
    // 30 bytes for field 3
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x06,
        0x65, 0x71, 0x4b, 0x65, 0x79, 0x5f,
        0x74, 0x00, 0x12,
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e, 0x67,
        0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:30];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    // Flag
    [data appendBytes:(char[]){flag ? 0x01 : 0x00} length:1];
    // Value
    [Serialization writeInt16Value:value data:data];
    // Key
    [Serialization writeStringValue:key data:data];
}

+ (void)writeFpRequestDataPointerObject:(NSMutableData *)data
                                  dpkey:(NSMutableArray *)dpkey
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 58 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x38,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
        0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x46,
        0x61, 0x63, 0x65, 0x50, 0x6c, 0x61, 0x74, 0x65, 0x52, 0x65,
        0x71, 0x75, 0x65, 0x73, 0x74, 0x44, 0x61, 0x74, 0x61, 0x50,
        0x6f, 0x69, 0x6e, 0x74, 0x65, 0x72
    } length:58];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0x1f, 0x9a, 0x00, 0xfe, 0xfc, 0x81, 0x8c, 0xac
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x01} length:2];
    
    // 31 bytes for field 1
    [data appendBytes:(char[]){
        0x5b, 0x00, 0x06,
        0x64, 0x70, 0x4b, 0x65, 0x79, 0x5f,
        0x74, 0x00, 0x13,
        0x5b, 0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e,
        0x67, 0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:31];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // next 34 bytes
    [data appendBytes:(char[]){
        0x75, 0x72, 0x00, 0x13,
        0x5b, 0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2e, 0x6c, 0x61, 0x6e,
        0x67, 0x2e, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b,
        0xad, 0xd2, 0x56, 0xe7, 0xe9, 0x1d, 0x7b, 0x47, 0x02,
        0x00, 0x00
    } length:34];
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    int size = (int)[dpkey count];
    [Serialization writeIntValue:size data:data];
    for (int idx = 0; idx < size; idx ++) {
        NSString *string = [dpkey objectAtIndex:idx];
        if ([string isEqualToString:@""]) {
            // 1 byte for TC_NULL
            [data appendBytes:(char[]){0x70} length:1];
        }   else {
            [Serialization writeStringValue:string data:data];
        }
    }
}

+ (BOOL)isFpSuDataPointer:(NSMutableData *)data ref:(int)ref
{
    // Check reference number
    @try {
        // Create suData
        NSMutableData *refData = [[NSMutableData alloc] init];
        [refData appendBytes:(char[]) {
            0x73, 0x71, 0x00, 0x7e
        } length:4];
        [Serialization writeInt16Value:ref
                                  data:refData];
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 6)]];
        // Compare
        if ([refData isEqualToData:subData]) {
            return YES;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    
    @try {
        // Create suData
        NSMutableData *suData = [[NSMutableData alloc] init];
        [suData appendBytes:(char[]) {
            0x73, 0x72,
            0x00, 0x2f,
            0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
            0x77, 0x65,0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
            0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x57,
            0x65, 0x62, 0x46, 0x70, 0x53, 0x75, 0x44, 0x61, 0x74, 0x61,
            0x50, 0x6f, 0x69, 0x6e, 0x74, 0x65, 0x72
        } length:51];
        
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 51)]];
        
        // Compare
        return [suData isEqualToData:subData];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)isFpPvDataPointer:(NSMutableData *)data ref:(int)ref
{
    // Check reference number
    @try {
        // Create suData
        NSMutableData *refData = [[NSMutableData alloc] init];
        [refData appendBytes:(char[]) {
            0x73, 0x71, 0x00, 0x7e
        } length:4];
        [Serialization writeInt16Value:ref
                                  data:refData];
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 6)]];
        // Compare
        if ([refData isEqualToData:subData]) {
            return YES;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    
    
    @try {
        // Create suData
        NSMutableData *pvData = [[NSMutableData alloc] init];
        [pvData appendBytes:(char[]) {
            0x73, 0x72,
            0x00 , 0x2f,
            0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
            0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
            0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x57,
            0x65, 0x62, 0x46, 0x70, 0x50, 0x76, 0x44, 0x61, 0x74, 0x61,
            0x50, 0x6f, 0x69, 0x6e, 0x74, 0x65, 0x72
        } length:51];
        
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 51)]];
        
        // Compare
        return [pvData isEqualToData:subData];
    }
    @catch (NSException *exception) {
        return NO;
    }
}


+ (BOOL)isFpDoDataPointer:(NSMutableData *)data
                      ref:(int)ref
{
    // Check reference number
    @try {
        // Create suData
        NSMutableData *refData = [[NSMutableData alloc] init];
        [refData appendBytes:(char[]) {
            0x73, 0x71, 0x00, 0x7e
        } length:4];
        // Start Modify on v1.01
        //        [Serialization writeInt16Value:ref
        //                                  data:refData];
        // Check subdata
        //        NSMutableData *subData =
        //        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 6)]];
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 4)]];
        // End Modify
        // Compare
        if ([refData isEqualToData:subData]) {
            return YES;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    
    @try {
        // Create diData
        NSMutableData *doData = [[NSMutableData alloc] init];
        [doData appendBytes:(char[]) {
            0x73, 0x72, 0x00, 0x2f,
            0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
            0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
            0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x57,
            0x65, 0x62, 0x46, 0x70, 0x44, 0x6f, 0x44, 0x61, 0x74, 0x61,
            0x50, 0x6f, 0x69, 0x6e, 0x74, 0x65, 0x72
        } length:51];
        
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 51)]];
        
        // Compare
        return [doData isEqualToData:subData];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)isFpDiDataPointer:(NSMutableData *)data ref:(int)ref
{
    // Check reference number
    @try {
        // Create suData
        NSMutableData *refData = [[NSMutableData alloc] init];
        [refData appendBytes:(char[]) {
            0x73, 0x71, 0x00, 0x7e
        } length:4];
        [Serialization writeInt16Value:ref
                                  data:refData];
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 6)]];
        // Compare
        if ([refData isEqualToData:subData]) {
            return YES;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    
    @try {
        // Create diData
        NSMutableData *diData = [[NSMutableData alloc] init];
        [diData appendBytes:(char[]) {
            0x73, 0x72,
            0x00, 0x2f,
            0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
            0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
            0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x57,
            0x65, 0x62, 0x46, 0x70, 0x44, 0x69, 0x44, 0x61, 0x74, 0x61,
            0x50, 0x6f, 0x69, 0x6e, 0x74, 0x65, 0x72
        } length:51];
        
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 51)]];
        
        // Compare
        return [diData isEqualToData:subData];
    }
    @catch (NSException *exception) {
        return NO;
    }
}


+ (void)writeRequestAddLog:(NSMutableData *)data
                  funcName:(NSString *)funcName
                screenName:(NSString *)screenName
                   content:(NSString *)content
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 46 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x2c,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
        0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x46,
        0x70, 0x4f, 0x70, 0x65, 0x72, 0x61, 0x74, 0x69, 0x6f, 0x6e,
        0x44, 0x61, 0x74, 0x61
    } length:46];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0x31, 0x81, 0x7d, 0x70, 0x52, 0x74, 0x3e, 0x56
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x03} length:2];
    
    // 33 bytes for field 1: content
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x09,
        0x63, 0x6f, 0x6e, 0x74, 0x65, 0x6e, 0x74, 0x73, 0x5f,
        0x74, 0x00, 0x12,
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e, 0x67,
        0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:33];
    
    // 17 bytes for field 2: functionName
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x09,
        0x66, 0x75, 0x6e, 0x63, 0x4e, 0x61, 0x6d, 0x65, 0x5f,
        0x71, 0x00, 0x7e, 0x00, 0x01
    } length:17];
    
    // 19 bytes for field 3: screenName
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x0b,
        0x73, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x4e, 0x61, 0x6d, 0x65,
        0x5f,
        0x71, 0x00, 0x7e, 0x00, 0x01
    } length:19];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    [Serialization writeStringValue:content data:data];
    [Serialization writeStringValue:funcName data:data];
    [Serialization writeStringValue:screenName data:data];
}

+ (void)writeFpRequestDoOutputObject:(NSMutableData *)data
                                 key:(NSString *)key
                               value:(BOOL)value
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 55 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x35,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
        0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x46,
        0x61, 0x63, 0x65, 0x50, 0x6c, 0x61, 0x74, 0x65, 0x52, 0x65,
        0x71, 0x75, 0x65, 0x73, 0x74, 0x44, 0x6f, 0x4f, 0x75, 0x74,
        0x70, 0x75, 0x74
    } length:55];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xae, 0x2e, 0xb7, 0x54, 0x64, 0xc3, 0x04, 0xbe
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x02} length:2];
    
    // 9 bytes for field 1
    [data appendBytes:(char[]){
        0x5a, 0x00, 0x06,
        0x76, 0x61, 0x6c, 0x75, 0x65, 0x5f
    } length:9];
    
    // 30 bytes for field 2
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x06,
        0x64, 0x70, 0x4b, 0x65, 0x79, 0x5f,
        0x74, 0x00, 0x12,
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e, 0x67,
        0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:30];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    [data appendBytes:(char[]){value ? 0x01 : 0x00} length:1];
    [Serialization writeStringValue:key data:data];
}

+ (void)writeFpRequestSuResetObject:(NSMutableData *)data
                              dpKey:(NSString *)dpKey
{
    // 2 bytes for STREAM_MAGIC
    [data appendBytes:(char[]){0xac, 0xed} length:2];
    // 2 bytes for STREAM_VERSION
    [data appendBytes:(char[]){0x00, 0x05} length:2];
    // 2 bytes for TC_OBJECT and TC_CLASSDESC
    [data appendBytes:(char[]){0x73, 0x72} length:2];
    
    // 54 bytes for class name
    [data appendBytes:(char[]){
        0x00, 0x34,
        0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
        0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
        0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x46,
        0x61, 0x63, 0x65, 0x50, 0x6c, 0x61, 0x74, 0x65, 0x52, 0x65,
        0x71, 0x75, 0x65, 0x73, 0x74, 0x53, 0x75, 0x52, 0x65, 0x73,
        0x65, 0x74
    } length:54];
    
    // 8 bytes for serialversionID
    [data appendBytes:(char[]){
        0xd3, 0x29, 0x18, 0xc3, 0xb9, 0x2c, 0x0c, 0x19
    } length:8];
    // 1 byte for SC_SERIALIZABLE
    [data appendBytes:(char[]){0x02} length:1];
    
    // 2 bytes for number of field
    [data appendBytes:(char[]){0x00, 0x01} length:2];
    
    // 30 bytes for field 1
    [data appendBytes:(char[]){
        0x4c, 0x00, 0x06,
        0x64, 0x70, 0x4b, 0x65, 0x79, 0x5f,
        0x74, 0x00, 0x12,
        0x4c, 0x6a, 0x61, 0x76, 0x61, 0x2f, 0x6c, 0x61, 0x6e, 0x67,
        0x2f, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x3b
    } length:30];
    
    // 1 byte for TC_ENDBLOCKDATA
    [data appendBytes:(char[]){0x78} length:1];
    // 1 byte for TC_NULL
    [data appendBytes:(char[]){0x70} length:1];
    
    // Write data
    [Serialization writeStringValue:dpKey data:data];
}

+ (BOOL)isFpAoDataPointer:(NSMutableData *)data
                      ref:(int)ref
{
    // Check reference number
    @try {
        // Create suData
        NSMutableData *refData = [[NSMutableData alloc] init];
        [refData appendBytes:(char[]) {
            0x73, 0x71, 0x00, 0x7e
        } length:4];
        [Serialization writeInt16Value:ref
                                  data:refData];
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 6)]];
        // Compare
        if ([refData isEqualToData:subData]) {
            return YES;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    
    @try {
        // Create aoData
        NSMutableData *aoData = [[NSMutableData alloc] init];
        [aoData appendBytes:(char[]) {
            0x73, 0x72,
            0x00, 0x2f,
            0x6e, 0x78, 0x77, 0x6f, 0x72, 0x6b, 0x73, 0x2e, 0x6a, 0x70,
            0x77, 0x65, 0x62, 0x2e, 0x66, 0x61, 0x63, 0x65, 0x70, 0x6c,
            0x61, 0x74, 0x65, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x57,
            0x65, 0x62, 0x46, 0x70, 0x41, 0x6f, 0x44, 0x61, 0x74, 0x61,
            0x50, 0x6f, 0x69, 0x6e, 0x74, 0x65, 0x72,
            
        } length:51];
        
        // Check subdata
        NSMutableData *subData =
        [[NSMutableData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 51)]];
        
        // Compare
        return [aoData isEqualToData:subData];
    }
    @catch (NSException *exception) {
        return NO;
    }
}


@end
