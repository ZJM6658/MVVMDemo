//
//  BaseModel.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/16.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray{
    return @{@"cities":[BaseModel class],@"choices":[BaseModel class]};
}

+ (Class)objectClassInArray:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"cities"]) {
        return [BaseModel class];
    }
    if ([propertyName isEqualToString:@"choices"]) {
        return [BaseModel class];
    }
    return nil;
}

@end
