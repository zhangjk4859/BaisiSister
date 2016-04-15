//
//  JKTopicPictureView.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/30.
//  Copyright © 2016年 张俊凯. All rights reserved.
//  显示在cell中的图片

#import "JKTopicPictureView.h"
#import "JKTopicModel.h"
#import <UIImageView+WebCache.h>
#import "JKProgressView.h"
#import "JKShowPictureViewController.h"
@interface JKTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet JKProgressView *progressView;

@end


@implementation JKTopicPictureView

-(void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //初始化的时候开启交互，添加手势
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPicture)]];

}

-(void)showBigPicture
{
    JKShowPictureViewController *pictureVC = [[JKShowPictureViewController alloc]init];
    
    //传一个模型进来
    pictureVC.topicModel = self.topicModel;
    
    //找到跟控制器进行推送
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pictureVC animated:YES completion:nil];
    
}

+(instancetype)pictureView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

-(void)setTopicModel:(JKTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    
    
    
    //判断是否为gif
    NSString *surfixString = topicModel.large_image.pathExtension;
    self.gifImageView.hidden = ![surfixString.lowercaseString isEqualToString:@"gif"];
    
    //判断按钮是否隐藏，图片是否为长图，规定一个值，超过就收缩，显示按钮
    if (topicModel.isBigPicture)
    {
        self.seeBigButton.hidden = NO;
        //填充一部分
        //self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }else
    {
        self.seeBigButton.hidden = YES;
    }
    
    //每次进来之前立马显示最新的进度值（防止因为网速慢，显示的是上一个cell的值）
    [self.progressView setProgress:topicModel.pictureProgress animated:NO];
    
    
    //加载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topicModel.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //完成后隐藏，没完成就得显示
        self.progressView.hidden = NO;
        //计算进度值，并且给到模型保存起来
        topicModel.pictureProgress = 1.0 * receivedSize/expectedSize;
        [self.progressView setProgress:topicModel.pictureProgress animated:NO];
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //下载完成以后，进度条隐藏
        self.progressView.hidden = YES;
        
        //是大图片，才需要进行绘图处理 其余的正常显示，至于大图，点击查看进去图片控制器再进行查看
        if (topicModel.isBigPicture == NO) return;
        
        //把下载完成的图片进行处理，裁剪，开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topicModel.pictureFrame.size, YES, 0.0);
        
        //将下载完的图片绘制到图形上下文中 等比例的长图中，再进行裁剪
        CGFloat width  = topicModel.pictureFrame.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图形上下文
        UIGraphicsGetCurrentContext();
    
        
    
    
    }];
   
}


@end
