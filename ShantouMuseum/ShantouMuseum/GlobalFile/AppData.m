//
//  AppData.m
//  BaiJiaCar
//
//  Created by jiahui on 15/1/24.
//  Copyright (c) 2015年 jiahui. All rights reserved.
//

#import "AppData.h"
#import "ChannelTree.h"
#import "ContentNode.h"
#import "Image.h"


@implementation AppData

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppData alloc] init];
    });
    return sharedInstance;
}

- (void)getDefaultData
{
    self.deviceSize = [self getDeviceSize];
    self.systemVersion = [self getSystemVersion];
}

- (DeviceScreenSize)getDeviceSize
{
    NSInteger screenSizeHeight = [UIScreen mainScreen].bounds.size.height;
    switch (screenSizeHeight) {
        case 480:
            return isLessInch;
            break;
        case 568:
            return isFourInch;
            break;
        case 667:
            return isFiveInch;
            break;
        case 736:
            return isBigInch;
            break;
        default:
            break;
    }
    return isOtheInch;
}

- (SystemVersion)getSystemVersion
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    float floatVersion = version.floatValue;
    NSInteger interVersion = floatVersion;
    if (interVersion < 6) {
        return isIOS6Late;
    }
    switch (interVersion) {
        case 6:
            return isIOS6;
            break;
        case 7:
            return isIOS7;
            break;
        case 8:
            return isIOS8;
            break;
            
        default:
            return isOthe;
            break;
    }
}

#pragma mark - 请求叶结点的内容
- (void)checkChannelContentFormServer:(NSString *)channelID
{
    /////存到本地文件，本地没有再从服务器取出来
    NSLog(@"%@",REQUEST_CONTENT_URL_STR(channelID));
    [RequestWrapper getRequestWithURL:REQUEST_CONTENT_URL_STR(channelID)
                       withParameters:nil
                              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                  NSString *responsString = operation.responseString;
                                                                  NSArray *arrayContentNodes = [self analysisDataFormJsonString:responsString];
//                                                                    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:arrayLeafs forKey:LEAF_USER_DEFAULT(channelID)];
//                                                                    [self performSegueWithIdentifier:@"MainPushToLeafVC" sender:self];
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



@end
