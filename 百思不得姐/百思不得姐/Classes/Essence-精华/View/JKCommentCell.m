//
//  JKCommentCell.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKCommentCell.h"
#import "JKCommentModel.h"
#import <UIImageView+WebCache.h>
#import "JKUserModel.h"
#import "UIImage+JKExtension.h"
@interface JKCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likecountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end



@implementation JKCommentCell

-(void)setModel:(JKCommentModel *)model
{
    _model = model;
    [self.headImageView setHeader:model.user.profile_image];
    
    self.sexImageView.image = [model.user.sex isEqualToString:JKUserSexMale]?[UIImage imageNamed:@"Profile_manIcon"]:[UIImage imageNamed:@"Profile_womanIcon"];
    self.nameLabel.text = model.user.username;
    self.contentLabel.text = model.content;
    self.likecountLabel.text = [NSString stringWithFormat:@"%zd次",model.like_count];
    
    if (model.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",model.voicetime]forState:UIControlStateNormal];
    }else{
        self.voiceButton.hidden = YES;
    }
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = JKTopicCellMargin;
    frame.size.width -= 2*JKTopicCellMargin;
    [super setFrame:frame];
}

//为menuController服务
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

@end
