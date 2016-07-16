//
//  CachedFileTableViewCell
//  assessDamage
//
//  Created by Shao.Admin on 16/6/14.
//  Copyright © 2016年 洪伟. All rights reserved.
//

#import "CachedFileTableViewCell.h"
#import "CommonTool.h"
#import "DataBase.h"
#import "Common.h"
#import "UAProgressView.h"

@interface CachedFileTableViewCell()

@property (strong, nonatomic) UIView           *headPointView;
@property (nonatomic, strong) UAProgressView     *progressView;

@property (nonatomic, assign) CGFloat           localProgress;
@property (nonatomic, strong) UILabel           *progressLabel;
@end



@implementation CachedFileTableViewCell {
    // 次label
    UILabel          *_secondTextLabel;
    // 状态
    UILabel          *_stateDescLabel;
    // 在线/离线
    UILabel          *_typeDescLabel;
    // 照片
    UIImageView      *_photoImage;
    // 按钮
    UIButton         *_operateBtn;
    

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.height = height;
        // 小点
        self.headPointView = [[UIView alloc] init];
        [self.contentView addSubview:self.headPointView];
        [self.headPointView setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        self.headPointView.layer.cornerRadius = 5; // 圆形
        self.headPointView.backgroundColor = [CommonTool skyBlueColor];
        // 距左4
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:4]];
        // Y轴中间
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView  attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        // 宽度
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:10]];
        // 高度
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.headPointView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:10]];
//        headPoint = NO;
        self.headPointView.hidden = YES;
        
        
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
        
        
        // 主 label
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
  
  
        // 次级描述
        _secondTextLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_secondTextLabel];
        [_secondTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        _secondTextLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_photoImage attribute:NSLayoutAttributeRight multiplier:1 constant:8]];
        // Y轴
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.4 constant:0]];
        // 高度
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.height/2]];
        
        // 字节数
        _stateDescLabel = [[UILabel alloc] init];
        [_stateDescLabel setTranslatesAutoresizingMaskIntoConstraints:NO]; // Autolayout
        [self.contentView addSubview:_stateDescLabel];
        // 字体大小
        _stateDescLabel.font = [UIFont systemFontOfSize:12];
        // 文字靠右
        _stateDescLabel.textAlignment = NSTextAlignmentRight;
        // 圆角
        _stateDescLabel.layer.cornerRadius = 5.0f;
        _stateDescLabel.layer.masksToBounds = YES;
        _stateDescLabel.layer.borderWidth = 0;
        
        // x轴约束
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stateDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-45]];
        
        // y轴
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stateDescLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_secondTextLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        // x轴约束
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondTextLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_stateDescLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
    
        
        // 文件还是目录
        _typeDescLabel = [[UILabel alloc] init];
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
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-45]];
        
        // y轴
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_typeDescLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mainTextLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        // x轴约束
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.mainTextLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_typeDescLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
        
        
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
        
        [self setupProgressView];

    }
    return self;
}

- (void)clearMark {
    self.headPointView.hidden = YES;
}

- (void)setBlueMark {
    self.headPointView.hidden = NO;
    self.headPointView.backgroundColor = [CommonTool skyBlueColor];
}

- (void)setRedMark {
    self.headPointView.hidden = NO;
    self.headPointView.backgroundColor = [UIColor redColor];
}

- (void)setSecondLabelWithText:(NSString*)text
{
    if (nil != text) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, text.length)];
        _secondTextLabel.attributedText = str;
    } else {
        _secondTextLabel.attributedText = nil;
    }
}

- (void)setIsFile:(BOOL)isFile withDesc:(NSString*)desc {
    UIColor* color = nil;
    if(isFile)
    {
        color = [CommonTool grassGreenColor];
    }
    else
    {
        color = [CommonTool goldenColor];
    }
    
    
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

- (BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)setupProgressView {
    // 圆圈
    self.progressView = [[UAProgressView alloc] init];
    self.progressView.borderWidth = 2.0;
    self.progressView.lineWidth = 2.0;
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.progressView];
    self.progressView.tintColor = [UIColor purpleColor];
    
    // 进度条被更新
    __weak typeof (self) weakSelf = self;
    self.progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
        [weakSelf.progressLabel setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
        if (1.0f == progress) {
            [weakSelf.progressLabel setText:@"OK"];
        }
    };
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:0.45f constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:36]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    
    // 进度数值
    _progressLabel = [[UILabel alloc] init];
    [_progressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _progressLabel.font = [UIFont systemFontOfSize:12];
    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_progressLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_progressLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_progressLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.progressView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

// 进度更新
- (void)updateProgress:(NSTimer *)timer {
//    _localProgress = ((int)((_localProgress * 100.0f) + 1.01) % 100) / 100.0f;
    _localProgress += 0.01f;
    [self.progressView setProgress:_localProgress];
    if (1.0f == _localProgress) {
        [timer invalidate];
    }
}

@end
