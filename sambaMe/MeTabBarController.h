//
//  MeTabBarController.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/12.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeHostListVC;
@class MeCachedFileVC;
@class MeFavoriteVC;

@interface MeTabBarController : UITabBarController 

-(id)init;

@property(nonatomic, strong) MeHostListVC                *hostVC;
@property(nonatomic, strong) MeCachedFileVC              *cachedVC;
@property(nonatomic, strong) MeFavoriteVC                *favoriteVC;
@end;

