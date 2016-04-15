//
//  JKTopWindow.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/6.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTopWindow.h"

@implementation JKTopWindow

static UIWindow *window1_;
+(void)show
{
  window1_.hidden = NO;
}

//保证这个方法只调用一次
+(void)initialize
{
    window1_ = [[UIWindow alloc]init];
    window1_.frame = CGRectMake(0, 0, JKScreenW, 20);
    
    window1_.backgroundColor = [UIColor redColor];
    window1_.windowLevel = UIWindowLevelStatusBar;
    window1_.rootViewController = [[UIViewController alloc]init];
    [window1_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(windowClick)]];
}

+(void)windowClick
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
   // NSLog(@"keyWindow%f \n\n自己的window%f",keyWindow.windowLevel,window1_.windowLevel);
    [self searchScrollViewInView:keyWindow];
}

+(void)searchScrollViewInView:(UIView *)superView
{
    
    
    
    for (UIScrollView *subview in superView.subviews) {
        
      CGRect newFrame = [subview.superview convertRect:subview.frame toView:nil];
        CGRect windowFrame = [UIApplication sharedApplication].keyWindow.bounds;
        
        
        //必须要在窗口上  不能隐藏  有透明度 坐标系相同
        BOOL isShowingOnWindow = subview.window == [UIApplication sharedApplication].keyWindow &&!subview.isHidden && subview.alpha >0.01 &&CGRectIntersectsRect(newFrame, windowFrame);
        
        
        if ([subview isKindOfClass:[UIScrollView class]] && isShowingOnWindow) {
           CGPoint offset = subview.contentOffset;
            offset.y = -subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        //递归的方法一层一层往下寻找，去设置
        [self searchScrollViewInView:subview];
    }
}

@end
