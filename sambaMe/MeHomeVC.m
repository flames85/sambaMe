//
//  MeHomeVC.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/12.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "MeHomeVC.h"
#import "MeTabBarController.h"

#import <MobileVLCKit/MobileVLCKit.h>

#import "VDLViewController.h"
#import "AppDelegate.h"
#import "AuthViewController.h"


@interface MeHomeVC() <AuthViewControllerDelegate>

@end

@implementation MeHomeVC {
    // 唯一的tabbar
    MeTabBarController    *_tabBarCtl;
    
    AppDelegate           *_appDelegate;
    
    
    AuthViewController    *_authVC;
}

-(void)viewDidLoad
{
    self.bAuthSuccess = NO;
    
    _appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _appDelegate.homeVC = self;
    
    _tabBarCtl = [MeTabBarController sharedTabBar];
    
    _authVC = [[AuthViewController alloc] init];
    _authVC.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"appear");
    if (self.bAuthSuccess) {
        [self presentViewController:_tabBarCtl animated:NO completion:nil];
    } else {
        [self presentViewController:_authVC animated:NO completion:nil];
    }
}

-(void)authSuccess {
    self.bAuthSuccess = YES;
}

@end
