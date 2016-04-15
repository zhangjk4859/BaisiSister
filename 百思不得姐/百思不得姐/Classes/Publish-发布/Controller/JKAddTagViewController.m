//
//  JKAddTagViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKAddTagViewController.h"
#import "JKTagButton.h"
#import "JKTagTextField.h"
#import <SVProgressHUD.h>

@interface JKAddTagViewController ()<UITextFieldDelegate>
@property(nonatomic,weak)UIView *contentView;
@property(nonatomic,weak)JKTagTextField *textField;
//添加按钮懒加载只创建一次
@property(nonatomic,strong)UIButton *addBtn;
//所有的标签按钮
@property(nonatomic,strong)NSMutableArray *tagButtonArray;
@end

@implementation JKAddTagViewController
- (NSMutableArray *)tagButtonArray
{
    if (!_tagButtonArray) {
        _tagButtonArray = [NSMutableArray array];
    }
    return _tagButtonArray;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.width = self.contentView.width;
        _addBtn.height = 40;
        _addBtn.backgroundColor = JKButtonbg;
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.contentView addSubview:_addBtn];
    }
    return _addBtn;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupContentView];
    [self setupTextField];
    [self setupTags];
    
}

-(void)setupTags
{
    //模拟添加按钮 先添加内容，在点击添加
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self addTag];
    }
    
    
}
-(void)setupContentView
{
    UIView *contentVIew = [[UIView alloc]init];
    contentVIew.x =JKTagMargin;
    contentVIew.y = 64 + JKTagMargin;
    contentVIew.width = self.view.width - contentVIew.x * 2;
    contentVIew.height = JKScreenH;
    contentVIew.backgroundColor = [UIColor greenColor];
    [self.view addSubview:contentVIew];
    self.contentView = contentVIew;
}
-(void)setupTextField
{
    JKTagTextField *textField = [[JKTagTextField alloc]init];
    
    textField.width = self.contentView.width;
    [self.contentView addSubview:textField];
    __weak typeof(textField) weakTextField = textField;
    __weak typeof(self) weakSelf = self;
    textField.deleteBlock = ^{
        if (!weakTextField.hasText) {
            [weakSelf tagBtnClick:weakSelf.tagButtonArray.lastObject];
        }
    };
    textField.delegate = self;
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    self.textField =  textField;
    [textField becomeFirstResponder];
}
-(void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}


//监听文本变化
-(void)textDidChange
{
    if (self.textField.hasText) {//有文字
        //文字改变就更新内容
        [self updateTagButtonFrame];
        //显示添加标签的按钮
        [self.addBtn setTitle:self.textField.text forState:UIControlStateNormal];
        self.addBtn.hidden = NO;
        //按钮永远在文本框的最下面
        self.addBtn.y = CGRectGetMaxY(self.textField.frame)+JKTagMargin;
        
        //取出输入内容的最后一个字符
        NSString *text = self.textField.text;
        NSUInteger lenght = text.length;
        NSString *lastLetter = [text substringFromIndex:lenght - 1];
        if ([lastLetter isEqualToString:@"," ] || [lastLetter isEqualToString:@"，" ] ) {
            self.textField.text = [text substringToIndex:lenght -1];
            [self addTag];
        }
    }else//没文字
    {
        self.addBtn.hidden = YES;
    }
    
    
}

//监听加号按钮点击
-(void)addTag
{
    if (self.tagButtonArray.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"不能再添加了" maskType:SVProgressHUDMaskTypeBlack];
        return;
        
    }
    
    JKTagButton *tagBtn = [JKTagButton buttonWithType:UIButtonTypeCustom];
    //图片 文字 添加父控件
    
    [tagBtn setTitle:self.textField.text forState:UIControlStateNormal];
    [self.contentView addSubview:tagBtn];
    
    [self.tagButtonArray addObject:tagBtn];
    [self updateTagButtonFrame];//不仅要添加按钮，还要更新位置
    [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 清空textField的文字内容
    self.textField.text = nil;
    self.addBtn.hidden = YES;
    
   
}

//标签按钮的点击事件
-(void)tagBtnClick:(JKTagButton *)btn
{
   //从父视图中移除，从数组中移除，更新下整体的布局
    [btn removeFromSuperview];
    [self.tagButtonArray removeObject:btn];
    //移除的时候整一个动画
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
    }];
    
}
//专门用来更新标签的frame
-(void)updateTagButtonFrame
{
    //更新按钮的frame
    for (int i = 0; i<self.tagButtonArray.count; i++) {
        JKTagButton *tagBtn = self.tagButtonArray[i];
        if (i == 0) {
            tagBtn.x = 0;
            tagBtn.y = 0;
        }else{//后面的按钮
            JKTagButton *lastTagButton = self.tagButtonArray[i - 1];
            //当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame)+JKTagMargin;
            //计算当前行剩余的宽度
            CGFloat rightWidth = self.contentView.width - CGRectGetMaxX(lastTagButton.frame)-JKTagMargin;
            if (rightWidth >= tagBtn.width) {//放在当前行
                tagBtn.y = lastTagButton.y;
                tagBtn.x = leftWidth;
            }else{//放到下一行
                tagBtn.y = CGRectGetMaxY(lastTagButton.frame) + JKTagMargin;
                tagBtn.x = 0;
            }
        }
    }
    
    
    //更新textfield的frame 如果尾部可以剩下100 就放进去
    JKTagButton *lastTagBtn = self.tagButtonArray.lastObject;
    CGFloat leftWidth = CGRectGetMaxX(lastTagBtn.frame) + JKTagMargin;
    if (self.contentView.width - leftWidth > [self textFieldWidth]) {
        self.textField.x = leftWidth;
        self.textField.y = lastTagBtn.y;
    }else{
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagBtn.frame)+JKTagMargin;
    }
  
}
//textField文字的宽度
-(CGFloat)textFieldWidth
{
    //根据文字内容算出宽度
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName:self.textField.font}].width;
    //本身最少有一百
    return MAX(100, textW);
}

//完成返回动作  并且添加标签
-(void)done
{
    //传递数据给上一个控制器，解析成一个字符串数组
    NSMutableArray *titles = [NSMutableArray array];
    for (JKTagButton *tagBtn in self.tagButtonArray) {
        NSString *title = [tagBtn currentTitle];
        [titles addObject:title];
    }
    
   // NSArray *tags = [self.tagButtonArray valueForKeyPath:@"currentTitle"];
    //首先要看外面的引用block是不是空
    !self.tagsBlock?:self.tagsBlock(titles);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark UITextFieldDelegate
//监听键盘 return key 点击
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.hasText) {
        [self addTag];
    }
    return YES;
}

//监听软键盘删除按钮


@end
