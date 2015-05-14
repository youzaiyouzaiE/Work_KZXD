//
//  LeafListViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/12.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "LeafListViewController.h"
#import "ContentNode.h"
#import "ChannelTree.h"
#import "WebContentViewController.h"
#import "UIImageView+WebCache.h"

@interface LeafListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    ContentNode *selectNod;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LeafListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _fatherChannel.name;
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
    return [_arrayContents count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentNode *currentNod = _arrayContents[indexPath.row];
    if (!currentNod.isImg && currentNod.contentImg.length > 2) {
        return 90;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = nil;
    BOOL isHasImage = NO;
     ContentNode *currentNod = _arrayContents[indexPath.row];
    if (!currentNod.isImg && currentNod.contentImg.length > 2) {
        cellIdentifier = @"imageAndLabelCell";
        isHasImage = YES;
    } else {
        cellIdentifier = @"onlyLabelsCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        if (isHasImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        } else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
   
    if (isHasImage) {//有图片
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:2];
        UILabel *labelDesction = (UILabel *)[cell viewWithTag:3];
        
//        NSString *imageStr = IMAGE_ROAD_URL_STR(currentNod.contentImg);
        [imageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_ROAD_URL_STR(currentNod.contentImg)]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      NSLog(@"图片加载完成！");
                                 }];
        labelTitle.text = currentNod.title;
        labelDesction.text = currentNod.desc;
        
    } else {
        cell.textLabel.text = currentNod.title;
        if (currentNod.isImg) {
            cell.imageView.backgroundColor = [UIColor yellowColor];
        }
    }
    return cell;
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectNod = _arrayContents[indexPath.row];
    if (selectNod.isHtml) {
        [self performSegueWithIdentifier:@"LeafPushToWebVC" sender:self];
    }
    if (selectNod.isImg) {
         NSLog(@"显示 imgs = %ld",[selectNod.images count]);
    } else {
         NSLog(@"显示 图片%@",selectNod.contentImg);
    }
}

#pragma mark -
- (void)checkChannelContentFormServer:(NSString *)channelID
{
    /////存到本地文件，本地没有再从服务器取出来
    NSLog(@"%@",REQUEST_CONTENT_URL_STR(channelID));
    [RequestWrapper getRequestWithURL:REQUEST_CONTENT_URL_STR(channelID)
                       withParameters:nil
                              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                  NSString *responsString = operation.responseString;
//                                  arrayLeafs = [self analysisDataFormJsonString:responsString];
//                                  [[NSUserDefaults standardUserDefaults] rm_setCustomObject:arrayLeafs forKey:LEAF_USER_DEFAULT(channelID)];
//                                  [self performSegueWithIdentifier:@"MainPushToLeafVC" sender:self];
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
        if ([dic objectForKey:@"img"]) {
            NSArray *imgsArray = dic[@"img"];
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
    if ([segue.identifier isEqualToString:@"LeafPushToWebVC"]) {
        WebContentViewController *webVC = (WebContentViewController *)segue.destinationViewController;
        webVC.nodeLeaf = selectNod;
    }
}


@end
