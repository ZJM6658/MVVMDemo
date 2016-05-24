//
//  JobViewModel.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "JobModel.h"

@interface JobViewModel : BaseViewModel<HUDshowMessageDelegate>
@property(nonatomic, strong) NSString *jobId;
@property(nonatomic, strong) JobModel *jobInfo;

@property(nonatomic) NSInteger modelType;

- (void)FetchDataWithSuccess:(requestSuccess)success failureWithFailure:(requestFailure)failure;

@end
