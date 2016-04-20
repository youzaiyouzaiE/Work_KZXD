//
//  TrunkViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/11.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "TrunkViewController.h"
#import "LeafListViewController.h"
#import "ChildTrunkViewController.h"
#import "ChannelTree.h"
#import "ContentNode.h"


@interface TrunkViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *arrayContentNodes;
    ChannelTree *selectChannel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) NSArray *arrayContentNodes;

@end

@implementation TrunkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ChannelTree *fristChannel = _arrayChannels[0];
    self.navigationItem.title = fristChannel.parent.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayChannels count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"onlyLabelsCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ChannelTree *treeNode = _arrayChannels[indexPath.row];
    cell.textLabel.text = treeNode.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    arrayContentNodes = nil;
    selectChannel = _arrayChannels[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectChannel.isLeaf) {
        arrayContentNodes = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:LEAF_USER_DEFAULT(selectChannel.id_string)];
        if (arrayContentNodes == nil) {
            [self checkChannelContentFormServer:selectChannel.id_string];
        } else if(arrayContentNodes.count != 0) {
            [self performSegueWithIdentifier:@"TrunkPushToLeafVC" sender:self];
        }
    } else {
        [self performSegueWithIdentifier:@"TrunkPushToChildTrunkVC" sender:self];
    }
}


#pragma mark - 从网络请求Leaf 里的数据
- (void)checkChannelContentFormServer:(NSString *)channelID
{
    if (![AppData sharedInstance].internetReachableFoo.isReachable) {
        [[UITools getInstancet] showAlertViewTitle:@"提示" message:@"请确定已联接到网后再试"];
        return;
    }
    MBProgressHUD *hud = [[UITools getInstancet] showLoadingViewAddToView:self.view autoHide:NO];
    NSLog(@"%@",REQUEST_CONTENT_URL_STR(channelID));
    [RequestWrapper getRequestWithURL:REQUEST_CONTENT_URL_STR(channelID)
                       withParameters:nil
                              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                  NSString *responsString = operation.responseString;
                                  arrayContentNodes = [self analysisDataFormJsonString:responsString];
                                  [[NSUserDefaults standardUserDefaults] rm_setCustomObject:arrayContentNodes forKey:LEAF_USER_DEFAULT(channelID)];
                                  [self performSegueWithIdentifier:@"TrunkPushToLeafVC" sender:self];
                                  [hud hide:YES];
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [hud hide:YES];
                                  [[UITools getInstancet] showMessageToView:self.view message:@"请求出错" autoHide:YES];
                                  NSLog(@"获取数据 fault");
                              }];
}

#pragma mark - 解析叶子的数据
- (NSArray *)analysisDataFormJsonString:(NSString *)jsonStr {
    NSMutableArray *objArray = [NSMutableArray array];
    NSArray *arry = [jsonStr objectFromJSONString];
    for (NSDictionary *dic in arry) {
        ContentNode *node = [[ContentNode alloc] initWithDictionary:dic];
        if ([dic objectForKey:@"imgs"]) {
            NSArray *imgsArray = dic[@"imgs"];
            for (NSDictionary *imgDic in imgsArray) {
                Image *image = [[Image alloc] initWithDictionary:imgDic];
                [node addImage:image];
            }
        }
        [objArray addObject:node];
    }
    return objArray;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TrunkPushToLeafVC"]) {
        LeafListViewController *leafVC = (LeafListViewController *)segue.destinationViewController;
        leafVC.arrayContents = arrayContentNodes;
        leafVC.fatherChannel = selectChannel;
    } else if ([segue.identifier isEqualToString:@"TrunkPushToChildTrunkVC"]) {
        ChildTrunkViewController *childTrunkVC = (ChildTrunkViewController *)segue.destinationViewController;
        childTrunkVC.arrayChannels = selectChannel.children;
    }
}

- (void)dealloc
{
     NSLog(@"me dealloced");
}

@end
