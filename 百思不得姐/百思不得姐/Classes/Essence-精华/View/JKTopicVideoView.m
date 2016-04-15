//
//  JKTopicVideoView.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTopicVideoView.h"
#import "JKTopicModel.h"
#import <UIImageView+WebCache.h>
#import "JKShowPictureViewController.h"


@interface JKTopicVideoView()
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation JKTopicVideoView
//播放次数
- (IBAction)playVideo:(id)sender
{
    
}

//xib创建的视图，必须要关掉自动重算视图
-(void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    //初始化的时候开启交互，添加手势
    self.backgroundImage.userInteractionEnabled = YES;
    [self.backgroundImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPicture)]];
}

-(void)showBigPicture
{
    JKShowPictureViewController *pictureVC = [[JKShowPictureViewController alloc]init];
    
    //传一个模型进来
    pictureVC.topicModel = self.topicModel;
    
    //找到跟控制器进行推送
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pictureVC animated:YES completion:nil];
    
}


+(instancetype)videoView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

//当模型传进来的设置数据
-(void)setTopicModel:(JKTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:topicModel.small_image]];
    //做一个数字的处理
    NSString *playCountString = nil;
    NSInteger playCount = [topicModel.playcount integerValue];
    if (playCount > 9999) {
        playCountString = [NSString stringWithFormat:@"%.1f万次",playCount/10000.0];
    }else
    {
        playCountString = [NSString stringWithFormat:@"%@次播放",topicModel.playcount];
    }
    
    
    self.playcountLabel.text = playCountString;
    
    //如何把字符串时间换算成分钟时间
    NSInteger videotime = [topicModel.videotime integerValue];
    NSInteger minute = videotime/60;
    NSInteger second = videotime%60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    
}

@end
