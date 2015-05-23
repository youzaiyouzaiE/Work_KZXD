//
//  WebContentViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/13.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "WebContentViewController.h"
#import "ContentNode.h"
#import "TFHpple.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WebContentViewController ()<UIWebViewDelegate> {
    NSMutableArray *arrayImgUrlStr;
//    NSString *urlString;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebContentViewController

- (void)loadView {
    [super loadView];

//    TFHppleElement * element = [tdElements objectAtIndex:0];
//    NSString *text = [element text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayImgUrlStr = [NSMutableArray array];
    self.navigationItem.title = _nodeLeaf.title;
    
    NSString *htmlString = _nodeLeaf.txt;
    NSData *htmlDat = [_nodeLeaf.txt dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:htmlDat];
    NSArray *tdElements = [hpple searchWithXPathQuery:@"//img"];
    for (TFHppleElement *element in tdElements) {
        NSDictionary *attributes = element.attributes;
        NSString *urlStr = [attributes objectForKey:@"src"];
        [arrayImgUrlStr addObject:urlStr];
    }
    
    NSString *documentPath = [[UITools getInstancet] pathForDocumentName:WebImageDocmentName];
//    NSArray *arrayImages = [UITools getFilesInDocumentPath:documentPath];
    for (NSString *imgUrl in arrayImgUrlStr) {
        NSString *imagPath = [documentPath stringByAppendingPathComponent:imgUrl];
        NSString *urlStr = IMAGE_ROAD_URL_STR(imgUrl);
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagPath]) {
            [htmlString stringByReplacingOccurrencesOfString:imgUrl withString:imagPath];
        } else {
            [htmlString stringByReplacingOccurrencesOfString:imgUrl withString:urlStr];
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:urlStr]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
             }
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (image && finished)
                 {
                     if ([[UITools getInstancet] saveImageToFileParth:documentPath image:image inFileName:imgUrl]) {
                          NSLog(@"save success");
                     }
                 }
             }];
        }
    }

    [self.webView loadHTMLString:htmlString baseURL:nil];
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
