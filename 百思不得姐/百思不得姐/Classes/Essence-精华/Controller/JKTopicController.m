//
//  JKTopicController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/29.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTopicController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>

#import "JKCommentViewController.h"

#import "JKNewViewController.h"


#import "JKTopicModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "JKTopicCell.h"
static NSString * const topicCellID = @"topic";

@interface JKTopicController ()

@property(nonatomic,strong)NSMutableArray *topics;

/**
 *  当前页码
 */
@property(nonatomic,assign)NSInteger currentPage;
/**
 *  本页参数
 */
@property(nonatomic,copy)NSString *maxtime;
/**
 *  存储请求参数
 */
@property(nonatomic,strong)NSDictionary *params;
/**
 *  记录当前选中控制器的索引
 */
@property(nonatomic,assign)NSInteger lastSelectIndex;
@end

@implementation JKTopicController


- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

//控制器接受到通知就进行刷新


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //进来以后先添加刷新控件
    [self setupRefresh];
    
    
    //设置表格内边距
    [self setupTableView];
    
    //注册cell
    //[[NSBundle mainBundle] loadNibNamed:<#(NSString *)#> owner:<#(id)#> options:<#(NSDictionary *)#>];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKTopicCell class]) bundle:nil] forCellReuseIdentifier:topicCellID];
}

//设置表格内边距
-(void)setupTableView
{
    
    CGFloat top = JKTitleViewY + JKTitleViewH;
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //清掉背景颜色才是控制器的主题颜色
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //在这里监听通知
    [JKNoteCenter addObserver:self selector:@selector(tabBarSelect) name:JKTabBarDidSelectedNotification object: nil];
}

//监听到通知以后要做的动作
-(void)tabBarSelect
{
    //如果连续点击两次，就进行刷新
    if (self.lastSelectIndex == self.tabBarController.selectedIndex && [self.view isShowOnKeywindow]) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    //记录这一次选中的索引
    self.lastSelectIndex = self.tabBarController.selectedIndex;
}

//进来以后先添加刷新控件
-(void)setupRefresh
{   //添加头部刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //一进来就开始刷新
    [self.tableView.mj_header beginRefreshing];
    //设置刷新好数据就变透明，用的时候显示
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    //添加底部刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    
    
}

-(NSString *)a
{
    return [self.parentViewController isKindOfClass:[JKNewViewController class]]?@"newlist":@"newlist";
}
//加载最新的前20条数据（下拉刷新）
-(void)loadNewTopics
{
    //如果下拉过程中，被上拉中断了，就要结束刷新，在上拉中结束掉
    
    //结束上拉刷新
    [self.tableView.mj_footer endRefreshing];
    //开始网络请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"]=self.a;
    params[@"c"]=@"data";
    params[@"type"]=@(self.type);
    self.params =params;
    
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
        // NSLog(@"%@",responseObject);
        //如果请求过程中被中断，就返回
        if (self.params != params) return ;
        
        //存储当前的maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        [responseObject writeToFile:@"/Users/kevin/Desktop/jkJson.plist" atomically:YES];
        //字典转模型
        self.topics = [JKTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //取到数据以后刷新表格
        [self.tableView reloadData];
        
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
        //数据成功以后，才能把当前页码置为零，否则，把页码置为零，但是数据没有成功，还是停留在第五页，再下来就从第二页开始了，不正常显示数据了 失败了以后，页码保持不动
        self.currentPage = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //如果请求过程中被中断，就返回
        if (self.params != params) return ;
        //失败了也结束头部刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
}

//加载更多的帖子数据(上拉加载)
-(void)loadMoreTopics
{
    //上拉就结束下拉
    [self.tableView.mj_header endRefreshing];
    
    //如果上拉的过程中，被下拉中断，就要结束上拉刷新
    
    //self.currentPage ++;
    //开始网络请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"]=self.a;
    params[@"c"]=@"data";
    params[@"type"]=@(self.type);
    NSInteger page = self.currentPage +1;
    params[@"page"]=@(page);
    params[@"maxtime"]=self.maxtime;
    self.params =params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
        
        //如果请求过程中被中断，就返回
        if (self.params != params) return ;
        //存储当前的maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //字典转模型
        NSArray * moreDataArray = [JKTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreDataArray];
        //取到数据以后刷新表格
        [self.tableView reloadData];
        
        //结束头部刷新
        [self.tableView.mj_footer endRefreshing];
        self.currentPage = page;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //如果请求过程中被中断，就返回
        if (self.params != params) return ;
        //失败了也结束头部刷新
        [self.tableView.mj_footer endRefreshing];
        
        //如果本次加载失败，数据没有回来，但是页码已经增加了一，下一次再加载，直接跳过去一页，所以当失败的时候，要把页码减回来
        //self.currentPage --;
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JKTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellID];
    
    cell.topicModel = self.topics[indexPath.row];
    
    return cell;
}

//定义cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    JKTopicModel * model = self.topics[indexPath.row];
    
    
    //返回这个模型对应的cell高度
    return model.cellHeight;
}

//设计选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKCommentViewController *commentVC = [[JKCommentViewController alloc]init];
    commentVC.model = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}


@end
