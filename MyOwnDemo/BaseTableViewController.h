//
//  BaseTableViewController.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/17.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewModel.h"

@interface BaseTableViewController : UIViewController<HUDshowMessageDelegate, UITableViewDelegate, UITableViewDataSource>

-(instancetype)initWithStyle:(UITableViewStyle)style;

- (void)showMessage:(NSString *)message WithCode:(NSString *)code;
- (void)hideHUD;

- (void)addDefaultHeader;
- (void)addDefaultFooter;
- (void)HideFooter;
- (void)endRefresh;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
