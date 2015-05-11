//
//  DataTools.h
//  SmartLift-iPhone
//
//  Created by jiahui on 14-10-16.
//  Copyright (c) 2014年 wdz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTools : NSObject

+ (instancetype)getInstancet;

//+ (NSString *)yearMonthDateStringFromiPhone;
//+ (NSInteger)currentYear;
//+ (NSInteger)currentMonth;
//+ (NSInteger)currentDay;
+ (NSDate *)dateForomThatTime;
+ (NSString *)Date2StrV:(NSDate *)indate;
+ (NSString *)Date2Str:(NSDate *)indate;
+ (NSString *)yearAndMothDateStr;
+ (NSString *)subStringWithSring:(NSString *)strtemp substringLengthMax:(NSInteger)max;
- (NSString *)LoadStringUserDefault:(NSString *)key;
- (void)saveStringValue:(NSString *)value forUserDefaultKey:(NSString *)key;

/////fileManage
- (NSString *)pathForDocumentsResource:(NSString *)relativePath;
- (NSString *)addDocumentToSystemDocument:(NSString *)documentName;
- (BOOL)saveData:(NSData *)data toDocumentPathDocumentName:(NSString *)documentName andFileName:(NSString *)fileName;
- (NSArray *)getDocumentFiles:(NSString *)filesPath;
- (BOOL)checkDocumentHasThePath:(NSString *)path;

@end
