//
//  Serialization.h
//  BUILDAC
//
//  Created by tiennv on 1/23/14.
//  Copyright (c) 2014 TSDV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Serialization : NSObject

// Compress/Extract data by GZIP algorithm
+ (NSData *)gzippedDataWithCompressionLevel:(float)level data:(NSData *)data;
+ (NSData *)gzippedData:(NSData *)data;
+ (NSData *)gunzippedData:(NSData *)data; // decompress data with GZIP format
+ (NSData *)zunzippedData:(NSData *)data; // decompress data with ZLIB format

+ (int)getIntValue:(NSMutableData *)data;
+ (int)getInt16Value:(NSMutableData *)data;
+ (NSString *)getStringValue:(NSMutableData *)data;
+ (BOOL)getBoolValue:(NSMutableData *)data;
+ (void)writeStringValue:(NSString *)string data:(NSMutableData *)data;
+ (void)writeIntValue:(int)value data:(NSMutableData *)data;
+ (void)writeInt16Value:(int)value data:(NSMutableData *)data;
+ (double)getDoubleValue:(NSMutableData *)data;

+ (long long)getLongValue:(NSMutableData *)data;
+ (NSMutableArray *)getStringArray:(NSMutableData *)data;

//+ (BOOL)readBooleanObject:(NSMutableData *)data;
//+ (void)writeBooleanObject:(NSMutableData *)data object:(BOOL)object;

//// GRAPHIC FUNCTON
//+ (void)writeGraphicRequestPageInfoObject:(NSMutableData *)data
//                              offsetIndex:(int)offset
//                              requestSize:(int)size;
//
//+ (void)writeGraphicRequestImageObject:(NSMutableData *)data
//                           requestType:(int)type
//                              screenID:(int)ID;
////+ (void)getListOfBUILDACGraphicScreenImageObjects:(NSMutableData *)data list:(NSMutableArray *)list;
//+ (void)writeGraphicRequestSearchSignal:(NSMutableData *)data
//                            screenID:(int)screenID
//                               index:(int)index
//                             readyNo:(int)readyNo
//                         dataPointer:(NSString *)dpid;
//+ (void)writeGraphicRequestSymbolHit:(NSMutableData *)data
//                            screenID:(NSString *)screenID
//                             readyNo:(int)readyNo
//                            hitPoint:(CGPoint)hitPoint;
//+ (NSMutableArray *)getCompressContinueImageData:(NSMutableData *)data;
//+ (NSMutableArray *)getListOfGraphicScreenIndexObjects:(NSMutableData *)data
//                                       withOffsetIndex:(int)offset;
//+ (NSMutableArray *)getCompressPreNextImageData:(NSMutableData *)data;
//
//+ (NSMutableArray *)getGraphicSignalSearchingData:(NSMutableData *)data;
//
//// REPORT FUNCTION
//+ (void)getListOfReportGroups:(NSMutableData *)data
//                         list:(NSMutableArray *)list;
//
////Get Report Valid term
//+(NSMutableArray *)getReportValidTerm:(NSMutableData *)data;
//
//
//// COMMON FUNCTION
//+ (NSMutableArray *)getAlarmState:(NSMutableData *)data;
//+ (void)writeRequestAlarmState:(NSMutableData *)data;
//+ (void)writeRequestLogoff:(NSMutableData *)data;
//+ (void)writeRequestStopAlarm:(NSMutableData *)data;
//
//// MESSAGE FUNCTION
//+ (void)writeRealtimeMessageRequestObject:(NSMutableData *)data
//                                cycleFlag:(BOOL)cycleFlag
//                             searchString:(NSString *)searchString
//                          searchPositions:(NSMutableArray *)positions;
//+ (void)writeHistoricalMessageRequestObject:(NSMutableData *)data
//                                  condition:(NSMutableArray *)condition
//                               searchString:(NSString *)searchString
//                            searchPositions:(NSMutableArray *)positions;
//+ (void)writeFacilityRequestObject:(NSMutableData *)data;
//
//
//// TREND FUNCTION
//// Write Request trend group index
//+ (void)writeRequestTrendGroupIndexObject:(NSMutableData *)data
//                              offsetIndex:(int)offset
//                              requestSize:(int)size;
//
//+ (void)writeRequestTrendGroupDef:(NSMutableData *)data
//                         requestType:(int)type
//                             groupNo:(int)groupNo;
//
//+ (void)writeRequestGroupInitialize:(NSMutableData *)data
//                        dataPointer:(NSMutableArray *)dpid
//                        timescaleNo:(int)timeScale
//                          containSU:(BOOL)suContainFlag;
//
//+ (long long)getTrendBaseTime:(NSMutableData *)data;
//
//+ (void)writeRequestLastestData:(NSMutableData *)data
//                           date:(long long)date;
//
//+ (void)writeRequestLoginLevelCheck:(NSMutableData *)data;
//+ (BOOL)getLoginLevelCheck:(NSMutableData *)data;
//
//+ (void)writeRequestGroupData:(NSMutableData *)data
//                         date:(long long)date;
//
//+ (void)writeRequestChangeTimeScale:(NSMutableData *)data
//                        timeScaleNo:(int)timeScaleNo
//                          containSu:(BOOL)suContainFlag;
//
//+ (void)writeRequestValidTerm:(NSMutableData *)data
//                  requestType:(int)requestType;
//
//+ (NSMutableArray *)getTrendValidTerm:(NSMutableData *)data;
//
//+ (void)writeRequestTrendGroupWithSignal:(NSMutableData *)data
//                                 groupNo:(int)groupNo
//                           dataPointerID:(NSString *)dpid;
//
//
//// CONTROL FUNCTION
//+ (void)writeFpRequestDispInfoObject:(NSMutableData *)data
//                                para:(NSMutableArray *)para; // array of NSString
//
//+ (void)writeFpRequestDataPointerObject:(NSMutableData *)data
//                                  dpkey:(NSMutableArray *)dpkey; // array of NSString
//
//
//+ (void)writeFpRequestTagInfoObject:(NSMutableData *)data
//                                key:(NSString *)key
//                               flag:(BOOL)flag
//                              value:(short)value;
//
//// Control
////+ (void)writeFpRequestAoOutputObject:(NSMutableData *)data
////                                 key:(NSString *)key
////                               value:(double)value;
//
//+ (void)writeFpRequestDoOutputObject:(NSMutableData *)data
//                                 key:(NSString *)key
//                               value:(BOOL)value;
//
//+ (void)writeFpRequestSuResetObject:(NSMutableData *)data
//                              dpKey:(NSString *)dpKey;
//
////+ (void)writeFpRequestSvsSwitchObject:(NSMutableData *)data
////                                svsNo:(int)svsNo
////                     svsRealStationNo:(NSMutableArray *)svsRealStationNo; // array of int
//
//+ (NSMutableArray *)getFpDataPointerList:(NSMutableData *)data;
//
//+ (NSMutableArray *)getFpSuDataPointerList:(NSMutableData *)data;
//
//+ (void)writeRequestAddLog:(NSMutableData *)data
//                  funcName:(NSString *)funcName
//                screenName:(NSString *)screenName
//                   content:(NSString *)content;

@end
