//
//  BaseViewController.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/17.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewModel.h"

@interface BaseViewController : UIViewController<HUDshowMessageDelegate>
- (void)showMessage:(NSString *)message WithCode:(NSString *)code;
- (void)hideHUD;
@end
