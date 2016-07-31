//
//  ClientSessionManager.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/7/31.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface ClientSessionManager : AFHTTPSessionManager

+ (instancetype)shareInstance;
@end
