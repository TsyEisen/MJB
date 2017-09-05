//
//  SYDiscoverCell.m
//  SYNews
//
//  Created by leju_esf on 2017/9/4.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYDiscoverCell.h"

@interface SYDiscoverCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation SYDiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SYDiscoverNewsModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:DefaultPlaceHolder];
    self.titleDesLabel.text = model.Title;
    self.timeLabel.text = [model.CreatTime substringToIndex:16];
    self.countLabel.text = [NSString stringWithFormat:@"Read %@ times",model.ReadCount];
}
@end
