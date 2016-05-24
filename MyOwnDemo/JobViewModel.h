//
//  JobViewModel.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^requestSuccess)(NSDictionary *dictionary);
typedef void(^requestFailure)(NSError *error);
@interface JobViewModel : NSObject
- (void)FetchDataWithSuccess:(requestSuccess)success failureWithFailure:(requestFailure)failure;

@end
