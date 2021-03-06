//
//  AppDelegate.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "AppDelegate.h"
#import "JKTabBarController.h"

#import "JKPushGuideView.h"

#import "JKTopWindow.h"


@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //创建根控制器
    JKTabBarController *tabVC  = [[JKTabBarController alloc]init];
    self.window.rootViewController = tabVC;
    tabVC.delegate = self;
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
    //显示引导界面
    [JKPushGuideView show];
    
    
    return YES;
}

#pragma mark tabbar controller delegate
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //建立一个通知中心 如果tabbar被点击，就发送通知
    [JKNoteCenter postNotificationName:JKTabBarDidSelectedNotification object:nil userInfo:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //显示顶部窗口进行控制滚动视图滚到第一页
    //[JKTopWindow show];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
