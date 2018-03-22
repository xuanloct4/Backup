//
//  FetchController.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/21/17.
//  Copyright © 2017 jefby. All rights reserved.
//

#import "FetchController.h"
#import "AppDelegate.h"
#import "Entity.h"

@implementation FetchController
//@synthesize fetchedResultsController, managedObjectContext;

+ (AppDelegate *)getAppDelegate{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}

+(void)insertData{
     NSManagedObjectContext * context = [[FetchController getAppDelegate] managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
           inManagedObjectContext:context];
    [object setValue:@"a" forKey:@"name"];
    [object setValue:[NSNumber numberWithInt:0] forKey:@"id"];
     [object setValue:@"hanoi" forKey:@"address"];
         [object setValue:[[NSData alloc] init] forKey:@"data"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

+(void)insetPlusUpdate:(NSDictionary *)data {
    
    NSManagedObjectContext * context;
    
    if (![[NSThread currentThread] isMainThread]) {
        
        context = [[NSManagedObjectContext alloc] init];
        
        [context setPersistentStoreCoordinator:[[FetchController getAppDelegate] persistentStoreCoordinator]];
    } else {
        
        context = [[FetchController getAppDelegate] managedObjectContext];
    }
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSPredicate * check = [NSPredicate predicateWithFormat:@"name == %@", @"a"];
    
    [request setPredicate:check];
    
    NSError * error = nil;
    
    if ([context countForFetchRequest:request error:&error] == 0) {
        //        Entity.attribute = @"";
        
    } else {
        NSArray * array = [context executeFetchRequest:request error:&error];
        Entity * entity = [array firstObject];
        entity.address = @"";
    }
}

+(NSString *)fetch:(NSString *)feed_id
                  :(NSString *)value{
    NSManagedObjectContext * context;
    if(![[NSThread currentThread] isMainThread]){
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[[FetchController getAppDelegate] persistentStoreCoordinator]];
    } else {
        context = [[FetchController getAppDelegate] managedObjectContext];
    }
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context];
    [request setEntity:entity];
    
//    NSPredicate * check = [NSPredicate predicateWithFormat:@"%@ == %@", feed_id, value];
//    [request setPredicate:check];
    
    NSError * error = nil;
    if ([context countForFetchRequest:request error:&error] > 0) {
        
        NSArray * array = [context executeFetchRequest:request error:&error];
        Entity * fetchData = [array firstObject];
        NSString * string = fetchData.name;
        return string;
    }
    
    return nil;
}

+(BOOL)deleteAll{
    
    NSManagedObjectContext * context;
    
    if (![[NSThread currentThread] isMainThread]) {
        
        context = [[NSManagedObjectContext alloc] init];
        
        [context setPersistentStoreCoordinator:[[FetchController getAppDelegate] persistentStoreCoordinator]];
        
    } else {
        context = [[FetchController getAppDelegate] managedObjectContext];
    }
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest: request];
    
    @try{
        [context executeRequest:deleteRequest error:&error];
        if([context save:&error]){
            NSLog(@"Deleted");
            return [context save:&error];
        }
        else{
            return [context save:&error];
        }
    }
    @catch(NSException *exception){
        NSLog(@"failed %@",exception);
        return [context save:&error];
    }    
}

+(void)delete:(NSDictionary *)info {
    NSManagedObjectContext *moc2 = [[FetchController getAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:moc2];
    fetch.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"a"];
   
      NSError * error = nil;
    NSArray *array = [moc2 executeFetchRequest:fetch error:&error];

    for (NSManagedObject *managedObject in array) {
        [moc2 deleteObject:managedObject];
    }
}
@end
