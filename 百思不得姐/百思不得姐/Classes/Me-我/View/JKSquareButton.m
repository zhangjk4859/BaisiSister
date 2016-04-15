//
//  JKSquareButton.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/6.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKSquareButton.h"
#import "JKSquareModel.h"
#import <UIButton+WebCache.h>

@implementation JKSquareButton

//代码创建视图 进行初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

-(void)setModel:(JKSquareModel *)model
{
    _model = model;
    [self setTitle:model.name forState:UIControlStateNormal];
    
    [self sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"cellFollowClickIcon"]];
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
    //字体
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    //颜色
    self.titleLabel.textColor = [UIColor blackColor];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //调整图片
    self.imageView.x = 0;
    self.imageView.y = self.height * 0.2;
    
    //因为这里是正方形
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    
    
    //调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.height = self.height - self.imageView.height-self.imageView.y;
    self.titleLabel.width = self.width;
    
    
    
}

@end
