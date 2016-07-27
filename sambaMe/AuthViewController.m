//
//  AuthViewController.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/26.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController()<UITextFieldDelegate>

@end


@implementation AuthViewController


-(void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.authTextField = [[UITextField alloc] init];
    self.authTextField.backgroundColor = [UIColor whiteColor];
    
    [self.authTextField setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
    self.authTextField.secureTextEntry = YES;
    
    [self.view addSubview:self.authTextField];
    
    // X轴中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.authTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    // Y轴
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.authTextField  attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.6 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.authTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.4f constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.authTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30]];
    
    self.authTextField.delegate = self;
}


#pragma mark - delegate UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@"1030"]) {
        [self.delegate authSuccess];
        [self dismissViewControllerAnimated:NO completion:nil];
        return YES;
    }
    return NO;
}

@end
