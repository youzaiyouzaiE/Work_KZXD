//
//  MainViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/5.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "MainViewController.h"
#import "CollectionTripletLayout.h"
#import "ChannelTree.h"
#import "JSONKit.h"
#import "WelcomeViewController.h"
#import "Image.h"
#import "ContentNode.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

#import "TrunkViewController.h"
#import "LeafListViewController.h"

@interface MainViewController () <CollectionViewDelegateTripletLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIWebViewDelegate,wecomViewControllDelegate> {
    
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
//     NSLog(@"%@",self.fristChannelTree.name);
    
    
    [UITools setNavigationLeftButtonTitle:nil leftAction:nil rightBtnStr:nil rightAction:nil rightBtnSelected:nil navigationTitleStr:@"汕头海关网上关史陈列馆" forViewController:self];
    self.navigationItem.title = @"汕头海关网上关史陈列馆";
}

- (void)loadView {
    [super loadView];
    if (self.arrayCurrenTree == nil) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WelcomeViewController *welcomeVC = (WelcomeViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        welcomeVC.delegate = self;
        [self.navigationController pushViewController:welcomeVC animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)getDataFormServer:(NSMutableArray *)nodeArray andFristNode:(ChannelTree *)fristNode{
    self.arrayCurrenTree = nodeArray;
    self.fristChannelTree = fristNode;
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
                               self.fristChannelTree = [[ChannelTree alloc] init];
                               self.fristChannelTree.name = @"汕头海关网上关史陈列馆";
                               self.fristChannelTree.lengs = 0;
                               self.fristChannelTree.isLeaf = NO;
                               self.fristChannelTree.hasContent = YES;
                               self.fristChannelTree.parent = nil;
                               [self childrenContentsWithArray:arry andChannelParent:_fristChannelTree];
                               _arrayCurrenTree = self.fristChannelTree.children;
//                                NSLog(@"Current tree :%@",arrayCurrenTree);
//                               for (id node in arrayCurrenTree) {
//                                   if ([node isKindOfClass:[ChannelTree class]]) {
//                                        NSLog(@"node is channelTree");
//                                       ChannelTree *tree = (ChannelTree *)node;
//                                        NSLog(@"name is :%@",tree.name);
//                                   } else
//                                        NSLog(@"what is node ??");
//                                   
//                               }
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [self.controllerView reloadData];
                               });
                               
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"fault");
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
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView {
    return 10;
}
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    return 10;
}
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView {
    return 20;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//     NSLog(@"数组里内容是：%@",_arrayCurrenTree);
    return self.arrayCurrenTree.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuseIdentifierItem";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UILabel *titleLable = (UILabel *)[cell viewWithTag:1];
    if (SCREEN_H < 482) {///iPhone4 and 4s
        titleLable.frame = CGRectMake(titleLable.frame.origin.x, titleLable.frame.origin.y, titleLable.frame.size.width - 5, titleLable.frame.size.height);
        titleLable.font = [UIFont systemFontOfSize:12];
    }
   
    ChannelTree *node = self.arrayCurrenTree[indexPath.row];
    titleLable.text = node.name;
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
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
        NSLog(@"不是叶节点，有%ld个子节点",selectChannel.children.count);
        [self performSegueWithIdentifier:@"MainPushToTrunkVC" sender:self];
    }
    
//    if (selectChannel.hasContent) {
//         NSLog(@"有文章,要显示 html ? ");
//    } else {
//         NSLog(@"没有文章，要显示 txt, \ntext:%@",selectChannel.text);
//    }
}


#pragma mark -
- (void)checkChannelContentFormServer:(NSString *)channelID
{
    NSLog(@"%@",REQUEST_CONTENT_URL_STR(channelID));
    [RequestWrapper getRequestWithURL:REQUEST_CONTENT_URL_STR(channelID)
                       withParameters:nil
                              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                  NSString *responsString = operation.responseString;
                                 arrayLeafs = [self analysisDataFormJsonString:responsString];
                                [[NSUserDefaults standardUserDefaults] rm_setCustomObject:arrayLeafs forKey:LEAF_USER_DEFAULT(channelID)];
                                [self performSegueWithIdentifier:@"MainPushToLeafVC" sender:self];
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
