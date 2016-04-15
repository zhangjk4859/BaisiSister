//
//  JKLoginRegisterController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/26.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKLoginRegisterController.h"

@interface JKLoginRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation JKLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTapGestureForNeededViews];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//给除了按钮和输入框外所有视图加一个点击的手势
-(void)addTapGestureForNeededViews
{
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    //子视图添加
    for (UIView * subView in self.view.subviews)
    {
        if (!([subView isKindOfClass:[UITextField class]] ||
              [subView isKindOfClass:[UIButton class]]
              )
            )
        {

            [subView addGestureRecognizer:ges];
        }
    }
    //母视图添加
    [self.view addGestureRecognizer:ges];
    
}

//关闭软键盘
-(void)closeKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)showLoginOrRegister:(UIButton *)button
{
    [self.view endEditing:YES];
    

    if (self.loginViewLeftMargin.constant == 0) {
        self.loginViewLeftMargin.constant = -self.view.width;
       // [button setTitle:@"已有账号？" forState:UIControlStateNormal];
        button.selected = YES;
        
    }else{
        self.loginViewLeftMargin.constant = 0;
         //[button setTitle:@"注册账号" forState:UIControlStateNormal];
        button.selected = NO;
    }
    //改变了布局，需要调用这个函数
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
    //看到了设置右边间距那里 07
    
}


- (IBAction)closeClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
   //改变顶部状态栏风格
    return UIStatusBarStyleLightContent;
}


//思路，在所有的子视图中，除了两个文本框，都加入一个手势，手势点击，键盘消失



@end
