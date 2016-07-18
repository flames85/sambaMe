//
//  PlayView.m
//  sambaMe
//
//  Created by Shao.Admin on 16/7/17.
//  Copyright © 2016年 sq. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

-(void)drawRect:(CGRect)rect
{
    //设置背景颜色
    [[UIColor clearColor] set];
    
    UIRectFill([self bounds]);
    //拿到当前视图准备好的画板
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context, 0, 0);//设置起点
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [[UIColor redColor] setFill]; //设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
}

@end
