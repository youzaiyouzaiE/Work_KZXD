//
//  RequestWrapper.m
//  BaiJiaCar
//
//  Created by jiahui on 15/1/24.
//  Copyright (c) 2015年 jiahui. All rights reserved.
//

#import "RequestWrapper.h"

@implementation RequestWrapper

+ (AFHTTPRequestOperationManager *)requestWithURL:(NSString *)url
                                   withParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    
    requestManager.requestSerializer.timeoutInterval = 10.0f;
    requestManager.requestSerializer.HTTPShouldHandleCookies = YES;
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:requestManager.responseSerializer.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    [acceptContentTypes addObject:@"text/html"];
    [acceptContentTypes addObject:@"application/json"];
    requestManager.responseSerializer.acceptableContentTypes = acceptContentTypes;
    
    [requestManager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    return requestManager;
}

+ (AFHTTPRequestOperationManager *)getRequestWithURL:(NSString *)url
                                   withParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    
    requestManager.requestSerializer.timeoutInterval = 10.0f;
    requestManager.requestSerializer.HTTPShouldHandleCookies = YES;
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:requestManager.responseSerializer.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    [acceptContentTypes addObject:@"text/html"];
    [acceptContentTypes addObject:@"application/json"];
    requestManager.responseSerializer.acceptableContentTypes = acceptContentTypes;
    
    [requestManager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    return requestManager;
}

@end
