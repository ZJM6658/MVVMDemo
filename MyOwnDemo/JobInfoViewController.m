//
//  PersonInfoViewController.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "JobInfoViewController.h"
#import "JobViewModel.h"
#import "JobModel.h"
#import "MJExtension.h"
#import "BaseModel.h"
#import "InputCell.h"
#import "ChoosePickerView.h"

@interface JobInfoViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong)NSArray *placeholderArray;
@property (nonatomic, strong)UITextView *descView;
@property (nonatomic, strong)JobViewModel *jobViewModel;
@property (nonatomic, strong)NSDictionary *pubDict;
@property (nonatomic, strong)ChoosePickerView *choosePV;

@end

@implementation JobInfoViewController

#pragma mark - initialize
- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        self.jobViewModel = [[JobViewModel alloc]init];
        self.jobViewModel.delegate = self;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.choosePV cancel];
}

//页面布局
- (void)layoutUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setChooseView];
    [self.tableview registerNib:[UINib nibWithNibName:@"InputCell" bundle:nil] forCellReuseIdentifier:@"infocell"];
    self.dataArray = [@[@[@"公司名称", @"职位名称"], @[@"工作区域", @"职位类型", @"工作经验", @"薪资待遇", @"学历要求"], @[@"简历投递"]]copy];
    _placeholderArray = @[@[@"输入公司名称", @"输入职位名称"], @[@"输入工作区域", @"输入职位类型", @"输入薪资待遇", @"输入工作经验", @"输入学历要求"], @[@"输入邮箱(例如:123@163.com)"]];
    NSString *rightButtonTitle;
    if (self.JobInfoId) {
        rightButtonTitle = @"保存";
        [self.jobViewModel setJobId:self.JobInfoId];
        [self.jobViewModel FetchDataWithSuccess:^(NSArray *responseArray) {
            if (responseArray.count) {
                self.jobViewModel.jobInfo = [responseArray firstObject];
                [self.tableview reloadData];
            }
        } failureWithFailure:^(NSError *error) {
            //网络错误
        }];
    } else {
        rightButtonTitle = @"发布";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:rightButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(saveJob:)];
}

//创建选择视图
- (void)setChooseView{
    self.choosePV = [[ChoosePickerView alloc]initWithFrame:CGRectMake(0, VIEW_HEIGHT, VIEW_WIDTH, 230)];
    __block typeof(self) weakSelf = self;
    self.choosePV.confirm = ^(NSString *info, NSInteger type){
        switch (type) {
            case 0:
                weakSelf.jobViewModel.jobInfo.areaName = info;
                break;
            case 1:
                weakSelf.jobViewModel.jobInfo.typeName = info;
                break;
            case 2:
                weakSelf.jobViewModel.jobInfo.experienceName = info;
                break;
            case 3:
                weakSelf.jobViewModel.jobInfo.salaryName = info;
                break;
            case 4:
                weakSelf.jobViewModel.jobInfo.degreeName = info;
                break;
            default:
                break;
        }
        [weakSelf.tableview reloadData];
    };
}

//保存或发布
- (void)saveJob:(UIBarButtonItem *)sender{
    [self.tableview endEditing:YES];
    [self.choosePV cancel];
    self.jobViewModel.modelType = self.JobInfoId?1:2;
    [self.jobViewModel FetchDataWithSuccess:^(NSArray *responseArray) {
        //发布或保存成功后的处理
        [self.navigationController popViewControllerAnimated:YES];
    } failureWithFailure:^(NSError *error) {
        //网络错误
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableview endEditing:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.dataArray.count) {
        return 1;
    } else {
        NSArray *arr = self.dataArray[section];
        return arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Textviewcell"];
        if (cell == nil) {
            cell = [[InputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Textviewcell"];
        }
        if (!_descView) {
            _descView = [[UITextView alloc]initWithFrame:cell.frame];
            _descView.delegate = self;
            [cell addSubview:_descView];
        }
        if (self.jobViewModel.jobInfo.Description) {
            _descView.text = [NSString stringWithString:self.jobViewModel.jobInfo.Description];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        InputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell"];
        if (cell == nil) {
            cell = [[InputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infocell"];
        }
        
        NSArray *arr = self.dataArray[indexPath.section];
        cell.nameLabel.text = arr[indexPath.row];
        NSArray *placearr = _placeholderArray[indexPath.section];
        cell.infoTextField.placeholder = placearr[indexPath.row];
        cell.infoTextField.tag = 100 + indexPath.section * 10 + indexPath.row;
        cell.infoTextField.delegate = self;
        if (self.jobViewModel.jobInfo) {
            [self layoutCellAtIndexPath:indexPath AndCell:cell];
        }
        if (indexPath.section == 1) {
            cell.infoTextField.userInteractionEnabled = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView endEditing:YES];
    if (indexPath.section == 1) {
        InputCell *cell = (InputCell *)[tableView cellForRowAtIndexPath:indexPath];
        self.choosePV.titleLabel.text = cell.nameLabel.text;
        self.choosePV.viewType = indexPath.row;
        [self.choosePV show];
    } else {
        [self.choosePV cancel];
    }
}

- (void)layoutCellAtIndexPath:(NSIndexPath *)indexpath AndCell:(InputCell *)cell{
    NSInteger section = indexpath.section;
    NSInteger row = indexpath.row;
    NSString *string;
    if (section == 0) {
        if (row == 0) {
            string = self.jobViewModel.jobInfo.companyName;
        } else {
            string = self.jobViewModel.jobInfo.name;
        }
    } else if (section == 1) {
        switch (row) {
            case 0:
                string = self.jobViewModel.jobInfo.areaName;
                break;
            case 1:
                string = self.jobViewModel.jobInfo.typeName;
                break;
            case 2:
                string = self.jobViewModel.jobInfo.experienceName;
                break;
            case 3:
                string = self.jobViewModel.jobInfo.salaryName;
                break;
            case 4:
                string = self.jobViewModel.jobInfo.degreeName;
                break;
            default:
                break;
        }
      } else if (section == 2) {
          string = self.jobViewModel.jobInfo.email;
      }
    cell.infoTextField.text = string;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataArray.count) {
        return 80;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == self.dataArray.count) {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headLabel = [[UILabel alloc]init];
    if (section == self.dataArray.count) {
        headLabel.font = [UIFont systemFontOfSize:12];
        headLabel.textColor = COLOR_LGTGRAYTEXT;
        headLabel.text = @"       职位描述";
    }
    return headLabel;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.choosePV cancel];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
            self.jobViewModel.jobInfo.companyName = textField.text;
            break;
        case 101:
            self.jobViewModel.jobInfo.name = textField.text;
            break;
        case 120:
            self.jobViewModel.jobInfo.email = textField.text;
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.jobViewModel.jobInfo.Description = textView.text;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.choosePV cancel];
}
@end
