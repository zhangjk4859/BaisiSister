//
//  JKVerticalButton.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/27.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKVerticalButton.h"

@implementation JKVerticalButton

//代码创建视图 进行初始化
 -(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}



//XIB创建的视图  进行初始化
-(void)awakeFromNib
{
    [self setup];
}

-(void)setup
{
    //初始化按钮
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    
      //因为这里是正方形
    self.imageView.width = self.width;
    self.imageView.height = self.width;
    
    
    //调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.width = self.width;
    
    
    
}

@end
