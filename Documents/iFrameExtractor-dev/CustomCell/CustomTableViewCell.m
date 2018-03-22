//
//  CustomTableViewCell.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/3/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.text = @"abc";
    self.textField.text = @"xyz";
    [self.button setTitle:@"" forState:UIControlStateNormal];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(add:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(add:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)add:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self moveSubContentRight];
    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        [self moveSubContentLeft];
    }
}

-(void)setUp{
    if(!self.dButton){
        self.dButton = [[UIButton alloc] init];
        self.dButton.frame = CGRectMake(self.frame.size.width, 0, 50, self.frame.size.height);
        self.dButton.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.dButton];
    }
}

-(void)moveSubContentLeft{
    [self setUp];
    NSArray *subViews = self.contentView.subviews;
    for (UIView *v in subViews) {
        if(v == self.dButton){
            CGRect rect = v.frame;
            v.frame = CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height);
        }else{
            CGRect rect = v.frame;
            v.frame = CGRectMake(rect.origin.x - 50, rect.origin.y, rect.size.width, rect.size.height);
        }
    }
}

-(void)moveSubContentRight{
    [self setUp];
    NSArray *subViews = self.contentView.subviews;
    for (UIView *v in subViews) {
        if(v == self.dButton){
            CGRect rect = v.frame;
            v.frame = CGRectMake(self.frame.size.width, 0, 50, self.frame.size.height);
        }else{
            CGRect rect = v.frame;
            v.frame = CGRectMake(rect.origin.x + 50, rect.origin.y, rect.size.width, rect.size.height);
        }
    }
}
@end
