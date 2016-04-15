//
//  JKTopicPictureView.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/30.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTopicModel;
@interface JKTopicPictureView : UIView
+(instancetype)pictureView;


@property(nonatomic,strong)JKTopicModel *topicModel;
@end
