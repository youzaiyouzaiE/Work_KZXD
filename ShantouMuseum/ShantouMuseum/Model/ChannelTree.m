//
//  ChannelTree.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/9.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "ChannelTree.h"

@implementation ChannelTree

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.id_string = [dic objectForKey:@"id"];
        self.name = [dic objectForKey:@"name"];
        
        NSNumber *contentNum = [dic objectForKey:@"hasContent"];
        self.hasContent = contentNum.boolValue;
        
        NSNumber *leafNum = [dic objectForKey:@"leaf"];
        self.isLeaf = leafNum.boolValue;
        
        NSNumber *imgNum = [dic objectForKey:@"hasImg"];
        self.hasImg = imgNum.boolValue;
        self.text = [dic objectForKey:@"text"];
    }
    return self;
}

-(void)addChild:(ChannelTree *)child {
//    NSLog(@"该孩子的父亲是:%@",child.parent.name);
    if (child.parent.children == nil) {
        child.parent.children = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [child.parent.children addObject:child];
}

-(NSInteger)getNumberLound {
    return self.parent == nil?0:[self.parent getNumberLound] + 1;
}

@end
