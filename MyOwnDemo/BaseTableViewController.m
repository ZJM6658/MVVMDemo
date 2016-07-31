//
//  BaseTableViewController.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/17.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface BaseTableViewController () {
    MBProgressHUD *_hudText;//加载菊花
    UITableViewStyle _tableStyle;//列表样式
}
@end

@implementation BaseTableViewController

#pragma mark - initialize
- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super init]){
        _tableStyle = style;
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
}

#pragma mark - private methods
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

//添加下拉刷新
- (void)addDefaultHeader{
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.dataArray = [[NSMutableArray alloc]init];
        [weakSelf loaddataWith:@"1"];
    }];
}

//添加上拉加载
- (void)addDefaultFooter{
    if (!self.tableview.mj_footer) {
        self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    }
}

//结束加载状态
- (void)endRefresh{
    if (self.tableview.mj_header) {
        [self.tableview.mj_header endRefreshing];
    }
    if (self.tableview.mj_footer) {
        [self.tableview.mj_footer endRefreshing];
    }
}

//移除上拉加载
- (void)HideFooter{
    if (self.tableview.mj_footer) {
        self.tableview.mj_footer = nil;
    }
}

- (void)loaddataWith:(NSString *)pageNo{
    //子类需重写
}

- (void)loadNextPage{
    //子类需重写
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIder = @"DEFAULT_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIder];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIder];
    }
    return cell;
}

#pragma mark - getter & setter
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:_tableStyle];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

@end
