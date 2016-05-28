//
//  JKCommentViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKCommentViewController.h"
#import "JKTopicCell.h"
#import "JKTopicModel.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "JKCommentModel.h"
#import "JKCommentCell.h"

static NSString * const    JKCommentID = @"comment";

@interface JKCommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *hotCommentArray;
@property(nonatomic,strong)NSMutableArray *lastestCommentArray;
@property(nonatomic,strong)JKCommentModel *top_cmts;
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSIndexPath *selectedRow;
/**
 *  记录当前页码
 */
@property(nonatomic,assign)NSInteger page   ;
@end

@implementation JKCommentViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
//- (NSArray *)hotCommentArray
//{
//    if (!_hotCommentArray) {
//        _hotCommentArray = [NSArray array];
//    }
//    return _hotCommentArray;
//}

//因为是可变的，所以用懒加载 直接赋值可以不用懒加载
//- (NSMutableArray *)lastestCommentArray
//{
//    if (!_lastestCommentArray) {
//        _lastestCommentArray = [NSMutableArray array];
//    }
//    return _lastestCommentArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupHeader];
    [self setupRefresh];

    
    
    
}

-(void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    //一进来就加载数据
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    
    //第一次进来就隐藏，因为没有数据
    self.tableView.mj_footer.hidden = YES;
}
//加载更多数据
-(void)loadMoreComments
{
    //结束之前所有的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    
    //先把页码取出来加工，成功了再赋值
    NSInteger page = self.page;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] =@"dataList";
    params[@"c"] =@"comment";
    params[@"data_id"] = self.model.ID;
    page ++;
    params[@"page"] = @(page);
    JKCommentModel *commentModel = [self.lastestCommentArray lastObject];
    params[@"lastcid"] = commentModel.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]])
        {
            //说明底部没有数据
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        NSArray *newCommentArray = [JKCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.lastestCommentArray addObjectsFromArray:newCommentArray];
        
        
        //表格刷新数据
        [self.tableView reloadData];
        
        //数据满了，就不显示，数据不满，就结束刷新
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.lastestCommentArray.count >= total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        //数据加载成功，页码再加一页
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

//加载最新数据 下拉
-(void)loadNewComments
{
    //结束之前所有的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] =@"dataList";
    params[@"c"] =@"comment";
    params[@"data_id"] = self.model.ID;
    params[@"hot"] = @"1";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        //返回来是字典才处理，没数据会返回一个空数组
        if (![responseObject isKindOfClass:[NSDictionary class]])
        {
            //说明底部没有数据
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
        //[responseObject writeToFile:@"/Users/kevin/Desktop/comment.plist" atomically:YES];
        self.hotCommentArray = [JKCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.lastestCommentArray = [JKCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //不管成功还是失败，都要结束刷新
        [self.tableView.mj_header endRefreshing];
        //表格刷新数据
        [self.tableView reloadData];
        
        //数据第一次就加载完毕 关闭脚的显示
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.lastestCommentArray.count >= total) {
            self.tableView.mj_footer.hidden = YES;
        }
        
        //下拉刷新成功以后，让页码等于第一页
        self.page =1;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)setupHeader
{
    //为了不让tableview不动cell的frame，就在cell外层包装一层view
    UIView *view = [[UIView alloc]init];
    
    
    JKTopicCell *cell = [JKTopicCell cell];
    //让cell有数据
    //先清空
    self.top_cmts = self.model.top_cmt;
    self.model.top_cmt = nil;
    //清零以后，因为是懒加载，所以会重算一遍，所以下面给出去的是重算后的高度
    [self.model setValue:@0 forKey:@"cellHeight"];
    cell.topicModel = self.model;
    cell.size = CGSizeMake(JKScreenW, self.model.cellHeight);
    [view addSubview:cell];
    //包装view的height
    view.height = cell.height + JKTopicCellMargin*2;
    
    
    self.tableView.tableHeaderView = view;
}

-(void)setupBasic
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    //添加一个通知中心，来监听键盘的弹出,然后做动作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //算表格的高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //设置表格背景色
    self.tableView.backgroundColor = JKGlobalbg;
    //注册xibcell 表格注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKCommentCell class]) bundle:nil] forCellReuseIdentifier:JKCommentID];
    
    //给底部添加间距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, JKTopicCellMargin, 0);
}

-(void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //为了适配，应该 用屏幕的高度减去键盘的Y值
    self.bottomSpace.constant = JKScreenH - frame.origin.y;
    
    // 改变高度的时候要执行动画，不然会很突兀
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        //改变了布局 要强制布局一下
        [self.view layoutIfNeeded];
    }];
}


