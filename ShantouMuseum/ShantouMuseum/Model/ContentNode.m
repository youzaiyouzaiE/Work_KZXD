//
//  ContentNode.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/10.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "ContentNode.h"

@implementation ContentNode

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        NSNumber *htmlNum = [dic objectForKey:@"isHtml"];
        self.isHtml = htmlNum.boolValue;
        
        NSNumber *updateNum = [dic objectForKey:@"update"];
        self.update = updateNum.boolValue;
        
        NSNumber *imgNum = [dic objectForKey:@"isImg"];
        self.isImg = imgNum.boolValue;
        self.title = [dic objectForKey:@"title"];
        self.id_String = [dic objectForKey:@"id"];
    }
    return self;
}

- (void)addImage:(Image *)image {
    if (self.images == nil) {
        self.images = [NSMutableArray array];
    }
    [self.images addObject:image];
}


@end
