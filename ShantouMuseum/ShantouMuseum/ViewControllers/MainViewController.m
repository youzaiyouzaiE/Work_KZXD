//
//  MainViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/5.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "MainViewController.h"
#import "ChannelTree.h"
#import "JSONKit.h"
#import "Image.h"
#import "ContentNode.h"
#import "TrunkViewController.h"
#import "LeafListViewController.h"
#import "ScanBarViewController.h"

#import "WebContentViewController.h"
#import "JHCollectionViewReorderableTripletLayout.h"

@interface MainViewController () <JHCollectionViewDelegateReorderableTripletLayout, JHCollectionViewReorderableTripletLayoutDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate> {
    
    ChannelTree *selectChannel;
    NSArray *arrayLeafs;
}

@property (weak, nonatomic) IBOutlet UICollectionView *controllerView;

@property (nonatomic, strong) ChannelTree *fristChannelTree;
@property (strong, nonatomic) NSMutableArray *arrayCurrenTree;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;

    
//    if (![[UITools getInstancet] hasTheFileInDirectory:WebImageDocmentName] && internetReachableFoo.isReachableViaWWAN) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"移动网络下浏览会耗费大量流量，建议切换至wifi环境" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//        [alert show];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.arrayCurrenTree == nil && ![[AppData sharedInstance].internetReachableFoo isReachable]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请确认设备已联接到网络后，点击 '更新' 键重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:50.0f/255.0f blue:42.0f/255.0f alpha:0.5];///backGround coloud
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];/////titletTextColor
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"汕头海关网上关史陈列馆";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle: @"扫描"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(scanBarAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(updateTree:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    ChannelTree *fristChannel = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"RootChannel"];
    if (!fristChannel) {
        [self loadDate];
    } else {
        self.arrayCurrenTree = fristChannel.children;
        self.fristChannelTree = fristChannel;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
        return YES;
}

#pragma mark -actionPerform
- (void)updateTree:(id)sender {
    if ([AppData sharedInstance].internetReachableFoo.isReachable) {////有网络
        [self loadDate];
    } else {
        [[UITools getInstancet] showAlertViewTitle:@"提示" message:@"请确定已联接到网后再试"];
    }
}

- (void)scanBarAction:(id)sender
{
    ScanBarViewController *scanBarVC = [[ScanBarViewController alloc] init];
    [self.navigationController pushViewController:scanBarVC animated:YES];
}

#pragma mark - netWork
- (void)loadDate {
    MBProgressHUD *hud = [[UITools getInstancet] showLoadingViewAddToView:self.view autoHide:NO];
    [RequestWrapper getRequestWithURL:REQUEST_CHANNEL_URL_STR
                    withParameters:nil
                           success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                               NSTimeInterval delayTime = 0.5f;
                               NSString *responsString = operation.responseString;
                               NSArray *arry = [responsString objectFromJSONString];
                               self.fristChannelTree = [[ChannelTree alloc] init];
                               self.fristChannelTree.name = @"汕头海关网上关史陈列馆";
                               self.fristChannelTree.lengs = 0;
                               self.fristChannelTree.isLeaf = NO;
                               self.fristChannelTree.hasContent = YES;
                               self.fristChannelTree.parent = nil;
                               [self childrenContentsWithArray:arry andChannelParent:_fristChannelTree];
                               _arrayCurrenTree = self.fristChannelTree.children;
                               [[NSUserDefaults standardUserDefaults] rm_setCustomObject:_fristChannelTree forKey:@"RootChannel"];
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [self.controllerView reloadData];
                               });
                               [hud hide:YES];
                               [[UITools getInstancet] showMessageToView:self.view message:@"加载完成" autoHide:YES];
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               [hud hide:YES];
                               [[UITools getInstancet] showMessageToView:self.view message:@"请求出错" autoHide:YES];
                           }];
}

#pragma mark - 数据处理
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

#pragma mark -RACollectionViewDelegateTripletLayout
- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView{
    return UIEdgeInsetsMake(10, 16, 20, 16);
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView {
    return 10;
}
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    return 20;
}
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView {
    return 20;
}

#pragma mark - JHCollectionViewReorderableTripletLayoutDataSource

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     NSLog(@"数组里内容是：%@",_arrayCurrenTree);
    return self.arrayCurrenTree.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuseIdentifierItem";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UILabel *titleLable = (UILabel *)[cell viewWithTag:1];
    if (SCREEN_H < 482) {///iPhone4 and 4s
        titleLable.font = [UIFont systemFontOfSize:12];
    }
    ChannelTree *node = self.arrayCurrenTree[indexPath.row];
    titleLable.text = node.name;
//    titleLable.text = self.arrayCurrenTree[indexPath.row];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /////是叶节点的解析，不是叶节点的创建 径VC (truncalVC)
    selectChannel = self.arrayCurrenTree[indexPath.row];
    if (selectChannel.isLeaf) {
        arrayLeafs = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:LEAF_USER_DEFAULT(selectChannel.id_string)];
        NSLog(@"是叶节点");
        if (arrayLeafs == nil ) {
            [self checkChannelContentFormServer:selectChannel.id_string];
        } else {
            [self performSegueWithIdentifier:@"MainPushToLeafVC" sender:self];
        }
    } else {
//        NSLog(@"不是叶节点，有%ld个子节点",selectChannel.children.count);
        [self performSegueWithIdentifier:@"MainPushToTrunkVC" sender:self];
    }
}


#pragma mark -
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
                                arrayLeafs = [self analysisDataFormJsonString:responsString];
                                [[NSUserDefaults standardUserDefaults] rm_setCustomObject:arrayLeafs forKey:LEAF_USER_DEFAULT(channelID)];
                                [self performSegueWithIdentifier:@"MainPushToLeafVC" sender:self];
                                [hud hide:YES];
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [hud hide:YES];
                                  [[UITools getInstancet] showMessageToView:self.view message:@"请求出错" autoHide:YES];
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
    if ([segue.identifier isEqualToString:@"MainPushToTrunkVC"]) {
        TrunkViewController *trunkVC = (TrunkViewController *)segue.destinationViewController;
        trunkVC.arrayChannels = selectChannel.children;
    } else if ([segue.identifier isEqualToString:@"MainPushToLeafVC"]) {
        LeafListViewController *leafVC = (LeafListViewController *)segue.destinationViewController;
        leafVC.arrayContents = arrayLeafs;
        leafVC.fatherChannel = selectChannel;
    }
    
}


@end
