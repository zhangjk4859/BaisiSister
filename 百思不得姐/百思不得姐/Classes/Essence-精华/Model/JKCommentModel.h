//
//  JKCommentModel.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/4.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKUserModel;
@interface JKCommentModel : NSObject

/**
 *  评论内容
 */
@property(nonatomic,copy)NSString *content;
/**
 *  点赞次数
 */
@property(nonatomic,assign)NSInteger like_count;
/**
 *  用户信息
 */
@property(nonatomic,strong)JKUserModel *user;
/**
 *  评论语音时长
 */
@property(nonatomic,assign)NSInteger voicetime;
/**
 *  评论语音链接地址
 */
@property(nonatomic,copy)NSString *voiceuri;
/**
 *  帖子的id
 */
@property(nonatomic,copy)NSString *ID;

@end
