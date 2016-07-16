//
//  FileTableViewCell
//  assessDamage
//
//  Created by Shao.Admin on 16/6/14.
//  Copyright © 2016年 洪伟. All rights reserved.
//
//
// 自定义案件cell

#import <UIKit/UIKit.h>

@interface FileTableViewCell : UITableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;

// 次label
- (void)setSecondLabelWithText:(NSString*)text;
// 状态
- (void)setIsFile:(BOOL)isFile withDesc:(NSString*)desc;
// 照片
- (void)setPhotoWithImage:(UIImage*)image;
// 右上角描述
- (void)setDescLabelWithText:(NSString*)text withBackGroubdColor:(UIColor*)color;

-(void)clearMark;
// 蓝色标记
- (void)setBlueMark;
// 红色标记
- (void)setRedMark;

// 主要label
@property (retain, nonatomic) UILabel          *mainTextLabel;

@property (assign, nonatomic) CGFloat          height;

@property (copy, nonatomic) NSString           *localPath;

@end
