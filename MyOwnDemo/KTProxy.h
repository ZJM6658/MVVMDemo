//
//  KTProxy.h
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
typedef void (^RequestCompletedHandleBlock)(NSDictionary * respDict);
typedef void (^RequestFailedHandleBlock)(NSError * error);

@interface KTProxy : NSObject
@property (strong, nonatomic) NSURLSessionDataTask *oper;

- (void)start;

- (void)stop;

+ (KTProxy *)loadWithMethod:(NSString *)method andParams:(NSDictionary *)params
                   completed:(RequestCompletedHandleBlock)completeHandleBlock
                      failed:(RequestFailedHandleBlock)failedHandleBlock;

@end
