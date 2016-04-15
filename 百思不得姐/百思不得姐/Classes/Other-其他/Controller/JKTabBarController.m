//
//  JKTabBarController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTabBarController.h"

#import "JKEssenceViewController.h"
#import "JKNewViewController.h"
#import "JKFriendTrendsViewController.h"
#import "JKMeViewController.h"

#import "JKTabBar.h"

#import "JKNavigationController.h"

@interface JKTabBarController ()

@end

@implementation JKTabBarController

//一次性的设置最好都放到这个方法里
+(void)initialize
{
    //让字典来决定字体
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    //让字典来决定字体
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    //把外观拿出来统一进行设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self setupChildVC:[[JKEssenceViewController alloc]init] WithTitle:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupChildVC:[[JKNewViewController alloc] init]  WithTitle:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    
    [self setupChildVC:[[JKFriendTrendsViewController alloc]init]WithTitle:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self setupChildVC:[[JKMeViewController alloc]initWithStyle:UITableViewStyleGrouped]WithTitle:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    

    //更换自定义的tabbar
    [self setValue:[[JKTabBar alloc]init] forKeyPath:@"tabBar"];
    

    

    
    
   //didload完成的时候，子视图里面只有自己添加的那个按钮
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog(@"%@",self.tabBar.subviews);
//}

//抽出来的方法，统一设置控制器
-(void)setupChildVC:(UIViewController *)VC WithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    VC.navigationItem.title = title;
    //如果设置背景色，第一次启动就会四个都创建，浪费资源不合理
    //VC.view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    VC.tabBarItem.title = title;
    VC.tabBarItem.image = [UIImage imageNamed:image];
    VC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    //包装一个导航控制器
    JKNavigationController *nav = [[JKNavigationController alloc]initWithRootViewController:VC];
    

    [self addChildViewController:nav];
}








@end
