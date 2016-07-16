//
//  CommonTool.h
//  sambaMe
//
//  Created by Shao.Admin on 16/7/14.
//  Copyright © 2016年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonTool : NSObject


// 使用颜色创建UIImage
+ (UIImage*)getImageWithColor:(UIColor*)color withSize:(CGSize)size;

//图片缩放到指定大小尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;



+(UIColor*)stableGreenColor;
+(UIColor*)grassGreenColor;
+(UIColor*)skyBlueColor;
+(UIColor*)goldenColor;

// 永久闪烁动画
+(CABasicAnimation *)opacityForever_Animation:(float)time;


@end
