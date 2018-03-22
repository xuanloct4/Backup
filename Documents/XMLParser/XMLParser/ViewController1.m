//
//  ViewController1.m
//  XMLParser
//
//  Created by tranvanloc on 4/26/17.
//  Copyright © 2017 tranvanloc. All rights reserved.
//

#import "ViewController1.h"
#import "XMLParser.h"
#import "Utilities.h"
@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSURL *URL = [[NSURL alloc] initWithString:@"http:/sites.google.com/site/iphonesdktutorials/xml/Books.xml"];
//    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
//    NSLog(@"string: %@", xmlString);
//    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
//    NSLog(@"dictionary: %@", xmlDoc);
    
    NSError *err = nil;
       NSString *infoPlistString = [[NSString alloc] initWithContentsOfFile:[Utilities bundlePath:@"Info.plist"] encoding:NSASCIIStringEncoding error:&err];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:[Utilities bundlePath:@"Info.plist"]];
//  NSString *infoPlistString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"string: %@", infoPlistString);
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:infoPlistString];
    NSLog(@"dictionary: %@", xmlDoc);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
