//
//  ChoosePickerView.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/23.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "ChoosePickerView.h"
#import "BaseModel.h"
#import "MJExtension.h"
#define BUTTON_WIDTH 50
#define HEAD_HEIGHT 30
#define PICKER_HEIGHT 200
#define VIEW_DURATION 0.5

@implementation ChoosePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
        [self getInfo];
    }
    return self;
}

- (void)setUpHeadView{
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, HEAD_HEIGHT)];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(BUTTON_WIDTH, 0, VIEW_WIDTH - BUTTON_WIDTH*2, HEAD_HEIGHT)];
    _titleLabel.backgroundColor = [UIColor whiteColor];

    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];

    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH - BUTTON_WIDTH, 0, BUTTON_WIDTH, HEAD_HEIGHT)];
    confirmButton.backgroundColor = [UIColor whiteColor];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
}

- (void)cancel{
    [UIView animateWithDuration:VIEW_DURATION animations:^{
        CGRect rect = self.frame;
        rect.origin.y = VIEW_HEIGHT;
        self.frame = rect;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(VIEW_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)confirmAction{
    if (self.confirm) {
        NSString *string;
        if (self.viewType) {
            BaseModel *chooseType = [_otherInfoArray objectAtIndex:_viewType - 1];
            BaseModel *chooseName = [chooseType.choices objectAtIndex:[self.choosePicker selectedRowInComponent:0]];
            string = chooseName.name;
        } else {
            BaseModel *chooseProvince = [_areaArray objectAtIndex:[self.choosePicker selectedRowInComponent:0]];
            BaseModel *chooseArea = [chooseProvince.cities objectAtIndex:[self.choosePicker selectedRowInComponent:1]];
            string = [NSString stringWithFormat:@"%@ %@",chooseProvince.name, chooseArea.name];
        }
        self.confirm(string,_viewType);
    }
    [self cancel];
}

- (void)show{
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:VIEW_DURATION animations:^{
        CGRect rect = self.frame;
        rect.origin.y = VIEW_HEIGHT - HEAD_HEIGHT - PICKER_HEIGHT;
        self.frame = rect;
    }];
    [self.choosePicker reloadAllComponents];
    [self.choosePicker selectRow:0 inComponent:0 animated:YES];
}

- (void)getInfo{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"json"];
    NSDictionary *pubDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    _areaArray = [BaseModel mj_objectArrayWithKeyValuesArray:pubDict[@"provinces"]];
    _otherInfoArray = [BaseModel mj_objectArrayWithKeyValuesArray:pubDict[@"dict"]];
}

- (void)setUpView{
    [self setUpHeadView];
    _choosePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, HEAD_HEIGHT, VIEW_WIDTH, PICKER_HEIGHT)];
    _choosePicker.delegate = self;
    _choosePicker.dataSource = self;
    _choosePicker.backgroundColor = [UIColor grayColor];
    [self addSubview:_choosePicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_viewType) {
        return 1;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger count;
    if (_viewType) {
        BaseModel *choose = [_otherInfoArray objectAtIndex:_viewType - 1];
        count = choose.choices.count;
    } else {
        if (component) {
            BaseModel *choose = [_areaArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            count = choose.cities.count;
        } else {
            count = _areaArray.count;
        }
    }
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_viewType) {
        BaseModel *chooseType = [_otherInfoArray objectAtIndex:_viewType - 1];
        BaseModel *chooseName = [chooseType.choices objectAtIndex:row];
        return chooseName.name;
    } else {
        if (component) {
            BaseModel *chooseProv = [_areaArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            BaseModel *chooseCity = [chooseProv.cities objectAtIndex:row];
            return chooseCity.name;
        } else {
            BaseModel *chooseProvince = [_areaArray objectAtIndex:row];
            return chooseProvince.name;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0 && !_viewType) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
}
@end
