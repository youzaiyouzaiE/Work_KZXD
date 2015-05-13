//
//  WelcomeViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/10.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "WelcomeViewController.h"
//#import "MainViewController.h"
#import "ChannelTree.h"
#import "JSONKit.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface WelcomeViewController () {
    ChannelTree *fristChannel;
}

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    fristChannel = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"RootChannel"];
    if (fristChannel == nil) {
        [self loadDate];
    } else {
        [self.delegate getDataFormServer:fristChannel.children andFristNode:fristChannel];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDate
{
    [RequestWrapper getRequestWithURL:REQUEST_CHANNEL_URL_STR
                       withParameters:nil
                              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                  NSTimeInterval delayTime = 0.5f;
                                  NSString *responsString = operation.responseString;
                                  NSArray *arry = [responsString objectFromJSONString];
                                  fristChannel = [[ChannelTree alloc] init];
                                  fristChannel.name = @"汕头海关网上关史陈列馆";
                                  fristChannel.lengs = 0;
                                  fristChannel.isLeaf = NO;
                                  fristChannel.hasContent = YES;
                                  fristChannel.parent = nil;
                                  [self childrenContentsWithArray:arry andChannelParent:fristChannel];
                                  [[NSUserDefaults standardUserDefaults] rm_setCustomObject:fristChannel forKey:@"RootChannel"];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      [self.delegate getDataFormServer:fristChannel.children andFristNode:fristChannel];
                                      [self.navigationController popViewControllerAnimated:NO];
                                  });
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"fault");
                              }];
}

- (void)childrenContentsWithArray:(NSArray *)jsonary andChannelParent:(ChannelTree *)parentChannel {
    for (NSDictionary *dictionary in jsonary) {
        ChannelTree *childChannel = [[ChannelTree alloc] initWithDictionary:dictionary];
        childChannel.lengs = parentChannel.lengs +1;
        childChannel.parent = parentChannel;
        [parentChannel addChild:childChannel];
        if (!childChannel.isLeaf) {
            [self childrenContentsWithArray:[dictionary objectForKey:@"childrens"] andChannelParent:childChannel];
        }
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"PushToMainViewController"]) {
//        MainViewController *mainVC = segue.destinationViewController;
//        mainVC.fristChannelTree = fristChannelTree;
//        mainVC.arrayCurrenTree = arrayCurrenTree;
//    }
}


@end
