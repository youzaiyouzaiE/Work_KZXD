//
//  Image.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/10.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject


@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *url;


- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
