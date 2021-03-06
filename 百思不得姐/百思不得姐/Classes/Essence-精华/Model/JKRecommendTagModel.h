//
//  JKRecommendTagModel.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/26.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRecommendTagModel : NSObject

/**
 *  图片链接
 */
@property(nonatomic,copy)NSString *image_list;
/**
 *  名字
 */
@property(nonatomic,copy)NSString *theme_name;
/**
 *  订阅数
 */
@property(nonatomic,assign)NSInteger sub_number;

@end
