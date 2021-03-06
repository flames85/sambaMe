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
#import "MeDownloadFileVC.h"
#import "MeFavoriteVC.h"
#import "CommonTool.h"

@implementation MeTabBarController



static MeTabBarController *g_instance = nil;

+(MeTabBarController*)sharedTabBar
{
    if(g_instance == nil)
    {
        g_instance = [[MeTabBarController alloc] init];
    }
    return g_instance;
}


-(id)init {
    self = [super init];
    if ( self ) {
        // 第1个tab
        self.hostVC = [[MeHostListVC alloc] init];
        [self.hostVC setTitle:@"服务器"];
        UIImage *image = [UIImage imageNamed:@"tabBar_host"];
        self.hostVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"服务器" image:image selectedImage:image];
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.hostVC];
        [self addChildViewController:nav1];
        
        // 第2个tab
        self.downloadVC = [[MeDownloadFileVC alloc] init];
        [self.downloadVC setTitle:@"下载"];
        image = [UIImage imageNamed:@"tabBar_download"];
        self.downloadVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"下载" image:image selectedImage:image];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.downloadVC];
        [self addChildViewController:nav2];
        
        // 第3个tab
        self.favoriteVC = [[MeFavoriteVC alloc] init];
        [self.favoriteVC setTitle:@"收藏"];
        image = [UIImage imageNamed:@"tabBar_favorite"];
        self.favoriteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"收藏" image:image selectedImage:image];
        UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:self.favoriteVC];
        [self addChildViewController:nav3];
    }
    return self;
}

@end
