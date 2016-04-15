//
//  JKNavigationController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/23.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKNavigationController.h"

@interface JKNavigationController ()

@end

@implementation JKNavigationController

//在这个方法里面即使有多个视图控制器调用导航，设置背景也只会调用一次，节省资源，viewDidload会调用多次
+(void)initialize
{
    //设置导航条背景图
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    //统一设置字体颜色
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    //设置高亮颜色
    NSMutableDictionary *attrsDis = [NSMutableDictionary dictionary];
    attrsDis[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:attrsDis forState:UIControlStateDisabled];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationBar.tintColor = [UIColor blackColor];
    
    
    self.interactivePopGestureRecognizer.delegate = nil;
}


//可以在这个方法中拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{//首先要调用super，如果不调用，系统自带的工作就无法进行
    
    
    //需求就是默认都给你设置成返回，如果你需要自己自定义，可以在viewdidLoad里面设置覆盖(子控制器)
    //第一次进来，根控制器是不会覆盖的（根控制器）
    
    //用一个自定义的按钮，替换返回按钮
    if (self.childViewControllers.count > 0) {
        
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    btn.size = CGSizeMake(70, 30);
        //btn.backgroundColor = [UIColor orangeColor];
        //[btn sizeToFit];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        //添加按钮动作
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    viewController.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        viewController.hidesBottomBarWhenPushed = YES;
    
    }
    
    [super pushViewController:viewController animated:animated];
    
}


-(void)back
{
    [self popViewControllerAnimated:YES];
}



@end
