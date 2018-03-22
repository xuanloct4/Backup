//
//  Entity.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/21/17.
//  Copyright © 2017 jefby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Entity : NSManagedObject
@property (nonatomic, copy) NSString * _Nullable address;
@property (nonatomic, strong) NSData * _Nullable data;
@property (nonatomic) int64_t id;
@property (nonatomic, copy) NSString * _Nullable name;
@end
