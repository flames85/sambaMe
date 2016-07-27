//
//  MeDownloadFileVC.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownloadingItem;
@class DownloadFileItem;

@protocol MeDownloadFileVCDelegate <NSObject>

-(void)updateCurrentSizeWithKey:(NSString*)key withCurrentSize:(int64_t)currentSize ;

@end


@interface MeDownloadFileVC : UIViewController

-(id) init;

-(void) addDownloadFileItem:(DownloadFileItem *)item;

@property (nonatomic, weak) id<MeDownloadFileVCDelegate> delegate;


@end
