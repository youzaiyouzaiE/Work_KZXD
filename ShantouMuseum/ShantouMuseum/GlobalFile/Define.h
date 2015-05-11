//
//  Define.h
//  SmartLife
//
//  Created by jiahui on 15/4/7.
//  Copyright (c) 2015年 GDT. All rights reserved.
//

#ifndef SmartLife_Define_h
#define SmartLife_Define_h

////定义单例
#define SHARE_INSTANCET(className)\
\
static className *shared##className = nil;\
+ (className *)getInstancet\
{\
static dispatch_once_t predicate;\
dispatch_once(&predicate, ^{\
shared##className = [[self alloc] init];\
});\
return shared##className;\
}\

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define NSNUMBER_INT(value) [NSNumber numberWithInt:(value)]

#define     SCREEN_W    [[UIScreen mainScreen] bounds].size.width
#define     SCREEN_H    [[UIScreen mainScreen] bounds].size.height
////
#define IOS_7LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0

/////是debug 状态
#define IS_DEBUG            1

//iphone5
#define ISIPHONE5 ([NSString getDeviceTypeInfo]>=5) ? 1 : 0
//iphone4
#define ISIPHONE4 ([NSString getDeviceTypeInfo] == 4) ? 1 : 0
#define ISIPHONE5S ([[NSString deviceString] isEqualToString:@"iPhone 5s"]) ? 1 : 0
#define ISIPHOEN6  ([NSString getDeviceTypeInfo] == 6) ? 1 : 0
#define ISIPHONE6P ([[NSString deviceString] isEqualToString:@"iPhone 6 Plus"]) ? 1 : 0
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//APP版本号
#define VERSIONNUM [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define REQUEST_CHANNEL_URL_STR                 @"http://shantou.customs.gov.cn/Portals/151/guanshi/phone/channeltree.html"
#define REQUEST_CONTENT_URL_STR(channelID)     [NSString stringWithFormat:@"http://shantou.customs.gov.cn/Portals/151/guanshi/phone/channel/%@.html",channelID]
#define IMAGE_ROAD_URL_STR(imageRod)           [NSString stringWithFormat:@"http://shantou.customs.gov.cn/Portals/151/guanshi%@",imageRod]


#endif
