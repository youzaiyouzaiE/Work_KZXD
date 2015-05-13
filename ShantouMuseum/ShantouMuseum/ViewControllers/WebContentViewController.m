//
//  WebContentViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/13.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "WebContentViewController.h"
#import "ContentNode.h"

@interface WebContentViewController ()<UIWebViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _nodeLeaf.title;
    [self.webView loadHTMLString:_nodeLeaf.txt baseURL:nil];
    self.webView.scalesPageToFit = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
     NSLog(@"error :%@",error.description);
}

@end
