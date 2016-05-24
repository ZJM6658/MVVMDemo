//
//  KTProxy.h
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestCompletedHandleBlock)(NSString * resp, NSStringEncoding encoding);
typedef void (^RequestFailedHandleBlock)(NSError * error);

@interface KTProxy : NSObject

@property (readonly, nonatomic) BOOL loading;
@property (readonly, nonatomic) BOOL loaded;
@property (strong, nonatomic) AFHTTPRequestOperation *oper;

- (void)start;
- (BOOL)isLoading;
- (BOOL)isLoaded;
- (void)stop;

+ (KTProxy *)loadWithMethod:(NSString *)method andParams:(NSDictionary *)params
                   completed:(RequestCompletedHandleBlock)completeHandleBlock
                      failed:(RequestFailedHandleBlock)failedHandleBlock;

@end
