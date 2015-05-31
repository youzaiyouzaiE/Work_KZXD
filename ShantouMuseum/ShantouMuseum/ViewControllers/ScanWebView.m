//
//  ScanWebView.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/31.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "ScanWebView.h"
@interface ScanWebView ()<UIWebViewDelegate> {
    
}

@end

@implementation ScanWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}


- (void)backAction:(UIButton *)button {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

@end
