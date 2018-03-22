//
//  MainViewController.h
//  MoMuAdvanced
//
//  Created by Jorge Herrera on 6/10/10.
//  Copyright Stanford 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EAGLView.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet EAGLView * glView;
    IBOutlet UISwitch * freqSwitch;
}

@property (nonatomic, retain) IBOutlet EAGLView * glView;
@property (nonatomic, retain) IBOutlet UISwitch * freqSwitch;

- (IBAction)showInfo;
- (IBAction)changedMode;

@end
