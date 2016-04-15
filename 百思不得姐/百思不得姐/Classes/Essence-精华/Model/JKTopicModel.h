//
//  JKTopicModel.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/29.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKCommentModel;
@interface JKTopicModel : NSObject
/**
 *  帖子的id  用字符串好一点  不会越界
 */
@property(nonatomic,copy)NSString *ID;
/**
 *  名字
 */
@property(nonatomic,copy)NSString *name;
/**
 *  头像
 */
@property(nonatomic,copy)NSString *profile_image;
/**
 *  发帖时间
 */
@property(nonatomic,copy)NSString *create_time;
/**
 *  帖子内容
 */
@property(nonatomic,copy)NSString *text;
/**
 *  顶
 */
@property(nonatomic,assign)NSInteger ding;
/**
 *  踩
 */
@property(nonatomic,assign)NSInteger cai;
/**
 *  转发
 */
@property(nonatomic,assign)NSInteger repost;
/**
 *  评论数
 */
@property(nonatomic,assign)NSInteger comment;
/**
 *  是否会员
 */
@property(nonatomic,assign)NSInteger is_vip;

/**
 *  图片高度
 */
@property(nonatomic,assign)CGFloat height;
/**
 *  图片宽度
 */
@property(nonatomic,assign)CGFloat width;
/**
 *  图片URL小图
 */
@property(nonatomic,copy)NSString *small_image;
/**
 *  图片URL大图
 */
@property(nonatomic,copy)NSString *large_image;
/**
 *  图片URL中等
 */
@property(nonatomic,copy)NSString *middle_image;

/**
 *图片URL 未知
 */
@property(nonatomic,copy)NSString *cdn_img;

/**
 *  帖子的类型
 */
@property(nonatomic,assign)JKTopicType type;
/**
 *  额外的辅助属性 cell的高度
 */

@property(nonatomic,assign,readonly)CGFloat cellHeight;



/**b图片控件的frame **/
@property(nonatomic,assign,readonly)CGRect pictureFrame;

/**声音控件的frame **/
@property(nonatomic,assign,readonly)CGRect voiceFrame;

/**视频控件的frame **/
@property(nonatomic,assign,readonly)CGRect videoFrame;

/**
 *  判断图片是否太大
 */
@property(nonatomic,assign,getter=isBigPicture)BOOL bigPicture;

/**
 *  图片下载进度
 */
@property(nonatomic,assign)CGFloat pictureProgress;

/**
 *  播放次数
 */
@property(nonatomic,copy)NSString *playcount;
/**
 *  音频地址
 */
@property(nonatomic,copy)NSString *voiceurl;
/**
 *  音频时长
 */
@property(nonatomic,copy)NSString *voicetime;
/**
 *  视频时长
 */
@property(nonatomic,copy)NSString *videotime;
/**
 *  视频地址
 */
@property(nonatomic,copy)NSString *videourl;
/**
 *  最热评论
 */
@property(nonatomic,strong)JKCommentModel *top_cmt;
/**
 *  测试，取出用户名
 */
@property(nonatomic,copy)NSString *username;


@end
