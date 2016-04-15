//
//  JKRecommendTagTableViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/25.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKRecommendTagViewController.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>

#import "JKRecommendTagCell.h"
#import "JKRecommendTagModel.h"
#import <MJExtension.h>



@interface JKRecommendTagViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *tagArray;

@end


static NSString * const JKTagID = @"tag";
@implementation JKRecommendTagViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐标签";
    
    //设置表格风格
    [self setupTableview];
    
    //开始下载数据
    [self downloadData];

}

-(void)setupTableview
{
    //设定行高
    self.tableView.rowHeight = 70;
    //把系统自带分割线取消掉
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = JKGlobalbg;
    
    //注册xib创建的cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:JKTagID];
    //取消右边的垂直滚动指示器
    self.tableView.showsVerticalScrollIndicator = NO;

}

-(void)downloadData
{
    //开启等待提示
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //开始网络请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"]=@"tag_recommend";
    params[@"action"]=@"sub";
    params[@"c"]=@"topic";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        JKLog(@"%@",responseObject);
        self.tagArray = [JKRecommendTagModel mj_objectArrayWithKeyValuesArray:responseObject];
        //加载数据完成记得刷新数据
        [self.tableView reloadData];
        //菊花消失
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        JKLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];

}



#pragma mark  UITableViewDataSource 
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.tagArray.count;
    return 10;
}
//每一行显示什么
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKRecommendTagCell * cell = [tableView dequeueReusableCellWithIdentifier:JKTagID];
   
    cell.x = 10;
    
    cell.tagModel = self.tagArray[indexPath.row];
    

    
    return cell;
}

#pragma mark  UITableViewDelegate

@end
