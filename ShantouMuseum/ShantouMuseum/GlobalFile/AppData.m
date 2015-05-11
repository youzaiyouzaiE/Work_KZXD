//
//  AppData.m
//  BaiJiaCar
//
//  Created by jiahui on 15/1/24.
//  Copyright (c) 2015年 jiahui. All rights reserved.
//

#import "AppData.h"

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


@end
