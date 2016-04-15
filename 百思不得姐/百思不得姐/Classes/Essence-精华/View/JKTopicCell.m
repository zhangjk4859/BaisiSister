//
//  JKTopicCell.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/29.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTopicCell.h"
#import "JKTopicModel.h"
#import <UIImageView+WebCache.h>
#import "JKTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "JKTopicVoiceView.h"
#import "JKTopicVideoView.h"
#import "JKCommentModel.h"
#import "JKUserModel.h"
#import "UIImage+JKExtension.h"

@interface JKTopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *VIPImageView;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property(nonatomic,weak)JKTopicPictureView *pictureView;
@property(nonatomic,weak)JKTopicVoiceView *voiceView;
@property(nonatomic,weak)JKTopicVideoView *videoView;
//最热评论内容
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
//最热评论视图
@property (weak, nonatomic) IBOutlet UIView *topCmtView;

@end

@implementation JKTopicCell
/**
 *事件的处理方法思路
 
 今年
    今天
       1分钟内
             刚刚
       一小时内
             XX分钟前
       其他
             XX小时前
    昨天 
       昨天 20：30：50
 
 非今年
     2015-06-17 20：00：00
 
 *
 *
 */

+(instancetype)cell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}


//中间显示图片的懒加载，你要用到我，我再加载
- (JKTopicPictureView *)pictureView
{
    //如果没有，就创建，有的话就不创建了，直接返回数据，这个方法太奇妙了
    if (!_pictureView) {
        JKTopicPictureView *pictureView = [JKTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

//声音的view
- (JKTopicVoiceView *)voiceView
{
    //如果没有，就创建，有的话就不创建了，直接返回数据，这个方法太奇妙了
    if (!_voiceView) {
        JKTopicVoiceView *voiceView = [JKTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

//视频的view
- (JKTopicVideoView *)videoView
{
    //如果没有，就创建，有的话就不创建了，直接返回数据，这个方法太奇妙了
    if (!_videoView) {
        JKTopicVideoView *videoView = [JKTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}


//model set方法
-(void)setTopicModel:(JKTopicModel *)topicModel
{
    _topicModel = topicModel;
    
   
    
    //是否显示会员
    self.VIPImageView.hidden = (topicModel.is_vip == 0);
    //设置名字
    self.nameLabel.text = topicModel.name;
    //设置时间
    self.timeLabel.text = topicModel.create_time;
    
    
    [self setButton:self.dingButton withCount:topicModel.ding placeHolder:@"顶"];
    [self setButton:self.caiButton withCount:topicModel.cai placeHolder:@"踩"];
    [self setButton:self.repostButton withCount:topicModel.repost placeHolder:@"转发"];
    [self setButton:self.commentButton withCount:topicModel.comment placeHolder:@"评论"];
    //头像切割成圆角
    [self.headImageView setHeader:topicModel.profile_image];
    
    //设置内容
    self.text_label.text = topicModel.text;

    //如果是图片类型的model，就让cell加载图片xib,但是有一个问题，在滚动过程中会不断的调用set方法，每调用一次就添加一次subview，怎么处理？
    if (topicModel.type == JKTopicTypePicture) {//如果是图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topicModel = topicModel;
        self.pictureView.frame = topicModel.pictureFrame;
        
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        
        
    }else if (topicModel.type == JKTopicTypeVoice){//如果是声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topicModel = topicModel;
        self.voiceView.frame = topicModel.voiceFrame;
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        
        
    }else if (topicModel.type == JKTopicTypeVideo){//如果是视频帖子
        self.videoView.hidden = NO;
        self.videoView.topicModel = topicModel;
        self.videoView.frame = topicModel.videoFrame;
        
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;

    }else{
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    }

    //设置评论内容
    JKCommentModel *commentModel = topicModel.top_cmt;
    if (commentModel) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@:%@",commentModel.user.username,commentModel.content];
    }else{
        self.topCmtView.hidden = YES;
    }
    
    


}

-(void)testDate
{
//    //因为外面已经用类方法创建了日期，所以增加的方法是对象方法
//    NSDateComponents *components =  [now deltaFrom:createDate];
//    //JKLog(@"%@",components);
//    
//    [now deltaFrom:createDate];
//    
//    //测试自己写的函数
//    NSDate *testDate = [fmt dateFromString:@"2016-03-29 09:00:00"];
//    JKLog(@"%d %d %d",[testDate isThisYear],[testDate isThisYestoday],[testDate isThisToday]);
}

-(void)setButton:(UIButton *)button withCount:(NSInteger)count placeHolder:(NSString *)placeholder
{
    
    
    if (count > 9999)
    {
        placeholder = [NSString stringWithFormat:@"%.1f万",count/10000.0];
    }
    else if (count > 0)
    {
        placeholder = [NSString stringWithFormat:@"%zd",count];
    }
    
    [button setTitle:placeholder forState:UIControlStateNormal];
    
}

//让cell缩小
-(void)setFrame:(CGRect)frame
{
   static CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2*margin;
    frame.origin.y += margin;
    frame.size.height = self.topicModel.cellHeight - margin;
    
    //NSLog(@"------------cell%f",frame.size.height);
    [super setFrame:frame];
}

- (void)awakeFromNib {
    //初始化XIB
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    self.backgroundView = imageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//更多点击按钮的动作
- (IBAction)mofreClick {
    // 创建controller
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //创建action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"转发" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:nil];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:deleteAction];
    [actionSheet addAction:saveAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:actionSheet animated:YES completion:nil];
    
    
}

@end
