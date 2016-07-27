//
//  AuthViewController.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/26.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthViewControllerDelegate <NSObject>

-(void)authSuccess;

@end


@interface AuthViewController : UIViewController

@property (strong, nonatomic) UITextField   *authTextField;

@property (weak, nonatomic) id<AuthViewControllerDelegate> delegate;

@end
