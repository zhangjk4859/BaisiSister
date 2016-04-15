//
//  JKTabBar.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTabBar.h"
#import "JKPublishView.h"
#import "JKPublishWordViewController.h"
#import "JKNavigationController.h"


@interface JKTabBar ()

@property(nonatomic,strong)UIButton *publishButton;

@end

@implementation JKTabBar

//初始化形状的时候赶紧加一个按钮和设置背景图
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置tabbar的背景图
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        //添加中间的按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        //放在这里的原因是图片已经有现成的尺寸了
        publishButton.size = publishButton.currentBackgroundImage.size;
        [publishButton addTarget:self action:@selector(showPublishView) forControlEvents:UIControlEventTouchUpInside];
        
        self.publishButton = publishButton;
        [self addSubview:publishButton];
       
    }
    
    return self;
    
}



-(void)showPublishView
{
    [JKPublishView show];
//    JKPublishWordViewController * pubVC = [[JKPublishWordViewController alloc]init];
//    //用导航栏包装起来
//    JKNavigationController *nav = [[JKNavigationController alloc]initWithRootViewController:pubVC];
//    //推出来
//    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    [rootVC presentViewController:nav animated:YES completion:nil];

    

}

//布局子控件在这里
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    
    //设置发布按钮的frame

    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    //设置其他UIBarbuttonItem的frame
   
    CGFloat buttonY = 0;
    CGFloat buttonW = width/5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    
    for (UIView *button in self.subviews) {
        
        //如果不是UITabBarButton 就跳过不设置，只设置四个系统按钮
        //if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        //如果不属于控制类就跳过 或者 等于 中间圆形按钮
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index ++;
         
    }
}

@end
