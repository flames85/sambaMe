//
//  MeHomeVC.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/12.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "MeHomeVC.h"
#import "MeTabBarController.h"

@implementation MeHomeVC {
    // 唯一的tabbar
    MeTabBarController    *_tabBarCtl;
}

-(void)viewDidLoad
{
    _tabBarCtl = [[MeTabBarController alloc] init];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [self presentViewController:_tabBarCtl animated:YES completion:nil];
}

@end