//当控制器销毁的时候，要清除通知中心，不然会有很严重的后果
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //如果有值，再赋予回去
    if (self.top_cmts) {
        self.model.top_cmt = self.top_cmts;
        [self.model setValue:@0 forKey:@"cellHeight"];
    }
    
    //退出时取消所有网络任务
    [self.manager invalidateSessionCancelingTasks:YES];
    
}




//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}



#pragma tableView delegate
//同时也遵循了scrollView的协议 所有有方法,滚动的时候收回键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark tableView datasource
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotCommentArray.count;
    NSInteger lastestCount = self.lastestCommentArray.count;
    //要判断，如果有热门评论，就返回热门评论的个数，没有就直接返回最新评论个数
    if (section == 0) {
        return hotCount ? hotCount:lastestCount;
        
    }
    tableView.mj_footer.hidden = (lastestCount == 0);
    
    return lastestCount;
    
}


//多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotCommentArray.count;
    NSInteger lastestCount = self.lastestCommentArray.count;
    
    if (hotCount) return 2;
    if (lastestCount) return 1;
    return 0;
}
//每组的标题
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSInteger hotCount = self.hotCommentArray.count;
//    //rNSInteger lastestCount = self.lastestCommentArray.count;
//    //要判断，如果有热门评论，就返回热门评论的个数，没有就直接返回最新评论个数
//    if (section == 0) {
//        return hotCount ? @"最热评论":@"最新评论";
//    
//    }
//    return @"最新评论";
//}

//自定义头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = JKGlobalbg;
    
    UILabel *label = [[UILabel alloc]init];
    [headView addSubview:label];
    //label.backgroundColor = [UIColor redColor];
    label.width = 200;
    label.x = JKTopicCellMargin;
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    label.textColor = JKRGBColor(67, 67, 67);
   
    NSInteger hotCount = self.hotCommentArray.count;
    if (section == 0) {
        label.text =  hotCount ? @"最热评论":@"最新评论";
        
    }else{
        label.text = @"最新评论";
    }
    
    
    return headView;
}

//抽出一个方法进行判断第几组
-(NSArray *)commentArrayInSection:(NSInteger)section
{
    if (section == 0) {
        return  self.hotCommentArray.count?self.hotCommentArray:self.lastestCommentArray;
    }
    return self.lastestCommentArray;
}
    

//每一行显示什么
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:JKCommentID];
    
    
    JKCommentModel *model = [self commentArrayInSection:indexPath.section][indexPath.row];
    cell.model = model;
    
    return cell;
}

// 选中cell的时候做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建menuController
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    if (menuVC.isMenuVisible) {// 如果正在显示，就不显示，返回
        [menuVC setMenuVisible:NO animated:YES];
        return;
    }else{
        JKCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        CGRect frame = CGRectMake(0, cell.height*0.5, cell.width, cell.height*0.5);
        [menuVC setTargetRect:frame inView:cell];
        [menuVC setMenuVisible:YES animated:YES];
        //让cell成为第一响应者
        [cell becomeFirstResponder];
        
        //添加item
        UIMenuItem *ding = [[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc]initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(report:)];
        menuVC.menuItems = @[ding,replay,report];
    }
    
    
    
    
}
//实现三个方法
-(void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
   JKCommentModel * model = [self commentArrayInSection:indexPath.section][indexPath.row];
    NSLog(@"%@,%ld",model.content,(long)indexPath.row);
    
}
-(void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    JKCommentModel * model = [self commentArrayInSection:indexPath.section][indexPath.row];
    NSLog(@"%@,%ld",model.content,(long)indexPath.row);
    
}-(void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    JKCommentModel * model = [self commentArrayInSection:indexPath.section][indexPath.row];
    NSLog(@"%@,%ld",model.content,(long)indexPath.row);
    
}

//做一个修改的测试

@end
