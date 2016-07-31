//
//  BaseViewModel.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/16.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestSuccess)(NSArray *responseArray);
typedef void(^requestFailure)(NSError *error);

@protocol HUDshowMessageDelegate<NSObject>
@optional
//加载框控制
- (void)showMessage:(NSString *)message WithCode:(NSString *)code;
- (void)hideHUD;

//刷新控件控制
- (void)addDefaultFooter;
- (void)HideFooter;
- (void)endRefresh;
@end

@interface BaseViewModel : NSObject<HUDshowMessageDelegate>

@property(nonatomic,weak) id<HUDshowMessageDelegate>delegate;

@end
