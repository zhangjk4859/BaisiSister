//
//  JKTagTextField.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTagTextField.h"

@implementation JKTagTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"占位文字";
        self.height = JKTagH;
    }
    return self;
}

-(void)deleteBackward
{
    //最后一个字，先调用这个block，有字，不删，
    !self.deleteBlock?:self.deleteBlock();
    //删除字
    [super deleteBackward];
    
}
@end
