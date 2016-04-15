//
//  JKShowPictureViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/31.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKShowPictureViewController.h"
#import <UIImageView+WebCache.h>
#import "JKTopicModel.h"
#import <SVProgressHUD.h>
#import "JKProgressView.h"

@interface JKShowPictureViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,weak)UIImageView *imageView;

@property (weak, nonatomic) IBOutlet JKProgressView *progressView;

@end

@implementation JKShowPictureViewController

//点击返回按钮消失
- (IBAction)backButtoncClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imageView = [[UIImageView alloc]init];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtoncClick:)]];
    

    
    
    CGFloat pictureW = JKScreenW;
    CGFloat pictureH = pictureW * self.topicModel.height / self.topicModel.width;
    if (pictureH > JKScreenH) { //大于屏幕高度
        //需要滚动查看 设置成 0 0，自己的宽度和高度,设置内容能滚动
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
        
        
    }else
    {
        //先设置尺寸，再居中显示
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = JKScreenH * 0.5;
    }
    

    
    
    
    //怎么显示取决于图片的尺寸 数据都在模型里面，所以推出的时候直接赋值一个模型
    //马上显示下载的进度
    [self.progressView setProgress:self.topicModel.pictureProgress animated:NO];
    //直接加载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topicModel.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        
        [self.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
   
}


- (IBAction)save
{
    //如果图片没有下载完，就返回
    if (self.imageView.image == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"没有下载完成"];
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (error)
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        NSLog(@"%@",error);
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
 
}



@end
