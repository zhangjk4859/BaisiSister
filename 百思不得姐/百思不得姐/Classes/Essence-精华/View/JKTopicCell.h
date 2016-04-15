//
//  JKTopicCell.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/29.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKTopicModel;
@interface JKTopicCell : UITableViewCell

@property(nonatomic,strong)JKTopicModel *topicModel;

//创建一个快速创建cell的方法
+(instancetype)cell;
@end
