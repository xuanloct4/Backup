//
//  ViewController.m
//  KairosSDKExample
//
//  Created by Eric Turner on 3/13/14.
//  Copyright (c) 2014 Kairos. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedStartButton:(id)sender
{
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myAppDelegate kairosSDKStartMethod];

}

@end
