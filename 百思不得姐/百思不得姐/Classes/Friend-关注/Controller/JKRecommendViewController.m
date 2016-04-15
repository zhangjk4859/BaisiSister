//
//  JKRecommendViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/23.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKRecommendViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

#import "JKRecommedCategoryCell.h"

#import "JKRecommedCategory.h"
#import <MJExtension.h>

#import "JKRecommendUserCell.h"
#import "JKRecommendUser.h"

#import <MJRefresh.h>

//左边表格当前选中的类别模型
#define JKSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface JKRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  左边模型的数组
 */
@property(nonatomic,strong)NSArray *categories;
/**
 *  左边的表格
 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;



/**
 *  右边的数组
 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;


/**
 *  请求参数的字典
 */
@property(nonatomic,strong)NSMutableDictionary *params;

/**
 *  请求管理者
 */
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@end

@implementation JKRecommendViewController

static NSString * const JKCategoryID = @"category";
static NSString * const JKUserID = @"user";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) { //是空的就创建
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化控件
    [self setupTableView];
    
    //初始化MJ刷新控件
    [self setupRefresh];
    
    //显示圈圈等待
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self loadCategories];
}

//加载左边表格数据
-(void)loadCategories
{
    //开始网络请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"]=@"category";
    params[@"c"]=@"subscribe";
    
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // JKLog(@"%@",responseObject[@"list"]);
        
        
        //开始操作服务器返回的json数据 把服务器返回的字典的数组给到模型，再封装到一个数组里面
        self.categories = [JKRecommedCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //成功后隐藏进度
        [SVProgressHUD dismiss];
        //刷新数据
        [self.categoryTableView reloadData];
        
        //默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        //第一次进去就显示刷新状态
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        JKLog(@"%@",error);
        
        //显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败"];
        
    }];

}

//表格的初始化
-(void)setupTableView
{
    //注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKRecommedCategoryCell class]) bundle:nil] forCellReuseIdentifier:JKCategoryID];
    
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:JKUserID];
    
    //关闭自动调整tableview
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    
    self.userTableView.rowHeight = 70;
    
    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = JKGlobalbg;
}

//刷新控件的初始化
-(void)setupRefresh
{
    //添加头部刷新
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    //加载的时候 隐藏掉  没数据的时候隐藏掉，其余的时候显示出来
   
}

#pragma mark 加载更多用户数据

//检查footer状态
-(void)checkFooterState
{
    JKRecommedCategory * categoryModel = JKSelectedCategory;
    
    NSInteger usersCount = categoryModel.users.count;
    //没有数据的时候隐藏，有数据就显示出来
    self.userTableView.mj_footer.hidden = ( usersCount== 0);
    
    if (usersCount == categoryModel.total)
    {
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];//显示加载完毕
    }else{
        //停止刷新
        [self.userTableView.mj_footer endRefreshing];
    }
}

-(void)loadMoreUsers
{
    //把选中的类别模型取出来
    JKRecommedCategory * categoryModel = JKSelectedCategory;
    
    
    //开始网络请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"subscribe";
    params[@"category_id"]=@(categoryModel.ID);
    params[@"page"] = @(++categoryModel.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        JKLog(@"%@",responseObject);
        NSArray *users = [JKRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //把右边的数据模型组赋值到左边的单个模型
       
        [categoryModel.users addObjectsFromArray:users];
        
        //检查底部状态
        [self checkFooterState];
        
        if (self.params != params) return ;
        [self.userTableView reloadData];
        [SVProgressHUD dismiss];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.params != params) return ;
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"用户数据加载失败"];
        //停止刷新
        [self.userTableView.mj_footer endRefreshing];
        
    }];

}

#pragma mark 下拉加载最新数据
-(void)loadNewUsers
{
    JKRecommedCategory *m = JKSelectedCategory;
    //当第一次来到这里的时候，说明加载的是第一页，设置当前页为一
    m.currentPage = 1;
    
    [SVProgressHUD show];
    //开始网络请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"subscribe";
    params[@"category_id"]=[NSString stringWithFormat:@"%ld",(long)m.ID];
    params[@"page"] = @(m.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        // NSLog(@"%@",responseObject);
        NSArray *users = [JKRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //清除所有数据
        [m.users removeAllObjects];
        
        //把右边的数据模型组赋值到左边的单个模型
        m.users = [NSMutableArray arrayWithArray:users];
        
        //保存总数
        m.total = [responseObject[@"total"] integerValue];
       
        
        
        if (self.params != params) return ;
        [self.userTableView reloadData];
        [SVProgressHUD dismiss];
        
        //让头部结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        //让底部控件结束刷新
        //[self.userTableView.mj_footer endRefreshing];
        
        //检查底部状态
        [self checkFooterState];

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
       if (self.params != params) return ;
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"用户数据加载失败"];
        
        //失败的话结束头部刷新
        [self.userTableView.mj_header endRefreshing];
    }];

}

#pragma tableViewDataSource

//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     //左边的表格
    if (tableView == self.categoryTableView) return self.categories.count;
    
    //检查底部状态
    [self checkFooterState];
    
    //右边的表格
    return [JKSelectedCategory users].count;
    
}

//每一行显示什么
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {//左边的表格
        JKRecommedCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:JKCategoryID];
        
        JKRecommedCategory *categoryModel = self.categories[indexPath.row];
        cell.categoryModel = categoryModel;
        
        return cell;
    }else   //右边的表格
    {
        JKRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:JKUserID];
      
        cell.userModel = [JKSelectedCategory users][indexPath.row];
        
        
        return cell;
    }
}

#pragma tableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  
     1.目前只能显示一页数据
     2.重复发送请求，浪费用户流量
     3.如果网速慢，带来的一些细节问题
     开始03
     */
    
    //快速切换的时候，先结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    if (tableView == self.categoryTableView)
    {
        JKRecommedCategory *m = self.categories[indexPath.row];
        //    NSLog(@"%@",m.name);
        
       //有没有老数据的判断
        if (m.users.count)
        {
            [self.userTableView reloadData];
        } else
        {
            //马上刷新表格，目的是：马上显示当前category的用户数据，不让用户看到上一个category的残留数据
            [self.userTableView reloadData];
            
            //开始下拉刷新
            [self.userTableView.mj_header beginRefreshing];
            
        }//有没有老数据判断
        
     }//判断视图
    
}

-(void)dealloc
{
    //取消所有的网络请求
    [self.manager.operationQueue cancelAllOperations];
}

@end
