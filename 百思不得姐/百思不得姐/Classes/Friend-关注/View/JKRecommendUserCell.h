//
//  JKRecommendUserCell.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/24.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>

//把模型捆绑到cell上面
@class JKRecommendUser;

@interface JKRecommendUserCell : UITableViewCell

@property(nonatomic,strong)JKRecommendUser *userModel;

@end
