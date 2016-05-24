//
//  ChoosePickerView.h
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/23.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^confirmChooseInfo)(NSString *info, NSInteger type);

@interface ChoosePickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) NSArray *otherInfoArray;
@property (nonatomic) NSInteger viewType;
@property (nonatomic, strong) UIPickerView *choosePicker;
@property (nonatomic, copy) confirmChooseInfo confirm;
- (void)show;
- (void)cancel;
@end
