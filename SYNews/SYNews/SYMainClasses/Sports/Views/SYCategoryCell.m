//
//  SYCategoryCell.m
//  SYNews
//
//  Created by leju_esf on 2018/10/9.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYCategoryCell.h"

@interface SYCategoryCell ()


@end

@implementation SYCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.layer.cornerRadius = 5;
    self.textLabel.layer.borderColor = [UIColor darkTextColor].CGColor;
    self.textLabel.layer.borderWidth = 0.5;
}

@end
