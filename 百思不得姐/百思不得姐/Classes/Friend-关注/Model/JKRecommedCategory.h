//
//  JKRecommedCategory.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/24.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRecommedCategory : NSObject

/**
 *  id
 */
@property(nonatomic,assign)NSInteger ID;
/**
 * 名字
 */
@property(nonatomic,copy)NSString *name;
/**
 *  总数
 */
@property(nonatomic,assign)NSInteger count;


//建立一个可变数组给自己用，为优化有旧数据 不访问网络而定
@property(nonatomic,strong)NSMutableArray *users;


//记录总页数和当前页数
/**
 *  总页数q
 */
@property(nonatomic,assign)NSInteger total;

/**
 *  当前页数
 */
@property(nonatomic,assign)NSInteger currentPage;


@end
