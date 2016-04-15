//
//  JKRecommendUserCell.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/24.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKRecommendUserCell.h"
#import "JKRecommendUser.h"
#import <UIImageView+WebCache.h>

@interface JKRecommendUserCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@end



@implementation JKRecommendUserCell

//设置模型set方法
-(void)setUserModel:(JKRecommendUser *)userModel
{
    _userModel = userModel;
    self.titleLabel.text = userModel.screen_name;
    
    [self.headImageView setHeader:userModel.header];
    
    NSString *fansCountString = nil;
    
    if (userModel.fans_count < 10000) {
        [NSString stringWithFormat:@"%zd人关注",userModel.fans_count];
    } else {
        [NSString stringWithFormat:@"%.1f万人关注",userModel.fans_count / 10000.0];
    }
    
    self.contentLabel.text = fansCountString;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
