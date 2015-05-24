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
#import "MWCommon.h"
#import "MWPhotoBrowser.h"
#import "SDImageCache.h"

@interface LeafListViewController ()<UITableViewDataSource, UITableViewDelegate,MWPhotoBrowserDelegate> {
    ContentNode *selectNod;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic, strong) NSMutableArray *onlyPhotos;
@end

@implementation LeafListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _fatherChannel.name;
    _photos = [NSMutableArray array];
    _thumbs = [NSMutableArray array];
    
    NSString *savePath = [UITools getSavePathFormLeafNod:self.fatherChannel];
    for (ContentNode *nodeLeaf in _arrayContents) {
        if (nodeLeaf.isImg && nodeLeaf.images !=nil) {/////显示Imgs里的内容
//            NSLog(@"显示Imgs里的内容");
        } else if (!nodeLeaf.isImg && nodeLeaf.contentImg != nil){
            MWPhoto *photo;
            NSString *documentPath = [[UITools getInstancet] pathForDocumentName:[UITools getSavePathFormLeafNod:self.fatherChannel]];
            NSString *imagePath = [documentPath stringByAppendingPathComponent:[UITools getImageNameForContentImg:nodeLeaf.contentImg]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                photo = [MWPhoto photoWithImage:image];
            } else {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:IMAGE_ROAD_URL_STR(nodeLeaf.contentImg)]];
            }
            photo.saveName = [UITools getImageNameForContentImg:nodeLeaf.contentImg];
            photo.saveImagePath = savePath;
            photo.caption = nodeLeaf.desc;
            [_photos addObject:photo];
            [_thumbs addObject:photo];
        }
    }
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
        
        NSString *documentPath = [[UITools getInstancet] pathForDocumentName:[UITools getSavePathFormLeafNod:self.fatherChannel]];
        NSString *imagePath = [documentPath stringByAppendingPathComponent:[UITools getImageNameForContentImg:currentNod.contentImg]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        } else
            [imageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_ROAD_URL_STR(currentNod.contentImg)]
                         placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if ([[UITools getInstancet] saveImageToFileParth:[UITools getSavePathFormLeafNod:self.fatherChannel] image:image inFileName:[UITools getImageNameForContentImg:currentNod.contentImg]]) {
                                        NSLog(@"save success");
                                    } else {
                                        NSLog(@"save fail");
                                    }
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
    NSString *savePath = [UITools getSavePathFormLeafNod:self.fatherChannel];
    selectNod = _arrayContents[indexPath.row];
    if (selectNod.isImg) {
        savePath = [savePath stringByAppendingPathComponent:selectNod.title];
    }
        if (selectNod.isImg && selectNod.images !=nil) {////显示子节点里的图片
        [_photos removeAllObjects];
        for (Image *image in selectNod.images) {
            MWPhoto *photo;
            NSString *documentPath = [[UITools getInstancet] pathForDocumentName:savePath];
            NSString *imagePath = [documentPath stringByAppendingPathComponent:[UITools getImageNameForContentImg:image.url]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                photo = [MWPhoto photoWithImage:image];
            } else {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:IMAGE_ROAD_URL_STR(image.url)]];
            }
            photo.saveImagePath = savePath;
            photo.saveName = [UITools getImageNameForContentImg:image.url];
            photo.caption = image.desc;
            [_photos addObject:photo];
        }
        BOOL displayActionButton = NO;////分享
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = NO;
        BOOL startOnGrid = NO;
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = YES;
#endif
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        [browser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
        
    } else if (!selectNod.isImg && selectNod.contentImg != nil) {///对应List里的图片 带相册的
        BOOL displayActionButton = NO;////分享
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = YES;
#endif
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        [browser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
    } else if (selectNod.isHtml) {////是网页展示
        [self performSegueWithIdentifier:@"LeafPushToWebVC" sender:self];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}
//
//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}
//
////- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
////    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
////}
//
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}
//
//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
//    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - 请求从网络请求文字数据并保存
- (void)checkChannelContentFormServer:(NSString *)channelID
{
    /////存到本地文件，本地没有再从服务器取出来
    NSLog(@"%@",REQUEST_CONTENT_URL_STR(channelID));
    [RequestWrapper getRequestWithURL:REQUEST_CONTENT_URL_STR(channelID)
                       withParameters:nil
                              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//                                  NSString *responsString = operation.responseString;
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
