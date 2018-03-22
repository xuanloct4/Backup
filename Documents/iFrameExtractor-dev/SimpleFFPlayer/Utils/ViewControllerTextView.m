//
//  ViewControllerTextView.m
//  CloudStorage
//
//  Created by tranvanloc on 2/23/17.
//  Copyright © 2017 toshiba. All rights reserved.
//

#import "ViewControllerTextView.h"

@interface ViewControllerTextView ()

@end

@implementation ViewControllerTextView

- (void)viewDidLoad {
    [super viewDidLoad];
    _tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKey)];
    _tapp.enabled = NO;
    [self.view addGestureRecognizer:_tapp];
}

- (void)hideKey {
    for (UIView *v in self.view.subviews){
        [self resignSubViewsResponder:v];
    }
    _tapp.enabled = NO;
}

- (void) resignSubViewsResponder:(UIView *)parentView {
    if ([parentView isKindOfClass:[UITextView class]] || [parentView isKindOfClass:[UITextField class]]) {
        [parentView resignFirstResponder];
    }
    for (UIView *v in parentView.subviews){
        [self resignSubViewsResponder:v];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - TextViewDelegate, TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _tapp.enabled = YES;
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _tapp.enabled = YES;
    return YES;
}

@end
