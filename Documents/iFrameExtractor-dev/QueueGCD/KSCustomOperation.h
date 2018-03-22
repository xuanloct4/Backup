//
//  KSCustomOperation.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/4/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCustomOperation : NSOperation
{
    BOOL executing;
    BOOL finished;
}

@property  (strong) NSDictionary *mainDataDictionary;
-(id)initWithData:(id)dataDictionary;
@end
