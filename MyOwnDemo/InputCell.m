//
//  InputCell.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "InputCell.h"

@implementation InputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = COLOR_LGTGRAYTEXT;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.infoTextField.font = [UIFont systemFontOfSize:14];}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
