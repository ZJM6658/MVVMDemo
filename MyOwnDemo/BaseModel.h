//
//  BaseModel.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/16.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *is_selected;
@property (nonatomic, strong) NSString *baseid;
@property (nonatomic, strong) NSString * proviceID;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *choices;
@end
