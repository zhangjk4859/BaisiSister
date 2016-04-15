//
//  JKFriendTrendsViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKFriendTrendsViewController.h"
#import "JKRecommendViewController.h"
#import "JKLoginRegisterController.h"



@interface JKFriendTrendsViewController ()


@end

@implementation JKFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //中间标题
    self.navigationItem.title = @"我的关注";
    
    //左边按钮
   self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    
    self.view.backgroundColor = JKGlobalbg;
    

    
}

-(void)friendsClick
{
    JKRecommendViewController *recVC = [[JKRecommendViewController alloc]init];
    
    [self.navigationController pushViewController:recVC animated:YES];
}

//注册登录按钮事件
- (IBAction)loginRegister
{
    JKLoginRegisterController *loginVC = [[JKLoginRegisterController alloc]init];
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
    
    
}



@end
