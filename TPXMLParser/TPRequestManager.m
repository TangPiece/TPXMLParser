//
//  RequestManager.m
//  AnShanJuLongApp
//
//  Created by ljp on 15/5/23.
//  Copyright (c) 2015年 LC-World. All rights reserved.
//

#import "TPRequestManager.h"
#import "AFNetworking.h"

@implementation TPRequestManager

#pragma mark - public methods

+ (void)url:(NSString *)url params:(NSDictionary *)params isPost:(BOOL)isPost success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    if (isPost) {
        [self post:url params:params success:success fail:fail];
    }else{
        [self get:url params:params success:success fail:fail];
    }
}

#pragma mark - private methods

//GET请求
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSURLSessionDataTask *task = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    [task resume];
}

//POST请求
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"请求成功");
//        success(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        fail(error);
//    }];
}

@end
