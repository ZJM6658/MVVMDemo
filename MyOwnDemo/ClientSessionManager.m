//
//  ClientSessionManager.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/7/31.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "ClientSessionManager.h"

@implementation ClientSessionManager

+ (instancetype)shareInstance {
    static ClientSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [ClientSessionManager manager];
    });
    
    return sessionManager;
}

@end
