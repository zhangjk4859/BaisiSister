//
//  JKPushGuideView.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/28.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKPushGuideView.h"

@implementation JKPushGuideView

+(instancetype)guideView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+(void)show
{
    //做一个条件判断，如果当前版本和沙盒里面的版本不一样，就打开，一样就不打开
    
    //存储版本号的key
    NSString *betaKey = @"CFBundleVersion";
    
    //当前版本
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[betaKey];
    
    //JKLog(@"%@",[NSBundle mainBundle].infoDictionary);
    
    //沙盒版本
    NSString *sandBoxKey = [[NSUserDefaults standardUserDefaults] objectForKey:betaKey];
    
    //拿到当前窗口
    UIWindow *window =  [UIApplication sharedApplication].keyWindow;
    
    //如果不相等
    if (![currentVersion isEqualToString:sandBoxKey])
    {
        JKPushGuideView *pushView = [JKPushGuideView guideView];
        pushView.frame = window.bounds;
        [window addSubview:pushView];
        
        //新版本保存一下
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:betaKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (IBAction)close:(id)sender
{
    [self removeFromSuperview];
}



@end
