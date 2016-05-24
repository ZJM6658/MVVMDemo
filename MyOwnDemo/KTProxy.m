//
//  KTProxy.m
//  BaoTong
//
//  Created by  on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProxy.h"
#define TOKEN @"79998a0bbc18023ed9f2e16bcf462c2e"
#define USER_ID @"4028a8fa545b864901545ba5eda90006"
#define SERVER_HOST @"http://apitest.yaomaitong.cn/webapi/app/" //请求地址

@implementation KTProxy

+ (KTProxy *)loadWithMethod:(NSString *)method andParams:(NSDictionary *)params
                   completed:(RequestCompletedHandleBlock)completeHandleBlock
                      failed:(RequestFailedHandleBlock)failedHandleBlock
{
    KTProxy *proxy = [[KTProxy alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (params) {
        dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    }
    if (TOKEN) {
        [dict setObject:TOKEN forKey:@"token"];
    }
    if (USER_ID) {
        [dict setObject:USER_ID forKey:@"userId"];
    }
    
    proxy.oper = [manager POST:[NSString stringWithFormat:@"%@%@",SERVER_HOST,method] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (completeHandleBlock) {
            completeHandleBlock(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"==================================================");
        NSLog(@"加载数据失败，Error: %@", [error localizedDescription]);
        NSLog(@"Class:::%@", NSStringFromClass([self class]));
        NSLog(@"==================================================");
        if (failedHandleBlock) {
            failedHandleBlock(error);
        }
    }];
    return proxy;
}

- (void)start
{
    
    if (_oper) {
        [_oper resume];
    }
}

- (void)stop{
    if (_oper) {
        [_oper cancel];
    }
}

@end
