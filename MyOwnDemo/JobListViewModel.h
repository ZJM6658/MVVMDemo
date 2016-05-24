//
//  JobListViewModel.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "BaseViewModel.h"

@interface JobListViewModel : BaseViewModel<HUDshowMessageDelegate>

@property(nonatomic, strong) NSString *pageNo;
- (void)FetchDataWithSuccess:(requestSuccess)success failureWithFailure:(requestFailure)failure;

@end
