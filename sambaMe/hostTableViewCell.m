//
//  HostTableViewCell.m
//  assessDamage
//
//  Created by Shao.Admin on 16/6/14.
//  Copyright © 2016年 洪伟. All rights reserved.
//

#import "HostTableViewCell.h"
#import "CommonTool.h"
#import "DataBase.h"
#import "Common.h"

@interface HostTableViewCell()

@property (strong, nonatomic) UIView           *headPointView;

@end



@implementation HostTableViewCell {
    // 次label
    UILabel          *_secondTextLabel;
    // 状态
    UILabel          *_stateDescLabel;
    // 在线/离线
    UILabel          *_typeDescLabel;
    // 照片
    UIImageView      *_photoImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.height = height;
        
        // 小点
        self.headPointView = [[UIView alloc] init];
        [self.contentView addSubview:self.headPointView];
        [self.headPointView setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        self.headPointView.layer.cornerRadius = 5; // 圆形
        self.headPointView.backgroundColor = [CommonTool stableGreenColor];
        // 距左4
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:4]];
        // Y轴中间
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView  attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        // 宽度
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:10]];
        // 高度
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:10]];
//        headPoint = NO;

        
        // 图片
        _photoImage = [[UIImageView alloc] init];
        _photoImage.layer.cornerRadius = 8.0f; // 圆角
        _photoImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_photoImage];
        [_photoImage setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        // 距左
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.headPointView attribute:NSLayoutAttributeRight multiplier:1 constant:4]];
        // Y轴中间
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        // 宽度
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.height*0.8]];
        // 高度
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.height*0.8]];
        
        
        // main label
        self.mainTextLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.mainTextLabel];
        [self.mainTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
//        [self.mainTextLabel setNumberOfLines:2];
        _secondTextLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.mainTextLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_photoImage attribute:NSLayoutAttributeRight multiplier:1 constant:8]];
        // Y轴
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mainTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:0.7 constant:0]];
        // 高度
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mainTextLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.height/2]];
  
        

        // second label
        _secondTextLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_secondTextLabel];
        [_secondTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        _secondTextLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_photoImage attribute:NSLayoutAttributeRight multiplier:1 constant:8]];
        // Y轴
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.4 constant:0]];
        // 高度
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.height/2]];
        
        
        // state label
        _stateDescLabel = [[UILabel alloc] init];

        // 为了不和autosizing冲突，我们设置No
        [_stateDescLabel setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        [self.contentView addSubview:_stateDescLabel];
        // 字体大小
        _stateDescLabel.font = [UIFont systemFontOfSize:12];
        // 文字靠右
        _stateDescLabel.textAlignment = NSTextAlignmentRight;
        // 圆角
        _stateDescLabel.layer.cornerRadius = 5.0f;
        _stateDescLabel.layer.masksToBounds = YES;
//        _stateDescLabel.backgroundColor = [CommonTool skyBlueColor];
        // 边框
//        _stateDescLabel.layer.borderColor = [[CommonTool skyBlueColor] CGColor];
        _stateDescLabel.layer.borderWidth = 0;
        
        // x轴约束
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stateDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        
        // y轴
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stateDescLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_secondTextLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        // x轴约束
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_stateDescLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
        
        // type label(主要是在线/离线)
        _typeDescLabel = [[UILabel alloc] init];
        
        // 为了不和autosizing冲突，我们设置No
        [_typeDescLabel setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        [self.contentView addSubview:_typeDescLabel];
        // 字体大小
        _typeDescLabel.font = [UIFont systemFontOfSize:12];
        // 文字靠右
        _typeDescLabel.textAlignment = NSTextAlignmentRight;
        // 圆角
        _typeDescLabel.layer.cornerRadius = 5.0f;
        _typeDescLabel.layer.masksToBounds = YES;
        // 边框
        _stateDescLabel.layer.borderWidth = 0;
        
        // x轴约束
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        
        // y轴
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeDescLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mainTextLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        // x轴约束
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.mainTextLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_typeDescLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];

    }
    return self;
}

- (void)setSecondLabelWithText:(NSString*)text
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, text.length)];
    _secondTextLabel.attributedText = str;
}

- (void)setState:(BOOL)state withDesc:(NSString*)desc
{
    UIColor* color = nil;
    if(state)
    {
        color = [CommonTool stableGreenColor];
    }
    else
    {
        color = [UIColor redColor];
    }
    
    self.headPointView.backgroundColor = color;
    _stateDescLabel.backgroundColor = color;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:desc];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, desc.length)];
    _stateDescLabel.attributedText = str;
}

- (void)setPhotoWithImage:(UIImage*)image
{
    [_photoImage setImage:image];
}

- (void)setDescLabelWithText:(NSString*)text withBackGroubdColor:(UIColor*)color {
    
    if(nil != text)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
        _typeDescLabel.attributedText = str;
    }

    if(nil != color)
    {
        _typeDescLabel.backgroundColor = color;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
