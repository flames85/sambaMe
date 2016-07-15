//
//  CommonTool.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "CommonTool.h"


@implementation CommonTool

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
