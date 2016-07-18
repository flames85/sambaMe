//
//  DownloadTableViewCell
//  assessDamage
//
//  Created by Shao.Admin on 16/6/14.
//  Copyright © 2016年 洪伟. All rights reserved.
//

#import "downloadTableViewCell.h"
#import "CommonTool.h"
//#import "DataBase.h"
#import "Common.h"
#import "UAProgressView.h"
#import "PlayView.h"

@interface DownloadTableViewCell()

@property (strong, nonatomic) UIView           *headPointView;
@property (nonatomic, strong) UAProgressView    *progressView;

@property (nonatomic, strong) UIView            *stopDownloadView;
@property (nonatomic, strong) UIImageView       *downloadedImageView;
@end



@implementation DownloadTableViewCell {
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
        self.selectionStyle = UITableViewCellSelectionStyleGray;
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
        
        // process view
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

-(void)setSizeWithCurrentSize:(int64_t)currentSize withTotalSize:(int64_t)totalSize {
    
    NSString *text = [NSString stringWithFormat:@"%@/%@", @(currentSize), @(totalSize)];
    
    // 显示文字
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
    _typeDescLabel.attributedText = str;
    
    // 底色
    _typeDescLabel.backgroundColor = [CommonTool skyBlueColor];
    
    // 进度
    CGFloat progress = (CGFloat)currentSize / (CGFloat)totalSize;
    
    [self.progressView setProgress:progress];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)setupProgressView {
    // 圆圈进度条
    self.progressView = [[UAProgressView alloc] init];
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.progressView];
    self.progressView.tintColor = [CommonTool skyBlueColor];
    self.progressView.progress = 0.0f;
    
    // 进度条被更新
    __weak typeof (self) weakSelf = self;
    self.progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
        if (progress >= 1.0f) {
            [weakSelf setDownloadState:STATE_DOWNLOADED];
        }
    };
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:self.height*0.25f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.height*0.5f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    
    // 外圈
    UAProgressView *borderView = [[UAProgressView alloc] init];
    borderView.borderWidth = 1.0;
    borderView.lineWidth = 2.0;
    [borderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:borderView];
    borderView.tintColor = [CommonTool skyBlueColor];
    borderView.progress = 1.0f;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:self.height*0.25f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.height*0.5f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    
    
    // 停止view
    self.stopDownloadView = [[UIView alloc] init];
    self.stopDownloadView.backgroundColor = [UIColor redColor];
    [self.stopDownloadView  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.stopDownloadView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stopDownloadView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stopDownloadView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.progressView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stopDownloadView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.height*0.2f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stopDownloadView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.height*0.2f]];
    
    // 下载完成view
    self.downloadedImageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"downloaded_flag"];
    [self.downloadedImageView setImage:image];
    [self.downloadedImageView  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.downloadedImageView];
    [self.downloadedImageView setHidden:YES];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.downloadedImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.downloadedImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.progressView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.downloadedImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.height*0.2f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.downloadedImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.height*0.2f]];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    // 获取原始颜色
    UIColor *typeDescLabelBackgroundColor = _typeDescLabel.backgroundColor;
    UIColor *stateDescLabelBackgroundColor = _stateDescLabel.backgroundColor;
    UIColor *stopDownloadViewBackgroundColor = self.stopDownloadView.backgroundColor;
    
    // 高亮动画
    [super setHighlighted:highlighted animated:animated];
    
    
    // 设置颜色(目的是不让其变色)
    _typeDescLabel.backgroundColor = typeDescLabelBackgroundColor;
    _stateDescLabel.backgroundColor = stateDescLabelBackgroundColor;
    self.stopDownloadView.backgroundColor = stopDownloadViewBackgroundColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // 获取原始颜色
    UIColor *typeDescLabelBackgroundColor = _typeDescLabel.backgroundColor;
    UIColor *stateDescLabelBackgroundColor = _stateDescLabel.backgroundColor;
    UIColor *stopDownloadViewBackgroundColor = self.stopDownloadView.backgroundColor;
    // 选中动画
    [super setSelected:selected animated:animated];
    
    // 设置颜色(目的是不让其变色)
    _typeDescLabel.backgroundColor = typeDescLabelBackgroundColor;
    _stateDescLabel.backgroundColor = stateDescLabelBackgroundColor;
    self.stopDownloadView.backgroundColor = stopDownloadViewBackgroundColor;
}

- (void)setDownloadState:(DownloadState)state {
    
    switch (state) {
        case STATE_DOWNLOADING:
            self.progressView.borderWidth = 2.0;
            self.progressView.lineWidth = 4.0;
            self.progressView.tintColor = [CommonTool skyBlueColor];
            NSLog(@"下载中");
            break;
        case STATE_DOWNLOADED:
            self.progressView.borderWidth = 2.0;
            self.progressView.lineWidth = 8.0;
            [self.stopDownloadView setHidden:YES];
            [self.downloadedImageView setHidden:NO];
            break;
        case STATE_STOPED:
            self.progressView.borderWidth = 2.0;
            self.progressView.lineWidth = 4.0;
            self.progressView.tintColor = [UIColor redColor];
            NSLog(@"停止了下载");
            break;
        default:
            break;
    }
}

@end
