//
//  JKTagButton.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTagButton.h"

@implementation JKTagButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = JKButtonbg;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

//传进来文字  直接重新算尺寸
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    //调整以后加三个间距
    [self sizeToFit];
    //算好以后再重新算一下
    self.width += 3 *JKTagMargin;
    self.height = JKTagH;
}

//有了文字以后就重新布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //分布好以后交换一下位置
    self.titleLabel.x = JKTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame)+JKTagMargin;
    
}
@end
