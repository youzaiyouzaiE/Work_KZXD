//
//  ChannelTree.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/9.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelTree : NSObject

@property (copy, nonatomic) NSString *id_string;
@property (copy, nonatomic) NSString *name;
@property (nonatomic) BOOL hasContent;//true-有文章，false-有内容，如果为false，则需要显示text字段内容
@property (nonatomic) BOOL isLeaf;//true-没有子栏目，false-有子栏目
@property (nonatomic) BOOL hasImg;
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) ChannelTree *parent;
@property (strong, nonatomic) NSMutableArray *children;
@property (nonatomic) NSInteger lengs;///是第几级节点

- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (void)addChild:(ChannelTree *)child;
- (NSInteger)getNumberLound;//成员到根的距离

@end
