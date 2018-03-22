//
//  GCDDisPatchGroup.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/11/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDDisPatchGroup : NSObject
@property NSURLResponse *response;
@property NSError* error;

-(void)fetchConfigurationWithCompletion:(void (^)(NSError* error))completion;
@end
