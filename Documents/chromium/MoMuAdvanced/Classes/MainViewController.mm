//
//  MainViewController.m
//  MoMuAdvanced
//
//  Created by Jorge Herrera on 6/10/10.
//  Copyright Stanford 2010. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController


- (IBAction)changedMode {
	
	bool showFreq = [freqSwitch isOn];
    
	NSArray *keys = [NSArray arrayWithObject:@"mode"];
	NSArray *objects;
	
	if(showFreq)
		objects = [NSArray arrayWithObject:@"frequency"];
	else
		objects = [NSArray arrayWithObject:@"time"];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	// Set the display mode
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateDisplay" object:self userInfo:dictionary];
    
 	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    // Start the OpenGL ES rendering
    [glView startAnimation];

}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
