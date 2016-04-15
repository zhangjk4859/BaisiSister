//
//  JKPublishWordViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKPublishWordViewController.h"
#import "JKPlaceholderTextView.h"
#import "JKAddTagToolBar.h"

@interface JKPublishWordViewController ()<UITextViewDelegate>
@property(nonatomic,strong)JKAddTagToolBar *toolbar;
@property(nonatomic,weak)JKPlaceholderTextView *textView;
@end

@implementation JKPublishWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTextView];
    [self setupToolBar];
    
    
}

-(void)setupToolBar
{
    //添加toolbar工具条
    JKAddTagToolBar *toolbar = [JKAddTagToolBar toolBar];
    
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    //NSLog(@"%@",toolbar);
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    //添加通知中心
    [JKNoteCenter addObserver:self selector:@selector(toolbarMove:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
//监听到通知中心 工具条改变
-(void)toolbarMove:(NSNotification *)note
{
    
   
   CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat interval = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //让工具条的frame 发生改变
    [UIView animateWithDuration:interval animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0,keyboardFrame.origin.y - JKScreenH);
    }];
    
    
}
-(void)setupTextView
{
    JKPlaceholderTextView * textView = [[JKPlaceholderTextView alloc]init];
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    textView.delegate = self;
    self.textView = textView;
    
    textView.placeholder = @"测试占位文字测试占位文字测试占位文字测试占位文字测试占位文字";
    //textView.inputAccessoryView = [JKAddTagToolBar toolBar];

}

//让键盘在显示的时候就弹出
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}


-(void)setupNav
{
    //设置标题
    self.title = @"发段子";
    //设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    //设置右边按钮
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    
    //设置右边按钮为不能用
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.navigationController.navigationBar layoutIfNeeded];
}

//左边按钮动作
-(void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//右边按钮动作
-(void)publish
{
    JKLogFunc;
}


#pragma mark UITextViewDelegate
//有文字，按钮可用
-(void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

//滚动键盘就收回
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
