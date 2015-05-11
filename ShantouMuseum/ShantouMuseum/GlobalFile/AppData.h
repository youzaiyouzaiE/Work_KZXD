//
//  AppData.h
//  BaiJiaCar
//
//  Created by jiahui on 15/1/24.
//  Copyright (c) 2015年 jiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DeviceScreenSize) {
    isLessInch = 1,///3.5寸屏
    isFourInch ,////4寸屏
    isFiveInch ,///5寸屏
    isBigInch ,///5.5寸屏
    isOtheInch ,///
    
};

typedef NS_ENUM(NSUInteger, SystemVersion) {
    isIOS6Late = 1,//
    isIOS6 ,//
    isIOS7 ,//
    isIOS8 ,//
    isOthe ,//
};


@interface AppData : NSObject


+ (instancetype)sharedInstance;
- (void)getDefaultData;
@property (copy, nonatomic) NSString *puserID;

@property (nonatomic) DeviceScreenSize deviceSize;
@property (nonatomic) SystemVersion systemVersion;

@end
