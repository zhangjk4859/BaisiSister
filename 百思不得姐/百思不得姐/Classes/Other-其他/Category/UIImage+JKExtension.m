//
//  UIImage+JKExtension.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/6.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "UIImage+JKExtension.h"

@implementation UIImage (JKExtension)
-(UIImage *)circleImage
{
    //开启图形上下文 NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    //裁剪
    CGContextClip(ctx);
    //将图片画上去     将自己画上去，变成圆，再拿出来，返回去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}





@end
