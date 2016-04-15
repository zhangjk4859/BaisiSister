//
//  JKTopicVoiceView.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTopicModel;
@interface JKTopicVoiceView : UIView

@property(nonatomic,strong)JKTopicModel *topicModel;
+(instancetype)voiceView;

@end


