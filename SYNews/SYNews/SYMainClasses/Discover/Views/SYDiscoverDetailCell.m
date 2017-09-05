//
//  SYDiscoverDetailCell.m
//  SYNews
//
//  Created by leju_esf on 2017/9/4.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYDiscoverDetailCell.h"

@interface SYDiscoverDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;

@end

@implementation SYDiscoverDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.englishLabel.textColor = [UIColor appMainColor];
}

- (void)setModel:(SYDiscoverDetailModel *)model {
    _model = model;
    self.englishLabel.text = model.Sentence;
    self.chineseLabel.text = model.sentence_cn;
}
@end
