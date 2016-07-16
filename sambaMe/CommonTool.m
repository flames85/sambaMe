//
//  CommonTool.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "CommonTool.h"


@implementation CommonTool


+(UIImage*)getImageWithColor:(UIColor*)color withSize:(CGSize)size {
    
    CGSize imageSize = CGSizeMake(size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImage;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}



+(UIColor*)stableGreenColor
{
    return [UIColor colorWithRed:16.0f/255.0f green:210.0f/255.0f blue:28.0f/255.0f alpha:1];
}

+(UIColor*)grassGreenColor
{
    return [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:43.0f/255.0f alpha:1];
}
+(UIColor*)skyBlueColor
{
    return [UIColor colorWithRed:21.0f/255.0f green:160.0f/255.0f blue:245.0f/255.0f alpha:1];
}

+(UIColor*)goldenColor
{
    return [UIColor colorWithRed:255.0f/255.0f green:183.0f/255.0f blue:12.0f/255.0f alpha:1];
}


+(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    // 透明度变化区间
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.5f];
    
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}


@end
