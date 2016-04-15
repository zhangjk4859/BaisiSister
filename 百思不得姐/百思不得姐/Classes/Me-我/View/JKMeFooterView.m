//
//  JKMeFooterView.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/6.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKMeFooterView.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "JKSquareModel.h"
#import <UIButton+WebCache.h>
#import "JKSquareButton.h"
#import "JKWebViewController.h"
@interface JKMeFooterView()
@property(nonatomic,strong)NSArray *squareArray;
@end

@implementation JKMeFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //self.height = 500;
        self.backgroundColor = [UIColor clearColor];
        [self downloadData];
    }
    return self;
}

-(void)downloadData
{

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"]=@"square";
        params[@"c"]=@"topic";
        
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
            
            self.squareArray = [JKSquareModel mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
           // NSLog(@"%@",responseObject);
            //有了数据创建方块
            [self creatSquare:self.squareArray];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            
        }];
        


}

//返回数据成功的时候，创建方块
-(void)creatSquare:(NSArray *)squares
{
    int maxColumn = 4;
    
    CGFloat buttonW =JKScreenW / maxColumn;
    CGFloat buttonH = buttonW;
    for (int i = 0; i < squares.count; i++) {
        JKSquareModel * model = squares[i];
        
        JKSquareButton *btn = [JKSquareButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.model = model;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        int col = i % maxColumn;
        int row = i / maxColumn;
        
        btn.x = col * buttonW;
        btn.y = row * buttonH;
        btn.width = buttonW;
        btn.height = buttonH;
        //self.height = CGRectGetMaxY(btn.frame);
    }
   
    
    
    NSUInteger  rows = (squares.count+maxColumn-1)/maxColumn;
    self.height = rows * buttonH;
    
    //NSLog(@"%f",self.height);
    [JKNoteCenter postNotificationName:JKFooterViewHeightChangedNotification object:self];
    
    //延时网络下载以后重绘图片
    [self setNeedsDisplay];
}

-(void)buttonClick:(JKSquareButton *)button
{
    if (![button.model.url hasPrefix:@"http"]) return;
    JKWebViewController *vc = [[JKWebViewController alloc]init];
    vc.url = button.model.url;
    vc.title = button.model.name;
    
   UITabBarController *tabVC  = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
   UINavigationController *nav =(UINavigationController *)tabVC.selectedViewController;
    [nav pushViewController:vc animated:YES];
    
}

//画一个背景图片
//-(void)drawRect:(CGRect)rect
//{
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
//}

@end
