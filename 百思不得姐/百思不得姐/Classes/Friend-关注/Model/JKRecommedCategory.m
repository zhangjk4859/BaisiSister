//
//  JKRecommedCategory.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/24.
//  Copyright © 2016年 张俊凯. All rights reserved.
//


//推荐关注左边的数据模型   

#import "JKRecommedCategory.h"
#import <MJExtension.h>


@implementation JKRecommedCategory


//+(NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{
//             @"ID":@"id"
//             };
//}

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"ID"]) return @"id";
    
    return propertyName;
    
}


- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
        
    }
    return _users;
}



@end
