//
//  ContentNode.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/10.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface ContentNode : NSObject

@property (assign, nonatomic) BOOL isHtml;///是否是网页
@property (assign, nonatomic) BOOL update;
@property (assign, nonatomic) BOOL isImg;///true，则显示imgs里面的数据，否则显示 contentImg字段链接接的图片
@property (strong, nonatomic) NSMutableArray *images;
@property (copy, nonatomic) NSString *title;    
@property (copy, nonatomic) NSString *id_String;
@property (copy, nonatomic) NSString *txt;
@property (strong, nonatomic) NSString *contentImg;
@property (strong, nonatomic) NSString *desc;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (void)addImage:(Image *)image;

@end
