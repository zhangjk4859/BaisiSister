//
//  JKProgressView.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/31.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKProgressView.h"

@implementation JKProgressView

//由于是xib创建的  所以在这个方法里进行初始化


-(void)awakeFromNib
{
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
    
    
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    //NSLog(@"%f",progress);
    
    //有负号，就把字符串拿出来，处理一下，在赋值
    NSString *text = [NSString stringWithFormat:@"%.1f%%",progress*100];
    
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    self.progressLabel.text =text;
    
}
@end
