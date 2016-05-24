//
//  ViewController.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "JobListViewController.h"
#import "JobInfoViewController.h"
#import "JobListViewModel.h"
#import "JobModel.h"

@interface JobListViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) JobListViewModel *jobListVM;
@property (nonatomic) NSInteger current;
@end

@implementation JobListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        self.jobListVM = [[JobListViewModel alloc]init];
        self.jobListVM.delegate = self;
        self.current = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    [self loadDataWith:@"1"];
}

- (void)layoutUI{
    self.title = @"职位列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布职位" style:UIBarButtonItemStylePlain target:self action:@selector(publishJob:)];
    [self addDefaultHeader];//添加下拉刷新
}

//请求数据
- (void)loadDataWith:(NSString *)pageNo{
    [self.jobListVM setPageNo:pageNo];//首页加载可以不设置
    [self.jobListVM FetchDataWithSuccess:^(NSArray *responseArray) {
        [self endRefresh];
        if ([pageNo isEqualToString:@"1"]) {
            self.current = 1;
            [self.dataArray removeAllObjects];
        }
        if (responseArray.count) {
            //抛开后台测试的时候可以放在这里判断是否显示上拉加载
            if (responseArray.count == 15) {
                [self addDefaultFooter];
            } else {
                [self HideFooter];
            }
            
            [self.dataArray addObjectsFromArray:responseArray];
            [self.tableview reloadData];
        }
    } failureWithFailure:^(NSError *error) {
        //网络错误相应的处理
        [self endRefresh];
    }];
}

//上拉加载更多
- (void)loadNextPage{
    self.current++;
    [self loadDataWith:[NSString stringWithFormat:@"%ld",self.current]];
}

- (void)publishJob:(UIBarButtonItem *)sender{
    JobInfoViewController *jvc = [[JobInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
    jvc.title = @"发布职位";
    [self.navigationController pushViewController:jvc animated:YES];
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    JobModel *job = self.dataArray[indexPath.section];
    cell.textLabel.text = job.name;
    cell.detailTextLabel.text = job.showDate;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobModel *job = self.dataArray[indexPath.section];
    JobInfoViewController *jvc = [[JobInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
    jvc.JobInfoId = job.jobId;
    jvc.title = @"编辑职位";
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
