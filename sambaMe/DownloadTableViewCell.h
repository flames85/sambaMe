//
//  DownloadTableViewCell
//  assessDamage
//
//  Created by Shao.Admin on 16/6/14.
//  Copyright © 2016年 洪伟. All rights reserved.
//
//
// 自定义案件cell

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, DownloadState) {
    //以下是枚举成员
    STATE_DOWNLOADING = 0,
    STATE_DOWNLOADED = 1,
    STATE_STOPED = 2
};

@interface DownloadTableViewCell : UITableViewCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;

// 次label
- (void)setSecondLabelWithText:(NSString*)text;
// 状态
- (void)setIsFile:(BOOL)isFile withDesc:(NSString*)desc;
// 照片
- (void)setPhotoWithImage:(UIImage*)image;

// 字节数
<<<<<<< HEAD
- (void)setSizeWithCurrentSize:(int64_t)currentSize withTotalSize:(int64_t)totalSize;

- (void)clearMark;
=======
-(void)setSizeWithCurrentSize:(int64_t)currentSize withTotalSize:(int64_t)totalSize;

-(void)clearMark;
>>>>>>> adf413bcc08e08eae2e0e9250117354e8a3cce4b
// 蓝色标记
- (void)setBlueMark;
// 红色标记
- (void)setRedMark;

// 主要label
@property (retain, nonatomic) UILabel          *mainTextLabel;

@property (assign, nonatomic) CGFloat          height;

@property (assign, nonatomic) DownloadState    downloadState;

@end
