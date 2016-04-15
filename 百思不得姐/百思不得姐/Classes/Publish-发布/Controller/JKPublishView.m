//
//  JKPublishView.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/31.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKPublishView.h"
#import "JKVerticalButton.h"
#import <POP.h>
#import "JKPublishWordViewController.h"
#import "JKNavigationController.h"
#import "JKLoginTool.h"
#define JKRootView [UIApplication sharedApplication].keyWindow.rootViewController.view


@interface JKPublishView ()

@property(nonatomic,weak)UIImageView *sloganView;
/**
 *  测试block属性写法
 */
@property(nonatomic,copy)void(^completionBlock)();//block当属性

/**
 *  <#注释#>
 */
@property(nonatomic,assign)int age;


@end


@implementation JKPublishView

static UIWindow * window_;

+(void)show
{
    //新建一个窗口
    window_ = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    window_.hidden = NO;

    
    //加号方法调用加号方法
    UIView *publishView = [JKPublishView publishView];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
}


+(instancetype)publishView
{
    //xib创建，就用这个方法来初始化
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

-(void)awakeFromNib
{
    
    self.userInteractionEnabled = NO;
    
    //中间分布的六个按钮
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (JKScreenH - 2*buttonH)*0.5;
    NSInteger column = 3;
    CGFloat margin = 15;
    CGFloat gap = (JKScreenW - margin*2 - buttonW * column)/2;
    
    
    NSArray *images = @[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-review",@"publish-offline"];
    NSArray *titles = @[@"发视频",@"发图片",@"发段子",@"发声音",@"审核",@"离线下载"];
    
    
    
    for (int i = 0; i < images.count; i++)
    {
        JKVerticalButton *button = [[JKVerticalButton alloc]init];
        [self addSubview:button];
        //设置内容
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置位置框架
        CGFloat buttonX = margin + i % column * (buttonW + gap);
        CGFloat buttonY = i / column * buttonH + buttonStartY;
        CGFloat buttonTopY = buttonY - JKScreenH;
        
        //设置动画
        [self addAnimationWithObject:button originFrame:CGRectMake(buttonX, buttonTopY, buttonW, buttonH) finalFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) tag:button.tag animationType:kPOPViewFrame];
        
    }
    
    //顶部标题
    UIImageView *sloganView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
    self.sloganView = sloganView;
    sloganView.tag = 6;
    //动画执行以后，标题的运动轨迹是先添加到0 0，再跑到上面，再往下掉，所以一开始就把标题挪到上面
    
    CGFloat finalY = JKScreenH * 0.15;
    CGFloat originY = finalY - JKScreenH;
    sloganView.centerY = originY;
    CGFloat sloganX = JKScreenW *0.5 - sloganView.width/2;
    
    
    CGRect originRect = CGRectMake(sloganX, originY, sloganView.width, sloganView.height);
    CGRect finalRect = CGRectMake(sloganX, finalY, sloganView.width, sloganView.height);
    
    [self addAnimationWithObject:sloganView originFrame:originRect finalFrame:finalRect tag:sloganView.tag animationType:kPOPViewFrame];
    
    


}



-(void)test:(void(^)())canshuBlock//block当参数
{
    int age;
    
    //定义一个新的block
    void(^testBlock)() = ^{
        
    };
    
    //使用这个block
    testBlock();
}



    
    
   //抽出方法，添加动画
-(void)addAnimationWithObject:(id)object originFrame:(CGRect)originFrame finalFrame:(CGRect)finalFrame tag:(NSInteger)tag animationType:(NSString *)type
{
    //设置动画
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:type];
    ani.beginTime = CACurrentMediaTime() + tag/20.0;
    ani.springSpeed = 10;
    ani.springBounciness = 10;
    ani.fromValue = [NSValue valueWithCGRect:originFrame];
    ani.toValue =[NSValue valueWithCGRect:finalFrame];
    if (tag == 6) {
        [ani setCompletionBlock:^(POPAnimation *ani, BOOL finish) {
          
            self.userInteractionEnabled = YES;
        }];
    }
    [object pop_addAnimation:ani forKey:nil];
    
}

//按钮的点击事件
-(void)buttonClick:(UIButton *)button
{
    
    [self cancelWithCompletionBlock:^{
        
        if (button.tag == 0)
        {
            NSLog(@"发视频");
        }else if (button.tag == 1)
        {
            NSLog(@"发图片");
        }else if (button.tag == 2)//发文字
        {
            //判断是否登录
            if ([JKLoginTool getUid] == nil) return;
            
            
            JKPublishWordViewController * pubVC = [[JKPublishWordViewController alloc]init];
            //用导航栏包装起来
            JKNavigationController *nav = [[JKNavigationController alloc]initWithRootViewController:pubVC];
            //推出来
          UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:nav animated:YES completion:nil];
        }
    
    }];
    

}

-(void)cancelWithCompletionBlock:(void(^)())completionBlock
{
    
    self.userInteractionEnabled = NO;
    
    //取出子视图 对每个子视图安装动画
    for (int i = 1; i < self.subviews.count; i++)
    {
        UIView *view = self.subviews[i];
        
        //设置动画  基本动画
        POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        ani.beginTime = CACurrentMediaTime() + (i-1)/20.0;
        ani.toValue =[NSValue valueWithCGPoint:CGPointMake(view.centerX, view.centerY+JKScreenH)];
        
        [view pop_addAnimation:ani forKey:nil];
        
        if (i == self.subviews.count - 1)
        {
            [ani setCompletionBlock:^(POPAnimation *ani, BOOL result) {
            

                
                //动画结束后再调用控制器 如果有值 再执行
//                if (completionBlock)
//                {
//                    completionBlock();
//                }
                
                !completionBlock?:completionBlock();
                
               // window_.hidden = YES;
               [self removeFromSuperview];
                window_.hidden = YES;
                window_ =nil;
                
           }];
        }
        
    }
   

}


//按钮点击事件
- (IBAction)cancel
{
    
    [self cancelWithCompletionBlock:nil];


}


//屏幕触摸事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];

}



@end
