//
//  PersonInfoViewController.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "InputCell.h"
#import "PersonViewModel.h"
#import "JobModel.h"
#import "MJExtension.h"

#define RGBA(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define COLOR_LGTGRAYTEXT   RGBA(170,175,187,1)
#define COLOR_PURSE         RGBA(130,143,177,1)

@interface JobInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSArray *placeholderArray;
@property (nonatomic, strong)JobModel *jobInfo;

@property (nonatomic, strong)PersonViewModel *perModel;

@end

@implementation JobInfoViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        self.perModel = [[PersonViewModel alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
    _dataArray = @[@[@"公司名称", @"职位名称"], @[@"工作区域", @"职位类型", @"薪资待遇", @"工作经验", @"学历要求"], @[@"简历投递"]];
    _placeholderArray = @[@[@"输入公司名称", @"输入职位名称"], @[@"输入工作区域", @"输入职位类型", @"输入薪资待遇", @"输入工作经验", @"输入学历要求"], @[@"输入邮箱(例如:123@163.com)"]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveJob:)];
    [self.perModel FetchDataWithSuccess:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 0) {
            NSArray *array = [JobModel mj_objectArrayWithKeyValuesArray:dictionary[@"data"][@"result"]];
            if (array.count) {
                self.jobInfo = array[0];
                [self.tableview reloadData];
            }
        }else{
            //提示错误
        }
    } failureWithFailure:^(NSError *error) {
        //网络错误
    }];

}

- (void)saveJob:(UIBarButtonItem *)sender{
    
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerNib:[UINib nibWithNibName:@"InputCell" bundle:nil] forCellReuseIdentifier:@"infocell"];
    }
    return _tableview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == _dataArray.count) {
        return 1;
    } else {
        NSArray *arr = _dataArray[section];
        return arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _dataArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Textviewcell"];
        if (cell == nil) {
            cell = [[InputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Textviewcell"];
        }
        UITextView *tview = [[UITextView alloc]initWithFrame:cell.frame];
        if (self.jobInfo.Description) {
            tview.text = self.jobInfo.Description;
        }
        [cell addSubview:tview];
        return cell;

    } else {
        InputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell"];
        if (cell == nil) {
            cell = [[InputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infocell"];
        }
        cell.nameLabel.textColor = COLOR_LGTGRAYTEXT;
        cell.nameLabel.font = [UIFont systemFontOfSize:14];
        cell.infoTextField.font = [UIFont systemFontOfSize:14];

        NSArray *arr = _dataArray[indexPath.section];
        cell.nameLabel.text = arr[indexPath.row];
        
        NSArray *placearr = _placeholderArray[indexPath.section];
        cell.infoTextField.placeholder = placearr[indexPath.row];
        
        cell.infoTextField.delegate = self;
        if (self.jobInfo) {
            [self layoutCellAtIndexPath:indexPath AndCell:cell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)layoutCellAtIndexPath:(NSIndexPath *)indexpath AndCell:(InputCell *)cell{
    NSInteger section = indexpath.section;
    NSInteger row = indexpath.row;
    NSString *string;
    if (section == 0) {
        if (row == 0) {
            string = self.jobInfo.companyName;
        } else {
            string = self.jobInfo.name;
        }
    } else if (section == 1) {
        switch (row) {
            case 0:
                string = self.jobInfo.provinceName;
                break;
            case 1:
                string = self.jobInfo.typeName;
                break;
            case 2:
                string = self.jobInfo.salaryName;
                break;
            case 3:
                string = self.jobInfo.experienceName;
                break;
            case 4:
                string = self.jobInfo.degreeName;
                break;
            default:
                break;
        }
      } else if (section == 2) {
          string = self.jobInfo.email;
      }
    cell.infoTextField.text = string;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",NSStringFromClass([textField.superview class]));
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _dataArray.count) {
        return 80;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == _dataArray.count) {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headLabel = [[UILabel alloc]init];
    if (section == _dataArray.count) {
        headLabel.font = [UIFont systemFontOfSize:12];
        headLabel.textColor = COLOR_LGTGRAYTEXT;
        headLabel.text = @"       职位描述";
    }
    return headLabel;
}

@end
