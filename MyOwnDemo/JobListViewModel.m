//
//  JobListViewModel.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "JobListViewModel.h"
#import "KTProxy.h"
#import "JobModel.h"
#import "MJExtension.h"
#define requestNum 10

@implementation JobListViewModel

- (void)FetchDataWithSuccess:(requestSuccess)success failureWithFailure:(requestFailure)failure{
    //构造输入数据，进行测试
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 15; i++) {
        JobModel *job = [[JobModel alloc]init];
        job.name = @"程序员鼓励师";
        job.jobId = [NSString stringWithFormat:@"%d",i+1];
        job.showDate = @"五分钟前";
        [dataArray addObject:job];
    }
    
    success(dataArray);
    return; //上面用于输入测试数据给Controller，下面是正常请求逻辑
    
    [self showMessage:@"正在加载" WithCode:@""];//调用加载狂
    KTProxy *proxy = [KTProxy loadWithMethod:[self method] andParams:[self params] completed:^(NSDictionary *respDict) {
        [self hideHUD];//隐藏加载框
        if ([respDict[@"code"] integerValue]== 0) {
            NSArray *array = [JobModel mj_objectArrayWithKeyValuesArray:respDict[@"data"][@"result"]];//字典数组转模型数组
            if (array.count == requestNum) {
                [self addDefaultFooter];
            } else {
                [self HideFooter];
            }
            success(array);
        } else {
            [self showMessage:respDict[@"message"] WithCode:respDict[@"code"]];//提示服务器返回的非正常信息
        }
    } failed:^(NSError *error) {
        failure(error);
        [self hideHUD];
    }];
    [proxy start];
}

- (NSString *)method{
    return @"myrecruitment/list";
}

- (NSDictionary *)params{
    return @{@"pageNo":self.pageNo?self.pageNo:@"1", @"pageSize":[NSNumber numberWithInteger:requestNum]};
}
@end
