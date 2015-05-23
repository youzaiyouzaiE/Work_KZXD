//
//  GlobalInstance.m
//  BaiJiaCar
//
//  Created by jiahui on 15/1/18.
//  Copyright (c) 2015年 jiahui. All rights reserved.
//

#import "GlobalInstance.h"

@implementation GlobalInstance
+ (instancetype)sharedManager
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalInstance alloc] init];
    });
    return sharedInstance;
}

CGFloat ASDisplayNodeScreenBoundsWith()
{
    static CGFloat screenWidth = 0.0;
    static dispatch_once_t onceToken;
    ASDispatchOnceOnMainThread(&onceToken, ^{
        screenWidth = [[UIScreen mainScreen] bounds].size.width;
    });
    return screenWidth;
}

CGFloat ASDisplayNodeScreenBoundsHeight()
{
    static CGFloat screenHeight = 0.0;
    static dispatch_once_t onceToken;
    ASDispatchOnceOnMainThread(&onceToken, ^{
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
    });
    return screenHeight;
}

static void ASDispatchOnceOnMainThread(dispatch_once_t *predicate, dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        dispatch_once(predicate, block);
    } else {
        if (DISPATCH_EXPECT(*predicate == 0L, NO)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                dispatch_once(predicate, block);
            });
        }
    }
}

+(float)APPVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark -MBProgressHUD 显示方法
- (void)showMessageToView:(UIView *)view message:(NSString *)message
{
    [self showMessageToView:view message:message autoHide:YES];
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    if (autoHide) {
        [hud hide:YES afterDelay:1.5f];
    }
    return hud;
}

#pragma mark - UIs
+ (NSString *)intervalSinceNow:(NSString *)theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
    }
    return timeString;
}

//获取自适应字的高度？？？
//+ (float)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt
//{
//    float fPadding = 16.0;
//    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
//    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:0];
//    float fHeight = size.height + 16.0;
//    return fHeight;
//}

@end
