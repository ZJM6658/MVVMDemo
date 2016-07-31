//
//  RequestUtility.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/7/31.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "RequestUtility.h"

#define TOKEN @""
#define USER_ID @""
#define SERVER_HOST @"" //请求地址

@implementation RequestUtility

/**
 *  公共请求类方法
 *
 *  @param method              请求短url
 *  @param params              请求参数
 *  @param completeHandleBlock 请求成功Block
 *  @param failedHandleBlock   请求失败Block
 *
 *  @return 返回的实例是为了方便取消当前页面的请求,防止页面退出后依旧保持未完成的网络请求
 */

+ (RequestUtility *)loadWithMethod:(NSString *)method
                         andParams:(NSDictionary *)params
                         completed:(RequestCompletedHandleBlock)completeHandleBlock
                            failed:(RequestFailedHandleBlock)failedHandleBlock {
    RequestUtility *requestProxy = [[RequestUtility alloc] init];
    AFHTTPSessionManager *manager = [ClientSessionManager shareInstance];
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
    
    requestProxy.oper = [manager POST:[NSString stringWithFormat:@"%@%@",SERVER_HOST,method] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
    return requestProxy;
}

- (void)start {
    if (self.oper) {
        [self.oper resume];
    }
}

- (void)stop {
    if (self.oper) {
        [self.oper cancel];
    }
}

@end
