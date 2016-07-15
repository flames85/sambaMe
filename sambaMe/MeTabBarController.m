//
//  MeTabBarController.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/12.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "MeTabBarController.h"
#import "MeHostListVC.h"
#import "Database.h"
#import "MeCachedFileListVC.h"


@implementation MeTabBarController


-(id)init {
    self = [super init];
    if ( self ) {
        // 第1个tab
        self.hostVC = [[MeHostListVC alloc] init];
        [self.hostVC setTitle:@"服务器"];
        self.hostVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"服务器" image:[UIImage imageNamed:@"tabBar_list"] selectedImage:[UIImage imageNamed:@"tabBar_list"]];
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.hostVC];
        [self addChildViewController:nav1];
        
        // 第2个tab
        self.cachedVC = [[MeCachedFileListVC alloc] init];
        [self.cachedVC setTitle:@"已下载"];
        self.cachedVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"已下载" image:[UIImage imageNamed:@"tabBar_list"] selectedImage:[UIImage imageNamed:@"tabBar_list"]];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.cachedVC];
        [self addChildViewController:nav2];
    }
    return self;
}

@end
