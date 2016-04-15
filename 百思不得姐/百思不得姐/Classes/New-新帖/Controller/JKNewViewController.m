//
//  JKNewViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKNewViewController.h"


@interface JKNewViewController ()

@end

@implementation JKNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题图片
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //左边按钮
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(newClick)];
    self.view.backgroundColor = JKGlobalbg;
    
    
}



-(void)newClick
{
    JKLogFunc;
}



@end
