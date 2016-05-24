//
//  BaseTableViewController.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/17.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MBProgressHUD.h"

@interface BaseTableViewController ()
@property (nonatomic, strong) MBProgressHUD *hudText;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showMessage:(NSString *)message WithCode:(NSString *)code{
    _hudText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hudText.labelText = message;
    if (message.length) {
        [_hudText hide:YES afterDelay:1.5f];
    }
}

- (void)hideHUD{
    [_hudText hide:YES];
}

@end
