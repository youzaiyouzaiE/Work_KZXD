//
//  Image.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/10.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "Image.h"

@implementation Image
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.desc = [dic objectForKey:@"desc"];
        self.url = [dic objectForKey:@"url"];
    }
    return self;
}
@end
