//
//  JKAddTagToolBar.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKAddTagToolBar.h"
#import "JKAddTagViewController.h"
@interface JKAddTagToolBar()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,strong)NSMutableArray *tagLabelArray;
@property(nonatomic,weak)UIButton *addBtn;

@end

@implementation JKAddTagToolBar
- (NSMutableArray *)tagLabelArray
{
    if (!_tagLabelArray) {
        _tagLabelArray = [NSMutableArray array];
    }
    return _tagLabelArray;
}
+(instancetype)toolBar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    //图  控制状态图  当前图  原理一样的
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addBtn.size = addBtn.currentImage.size;
    addBtn.x = JKTagMargin;
    [self.topView addSubview:addBtn];
    self.addBtn = addBtn;
    //添加点击动作
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //默认带有两个按钮
    [self createTags:@[@"吐槽",@"糗事"]];
    
    
}

-(void)addBtnClick
{
    JKAddTagViewController *addTagVC =[[JKAddTagViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    [addTagVC setTagsBlock:^(NSArray *titles) {
        [weakSelf createTags:titles];
    }];
    
    addTagVC.tags = [self.tagLabelArray valueForKeyPath:@"text"];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
   //取出根控制器当前正在推出的控制器
    UINavigationController * nav =(UINavigationController *)rootVC.presentedViewController;
    [nav pushViewController:addTagVC animated:YES];
    
}

-(void)createTags:(NSArray *)tags
{
    //每次创建之前先清空
    [self.tagLabelArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabelArray removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc]init];
        [self.tagLabelArray addObject:tagLabel];
        tagLabel.backgroundColor = JKButtonbg;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:14];
        [tagLabel sizeToFit];
        tagLabel.width += 2*JKTagMargin;
        tagLabel.height = JKTagH;
        [self.topView addSubview:tagLabel];
    }
    //布局发生变化后 重新调用 layoutSubviews
    [self setNeedsLayout];
    
}


//算尺寸应该在这里算
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i<self.tagLabelArray.count; i++) {
        UILabel *tagLabel = self.tagLabelArray[i];
        
        //设置位置
        if (i == 0) {
            tagLabel.x = 0;
            tagLabel.y = 0;
        }else{//后面的按钮
            UILabel *lastTagLabel = self.tagLabelArray[i - 1];
            //当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame)+JKTagMargin;
            //计算当前行剩余的宽度
            CGFloat rightWidth = self.topView.width - CGRectGetMaxX(lastTagLabel.frame)-JKTagMargin;
            if (rightWidth >= tagLabel.width) {//放在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            }else{//放到下一行
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + JKTagMargin;
                tagLabel.x = 0;
            }
        }
        
    }
    
    //更新textfield的frame 如果尾部可以剩下100 就放进去
    UILabel *lastTagLabel = self.tagLabelArray.lastObject;
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + JKTagMargin;
    if (self.topView.width - leftWidth > self.addBtn.width) {
        self.addBtn.x = leftWidth;
        self.addBtn.y = lastTagLabel.y;
    }else{
        self.addBtn.x = 0;
        self.addBtn.y = CGRectGetMaxY(lastTagLabel.frame)+JKTagMargin;
    }
    
    CGFloat oldHeight = self.height;
    
    self.height = CGRectGetMaxY(self.addBtn.frame)+45;
    self.y += oldHeight - self.height;
    
    
}
@end
