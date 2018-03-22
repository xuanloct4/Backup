//
//  CustomTableViewCell.h
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/3/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) IBOutlet UIButton *dButton;
@end
