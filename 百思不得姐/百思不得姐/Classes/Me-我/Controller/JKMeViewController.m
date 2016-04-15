//
//  JKMeViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKMeViewController.h"
#import "JKMeCell.h"
#import "JKMeFooterView.h"
#import "JKSettingViewController.h"


@interface JKMeViewController ()

@end

static NSString * cellID = @"me";
@implementation JKMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];

    

}

-(void)setupTableView
{
    //注册cell
    [self.tableView registerClass:[JKMeCell class] forCellReuseIdentifier:cellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //调整头尾的视图的高度
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = JKTopicCellMargin;
    
    self.tableView.tableFooterView =[[JKMeFooterView alloc]init];
    //可显示的内容区域
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
    //添加通知中心
    [JKNoteCenter addObserver:self selector:@selector(layoutContentInset:) name:JKFooterViewHeightChangedNotification object:nil];
}

-(void)layoutContentInset:(NSNotification *)note
{
    //[self.tableView layoutIfNeeded];
    
    
    JKMeFooterView *footerView = note.object;
    //self.tableView.contentSize = CGSizeMake(JKScreenW, footerView.frame.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, footerView.frame.size.height+29, 0);
}

-(void)setupNav
{
    //中间标题
    self.navigationItem.title = @"我的";
    
    //右边按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
    self.view.backgroundColor = JKGlobalbg;
}


-(void)moonClick
{
    JKLogFunc;
}

-(void)settingClick
{
    JKSettingViewController *settingVC = [[JKSettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

#pragma mark table View delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKMeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"header_cry_icon"];
    }else{
        cell.textLabel.text = @"离线下载";
    }
    
    
    
    return cell;
}
@end
