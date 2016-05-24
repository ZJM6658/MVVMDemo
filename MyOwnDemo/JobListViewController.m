//
//  ViewController.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "ViewController.h"
#import "JobInfoViewController.h"
#import "JobListViewModel.h"
#import "JobModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, HUDshowMessageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JobListViewModel *jobListModel;
@property (nonatomic) NSInteger current;
@property (nonatomic) NSInteger max;
@property (nonatomic, strong) MBProgressHUD *hudText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobListModel = [[JobListViewModel alloc]init];
    self.jobListModel.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [[NSMutableArray alloc]init];//@[@"高级经理",@"运营主管",@"安卓实习生",@"运营实习生",@"Java高级开发",@"前端工程师"];
    self.current = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布职位" style:UIBarButtonItemStylePlain target:self action:@selector(publishJob:)];
    [self loaddataWith:@"1"];
    [self addDefaultHeader];
}

//请求数据
- (void)loaddataWith:(NSString *)pageNo{
    [self.jobListModel setPageNo:pageNo];//首页加载可以不设置
    [_jobListModel FetchDataWithSuccess:^(NSArray *responseArray) {
        if (responseArray.count) {
            [_dataArray addObjectsFromArray:responseArray];
            if (responseArray.count == 10) {
                if (!self.tableview.mj_footer) {
                    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
                }
            } else {
                self.tableview.mj_footer = nil;
            }
            [self.tableview reloadData];
        }
        [self.tableview.mj_header endRefreshing];
    } failureWithFailure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
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

- (void)loadNextPage{
    [self loaddataWith:[NSString stringWithFormat:@"%ld",self.current]];
}

//下拉刷新方法
- (void)addDefaultHeader{
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loaddataWith:@"1"];
    }];
}

- (void)publishJob:(UIBarButtonItem *)sender{
    JobInfoViewController *jvc = [[JobInfoViewController alloc]init];
    [self.navigationController pushViewController:jvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    JobModel *job = _dataArray[indexPath.section];
    cell.textLabel.text = job.name;
    cell.detailTextLabel.text = job.showDate;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobModel *job = _dataArray[indexPath.section];
    JobInfoViewController *jvc = [[JobInfoViewController alloc]init];
    jvc.JobInfoId = job.jobId;
    [self.navigationController pushViewController:jvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",NSStringFromClass([textField.superview class]));
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
