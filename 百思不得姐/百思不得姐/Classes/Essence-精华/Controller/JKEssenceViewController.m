//
//  JKEssenceViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKEssenceViewController.h"

#import "JKRecommendTagViewController.h"

#import "JKTopicController.h"




@interface JKEssenceViewController ()<UIScrollViewDelegate>

@property(nonatomic,weak)UIView *indicatorView;

//记录当前选中的按钮
@property(nonatomic,weak)UIButton *selectedButton;

//记录顶部所有的标签
@property(nonatomic,weak)UIView *titleView;

//拿到contentView
@property(nonatomic,weak)UIScrollView *contentView;

@end

@implementation JKEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    [self setupNav];
    
    //添加五个子控制器 先添加，让知道数量
    [self setupChildViewcontrollers];

    //设置顶部按钮
    [self setupTitlesView];
    
    
    
    //设置底部scrollView
    [self setupContentView];
    


  

}

//添加五个子控制器
-(void)setupChildViewcontrollers
{
    
    JKTopicController *word = [[JKTopicController alloc]init];
    [self addChildViewController:word];
    word.title = @"文字";
    word.type = JKTopicTypeWord;
    
    JKTopicController *all = [[JKTopicController alloc]init];
    [self addChildViewController:all];
    all.title = @"全部";
    all.type = JKTopicTypeALL;
    
    JKTopicController *video = [[JKTopicController alloc]init];
    [self addChildViewController:video];
    video.title = @"视频";
    video.type = JKTopicTypeVideo;
    
    JKTopicController *voice = [[JKTopicController alloc]init];
    [self addChildViewController:voice];
    voice.title = @"音频";
    voice.type = JKTopicTypeVoice;
    
    JKTopicController *picture = [[JKTopicController alloc]init];
    [self addChildViewController:picture];
    picture.title = @"图片";
    picture.type = JKTopicTypePicture;
    
    
    

    

    

    

    

    
    
}



/**
 *  设置底部scrollView
 */
-(void)setupContentView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
   
    contentView.frame = self.view.bounds;
    contentView.pagingEnabled = YES;
    
    [self.view insertSubview:contentView atIndex:0];
    
    //设置内部视图大小
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    contentView.delegate = self;
    self.contentView = contentView;
    
    //默认加载第一页tableView数据
    [self scrollViewDidEndScrollingAnimation:contentView];

}

/**
 *  设置顶部标题栏
 */
-(void)setupTitlesView
{
    //创建view
    UIView *titlevView = [[UIView alloc]init];
    titlevView.width = self.view.width;
    titlevView.y = JKTitleViewY;
    titlevView.height = JKTitleViewH;
    titlevView.backgroundColor =[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:titlevView];
    self.titleView = titlevView;
    
    //创建指示条
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.y= titlevView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    
    //分布按钮

    CGFloat width = titlevView.width / 5;
    CGFloat height = titlevView.height;
    for (int i = 0; i < self.childViewControllers.count; i++)
    {
        UIButton * btn = [[UIButton alloc]init];
        btn.width = width;
        btn.height = height;
        btn.x = width * i;
        btn.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        //[btn layoutIfNeeded];//强制布局，更新子控件的frame
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlevView addSubview:btn];
        //默认第一个按钮选中
        if (i == 0) {
            btn.enabled = NO;
            self.selectedButton = btn;
            [btn.titleLabel sizeToFit];//让按钮内容自动适配
            //self.indicatorView.width = btn.titleLabel.width;
            self.indicatorView.width = [vc.title sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width;
            self.indicatorView.centerX = btn.centerX;
           
        }
    }
    
     //指示器放到最后面加，序号不会乱，保证按钮是从0开始的
    [titlevView addSubview:indicatorView];
    
}
/**
 *
 *
 *  按钮点击事件处理
 */
-(void)buttonClick:(UIButton *)button
{
    
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
   //先滚动，再加载数据
    
    CGPoint offset =  self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    
    [self.contentView setContentOffset:offset animated:YES];
}


/**
 *  设置导航
 */
-(void)setupNav
{
    //标题图片
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    self.view.backgroundColor = JKGlobalbg;
}
/**
 *  导航左侧按钮事件处理
 */
-(void)tagClick
{
    JKRecommendTagViewController *tableViewVC = [[JKRecommendTagViewController alloc]init];
    [self.navigationController pushViewController:tableViewVC animated:YES];
}


#pragma mark scrollView delegate
//设置完偏移量滚动就会调用这个方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    
    UITableViewController *vc  = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    

    
    [scrollView addSubview:vc.view];
}

//在手拖动减速完毕的时候加载数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //在拖动结束的时候模拟点击按钮
    
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    [self buttonClick:(UIButton *)self.titleView.subviews[index]];
}

@end
