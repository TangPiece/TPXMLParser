//
//  RequestManager.h
//  AnShanJuLongApp
//
//  Created by ljp on 15/5/23.
//  Copyright (c) 2015年 LC-World. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailBlock)(NSError *error);

@interface TPRequestManager : NSObject
/**
 *  负责该应用所有的对外发送网络请求
 *
 *  @param url     url
 *  @param params  url参数
 *  @param isPost  是否是POST请求
 *  @param success 请求成功
 *  @param fail    请求失败
 */
+ (void)url:(NSString *)url params:(NSDictionary *)params isPost:(BOOL)isPost success:(SuccessBlock)success fail:(FailBlock)fail;

@end
