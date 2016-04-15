//
//  JKRecommendUser.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/24.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRecommendUser : NSObject

/**
 *简介（空）
 */
@property(nonatomic,copy)NSString *introduction;
/**
  *  id
  */
@property(nonatomic,assign)NSInteger uid;
/**
 *  头像链接
 */
@property(nonatomic,copy)NSString *header;
/**
 *  性别
 */
@property(nonatomic,assign)NSInteger gender;


/**
 *  是否是VIP
 */
@property(nonatomic,assign)NSInteger is_vip;
/**
 *  粉丝数量
 */
@property(nonatomic,assign)NSInteger fans_count;

/**
 *  帖子数量
 */
@property(nonatomic,assign)NSInteger tiezi_count;
/**
 *  关注
 */
@property(nonatomic,assign)NSInteger is_follow;

/**
 *  赞的人
 */
@property(nonatomic,copy)NSString *screen_name;




@end
