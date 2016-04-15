//
//  UIView+JKExtension.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "UIView+JKExtension.h"

@implementation UIView (JKExtension)


-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
    
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(CGFloat)centerY
{
    return self.center.y;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}
-(CGSize)size
{
    return self.frame.size;
}

-(BOOL)isShowOnKeywindow
{
    //自身是一个view，来判断是不是在窗口里
    
    CGRect newFrame = [self.superview convertRect:self.frame toView:nil];
    CGRect windowFrame = [UIApplication sharedApplication].keyWindow.bounds;
    
    
    //必须要在窗口上  不能隐藏  有透明度 坐标系相同
   return  self.window == [UIApplication sharedApplication].keyWindow &&!self.isHidden && self.alpha >0.01 &&CGRectIntersectsRect(newFrame, windowFrame);
}

@end
