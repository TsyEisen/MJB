//
//  SYHomeNewsCell.m
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeNewsCell.h"

@interface SYHomeNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SYHomeNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SYHomeNewsModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:DefaultPlaceHolder];
    self.titleLabel.text = model.title;
    self.desLabel.text = model.Summary;
    self.timeLabel.text = @"Today";
}
@end
