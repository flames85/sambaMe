//
//  HostTableViewCell.h
//  assessDamage
//
//  Created by Shao.Admin on 16/6/14.
//  Copyright © 2016年 洪伟. All rights reserved.
//
//
// 自定义案件cell

#import <UIKit/UIKit.h>

@interface HostTableViewCell : UITableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;

// 次label
- (void)setSecondLabelWithText:(NSString*)text;
// 状态
- (void)setState:(BOOL)state withDesc:(NSString*)desc;
// 照片
- (void)setPhotoWithImage:(UIImage*)image;

// 右上角描述
- (void)setDescLabelWithText:(NSString*)text withBackGroubdColor:(UIColor*)color;

// 主要label
@property (retain, nonatomic) UILabel          *mainTextLabel;

@property (assign, nonatomic) CGFloat          height;

@end
