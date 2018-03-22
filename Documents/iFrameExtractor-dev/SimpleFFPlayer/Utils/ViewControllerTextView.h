//
//  ViewControllerTextView.h
//  CloudStorage
//
//  Created by tranvanloc on 2/23/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerTextView : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *tapp;
@end
