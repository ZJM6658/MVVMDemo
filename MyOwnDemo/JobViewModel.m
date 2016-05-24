//
//  JobViewModel.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "JobViewModel.h"
#import "KTProxy.h"
#import "JobModel.h"

@implementation JobViewModel


- (void)FetchDataWithSuccess:(requestSuccess)success failureWithFailure:(requestFailure)failure{
    KTProxy *proxy = [KTProxy loadWithMethod:[self method] andParams:[self params] completed:^(NSDictionary *respDict) {
        success(respDict);
    } failed:^(NSError *error) {
        failure(error);
    }];
    [proxy start];
}

- (NSString *)method{
    return @"myrecruitment/list";
}

- (NSDictionary *)params{
    return @{@"pageNo":[NSNumber numberWithInteger:1], @"pageSize":[NSNumber numberWithInteger:10]};
}
@end
