//
//  FetchController.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/21/17.
//  Copyright © 2017 jefby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "SimpleFFPlayer-Swift.h"
@class Entity;
//@class AppDelegate;
@interface FetchController: UIViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


//+ (AppDelegate *)getAppDelegate;
+(void)insertData;
+(NSString *)fetch:(NSString *)feed_id
                  :(NSString *)value;
+(BOOL)deleteAll;
+(void)delete:(NSDictionary *)info;
@end
