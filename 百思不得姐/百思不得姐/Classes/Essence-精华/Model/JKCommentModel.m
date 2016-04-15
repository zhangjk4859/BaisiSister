//
//  JKCommentModel.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/4.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKCommentModel.h"

@implementation JKCommentModel

//切换服务器返回名字
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id",
             };
}

@end
