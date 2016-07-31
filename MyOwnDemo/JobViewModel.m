//
//  JobViewModel.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "JobViewModel.h"
#import "RequestUtility.h"
#import "JobModel.h"
#import "MJExtension.h"
@implementation JobViewModel

- (instancetype)init{
    if (self = [super init]) {
        self.jobInfo = [[JobModel alloc]init];
    }
    return self;
}

- (void)FetchDataWithSuccess:(requestSuccess)success failureWithFailure:(requestFailure)failure{
    //构造测试数据
    success(self.testArray);
    return;
    
    //网络请求
    [self showMessage:@"正在加载" WithCode:@""];//菊花
    RequestUtility *proxy = [RequestUtility loadWithMethod:[self method] andParams:[self params] completed:^(NSDictionary *respDict) {
        [self hideHUD];
        if ([respDict[@"code"] integerValue] == 0) {
            if (self.modelType == 0) {
                self.jobInfo = [JobModel mj_objectWithKeyValues:respDict[@"data"]];//字典转模型
                success([NSArray arrayWithObject:self.jobInfo]);
            }else if (self.modelType == 1) {
                [self showMessage:@"发布成功" WithCode:@"8888"];
            } else if (self.modelType == 2) {
                [self showMessage:@"更新成功" WithCode:@"8888"];
            }
        }else{
            //提示错误
            [self showMessage:respDict[@"message"] WithCode:respDict[@"code"]];
        }
    } failed:^(NSError *error) {
        failure(error);
        [self hideHUD];
    }];
    [proxy start];
}

- (NSArray *)testArray{
    _jobInfo = [[JobModel alloc]init];
    _jobInfo.name = @"程序员鼓励师";
    _jobInfo.companyName = @"杭州六倍体科技";
    _jobInfo.areaName = @"浙江 杭州市";
    _jobInfo.salaryName = @"面议";
    _jobInfo.typeName = @"技术";
    _jobInfo.experienceName = @"不限";
    _jobInfo.email = @"815187811@qq.com";
    _jobInfo.degreeName = @"本科以上";
    _jobInfo.showDate = @"两小时前";
    _jobInfo.Description = @"期待你的加入";
    return [NSArray arrayWithObject:_jobInfo];
}

- (NSString *)method{
    if (self.modelType == 2) {
        return @"recruitment/job/add";//发布
    } else if (self.modelType == 1) {
        return @"recruitment/job/update";//更新
    }
    return @"myrecruitment/job/edit";//职位编辑
}

//参数准备
- (NSDictionary *)params{
    NSMutableDictionary *paramsDic;
    if (self.modelType) {//更新或者发布
        paramsDic = [[NSMutableDictionary alloc]init];
        paramsDic = self.jobInfo.mj_keyValues;//模型转字典
        if (self.modelType == 1) {//更新
            [paramsDic setObject:self.jobInfo.jobId forKey:@"id"];
        }
        return @{@"requestObj":paramsDic};
    }
    return @{@"requestObj":self.jobId};//我的职位编辑
}

@end
