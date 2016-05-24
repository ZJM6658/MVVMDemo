//
//  JobModel.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "JobModel.h"

@implementation JobModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Description" : @"description",@"jobId":@"id"};
}
@end
