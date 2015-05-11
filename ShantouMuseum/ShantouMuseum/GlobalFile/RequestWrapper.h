//
//  RequestWrapper.h
//  BaiJiaCar
//
//  Created by jiahui on 15/1/24.
//  Copyright (c) 2015年 jiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestWrapper : NSObject

+ (AFHTTPRequestOperationManager *)requestWithURL:(NSString *)url
                                   withParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperationManager *)getRequestWithURL:(NSString *)url
                                      withParameters:(NSDictionary *)parameters
                                             success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
