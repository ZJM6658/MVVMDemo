//
//  RequestUtility.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/7/31.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ClientSessionManager.h"

typedef void (^RequestCompletedHandleBlock)(NSDictionary * respDict);
typedef void (^RequestFailedHandleBlock)(NSError * error);

@interface RequestUtility : NSObject
@property (strong, nonatomic) NSURLSessionDataTask *oper;

- (void)start;

- (void)stop;

+ (RequestUtility *)loadWithMethod:(NSString *)method andParams:(NSDictionary *)params
                   completed:(RequestCompletedHandleBlock)completeHandleBlock
                      failed:(RequestFailedHandleBlock)failedHandleBlock;

@end
