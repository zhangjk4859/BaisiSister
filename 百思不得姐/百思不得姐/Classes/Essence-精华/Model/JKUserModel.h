//
//  JKUserModel.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKUserModel : NSObject
/**
 *  用户名
 */
@property(nonatomic,copy)NSString *username;
/**
 *  头像
 */
@property(nonatomic,copy)NSString *profile_image;
/**
 *  性别
 */
@property(nonatomic,copy)NSString *sex;
@end
