//
//  JKWebViewController.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/6.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKWebViewController.h"
#import <NJKWebViewProgress.h>

@interface JKWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *gobackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property(nonatomic,strong)NJKWebViewProgress *progress;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation JKWebViewController

- (IBAction)goback:(id)sender {
    [self.webView goBack];
}


- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webView.delegate =self.progress;
    __weak typeof (self) weakSelf = self;
    self.progress.progressBlock = ^(float progress){
        NSLog(@"%f",progress);
        weakSelf.progressView.progress =  progress;
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    //这里有bug 不显示进度，查看源代码
    self.progress.webViewProxyDelegate = self;
}

#pragma mark webView delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.gobackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

@end
