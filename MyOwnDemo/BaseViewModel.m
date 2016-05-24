//
//  BaseViewModel.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/16.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)showMessage:(NSString *)message WithCode:(NSString *)code{
    if ([self.delegate respondsToSelector:@selector(showMessage:WithCode:)]) {
        [self.delegate showMessage:message WithCode:code];
    }
}

- (void)hideHUD{
    if ([self.delegate respondsToSelector:@selector(hideHUD)]) {
        [self.delegate hideHUD];
        [self endRefresh];
    }
}

- (void)addDefaultFooter{
    if ([self.delegate respondsToSelector:@selector(addDefaultFooter)]) {
        [self.delegate addDefaultFooter];
    }
}

- (void)HideFooter{
    if ([self.delegate respondsToSelector:@selector(HideFooter)]) {
        [self.delegate HideFooter];
    }
}

- (void)endRefresh{
    if ([self.delegate respondsToSelector:@selector(endRefresh)]) {
        [self.delegate endRefresh];
    }
}

@end
