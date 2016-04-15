//
//  JKLoginTool.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/8.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKLoginTool : NSObject
//如果有返回字符串，说明登录，返回nil，没有登录
+(NSString *)getUid;

//把UID存起来
+(void)setUid:(NSString *)uid;
@end
