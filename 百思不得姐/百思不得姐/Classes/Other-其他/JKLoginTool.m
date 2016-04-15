//
//  JKLoginTool.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/8.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKLoginTool.h"
#import "JKLoginRegisterController.h"

@implementation JKLoginTool
//如果有返回字符串，说明登录，返回nil，没有登录
+(NSString *)getUid
{
    NSString * uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    
    if (uid == nil) {
        JKLoginRegisterController *loginVC = [[JKLoginRegisterController alloc]init];\
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:YES completion:nil];
    }
    
    
    
    return uid;
}

+(void)setUid:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
