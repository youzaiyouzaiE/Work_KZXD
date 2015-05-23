//
//  DataTools.m
//  SmartLift-iPhone
//
//  Created by jiahui on 14-10-16.
//  Copyright (c) 2014年 wdz. All rights reserved.
//

#import "DataTools.h"

@implementation DataTools


#pragma mark - data style

SHARE_INSTANCET(DataTools)

//+ (NSString *)yearMonthDateStringFromiPhone
//{
//    NSDate *  senddate=[NSDate date];
//    //    NSLog(@"%@",senddate);
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"HH:mm:ss"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
//    //    NSLog(@"当前时间为%@",locationString);
//    
//    NSCalendar  * cal=[NSCalendar  currentCalendar];
//    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
//    NSInteger year=[conponent year];
//    NSInteger month=[conponent month];
//    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d%d ",year,month];
//    nsDateString = [nsDateString stringByAppendingString:locationString];
//    return nsDateString;
//}
//
//+ (NSInteger )currentYear
//{
//    NSDate *  senddate=[NSDate date];
//    NSCalendar  * cal=[NSCalendar  currentCalendar];
//    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
//    NSInteger year=[conponent year];
//    //    NSString *yearStr = FORMAT(@"%d",year);
//    return year;
//}
//
//+ (NSInteger )currentMonth
//{
//    NSDate *  senddate=[NSDate date];
//    NSCalendar  * cal=[NSCalendar  currentCalendar];
//    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
//    NSInteger month =[conponent month];
//    return month;
//}
//
//+ (NSInteger )currentDay
//{
//    NSDate *  senddate=[NSDate date];
//    NSCalendar  * cal=[NSCalendar  currentCalendar];
//    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
//    NSInteger day =[conponent day];
//    return day;
//}


+ (NSDate *)dateForomThatTime//获取当前时间
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];//28800
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

//日期显示为  2011年4月4日 星期一
+ (NSString *)Date2StrV:(NSDate *)indate{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]; //setLocale 方法将其转为中文的日期表达
    dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
    NSString *tempstr = [dateFormatter stringFromDate:indate];
    return tempstr;
}

//程序中使用的，提交日期的格式
+ (NSString *) Date2Str:(NSDate *)indate{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSString *tempstr = [dateFormatter stringFromDate:indate];
    return tempstr;
}


+ (NSString *)yearAndMothDateStr{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateFormatter.dateFormat = @"yyyyMM";
    NSString *tempstr = [dateFormatter stringFromDate:[DataTools dateForomThatTime]];
    return tempstr;
}



#pragma mark - 字符串的限制
+ (NSString *)subStringWithSring:(NSString *)strtemp substringLengthMax:(NSInteger)max{
    int lele = 0;
    int ssd = 0;
    for(int i=0;i < strtemp.length; i++){
        unichar ch = [strtemp characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            lele += 2;
        }else{
            lele += 1;
        }
        if(lele <= max){
            ssd += 1;
        }
    }
    if(lele > max){
        for(int i=0;i<strtemp.length; i++){
            unichar ch = [strtemp characterAtIndex:i];
            if(lele > max){
                if (0x4e00 < ch  && ch < 0x9fff) {
                    lele -= 2;
                }else{
                    lele -= 1;
                }
            }else{
                
            }
        }
        return [strtemp substringWithRange:NSMakeRange(0, ssd)];
    }
    return strtemp;
}


- (void)saveStringValue:(NSString *)value forUserDefaultKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

- (NSString *)LoadStringUserDefault:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:key];
}

#pragma mark - FileManage
- (NSString *)pathForDocumentsResource:(NSString *)relativePath
{
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [dirs objectAtIndex:0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

///检查document下是否存在该路径
- (BOOL)checkDocumentHasThePath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}

//在系统document下添加文件夹 （取document下documentName）
- (NSString *)addDocumentToSystemDocument:(NSString *)documentName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filDocument = [paths[0] stringByAppendingPathComponent:FORMAT(@"%@",documentName)];
    if ([fm fileExistsAtPath:filDocument]) {
        return filDocument;
    } else {
        BOOL creat = [[NSFileManager defaultManager] createDirectoryAtPath:filDocument withIntermediateDirectories:YES attributes:nil error:nil];
        if (creat) {
            return filDocument;
        }else
            NSLog(@"创建%@文件夹失败",documentName);
        return @"-1";
    }
}

- (BOOL)saveData:(NSData *)data toDocumentPathDocumentName:(NSString *)documentName andFileName:(NSString *)fileName
{
    NSString *pathName = [self addDocumentToSystemDocument:documentName];
    if ([pathName isEqualToString:@"-1"]) {
        return NO;
    }
    NSString *filePath = [pathName stringByAppendingPathComponent:fileName];
   return [data writeToFile:filePath atomically:YES];
}

- (NSArray *)getDocumentFiles:(NSString *)filesPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *pathName = [paths[0] stringByAppendingPathComponent:filesPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathName]) {
        NSArray *sourceArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathName error:nil];
        return sourceArray;
    } else
        return nil;
}

@end


