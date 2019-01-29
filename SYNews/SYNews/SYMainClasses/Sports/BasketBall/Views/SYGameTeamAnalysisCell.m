//
//  SYGameTeamAnalysisCell.m
//  SYNews
//
//  Created by leju_esf on 2019/1/29.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYGameTeamAnalysisCell.h"

@interface SYGameTeamAnalysisCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *top1;
@property (weak, nonatomic) IBOutlet UILabel *top2;
@property (weak, nonatomic) IBOutlet UILabel *top3;
@property (weak, nonatomic) IBOutlet UILabel *top4;
@property (weak, nonatomic) IBOutlet UILabel *middle1;
@property (weak, nonatomic) IBOutlet UILabel *middle2;
@property (weak, nonatomic) IBOutlet UILabel *middle3;
@property (weak, nonatomic) IBOutlet UILabel *middle4;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation SYGameTeamAnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SYGameTeamModel *)model {
    _model = model;
    self.timeLabel.text = model.name;
    
    if (model.homePush == 0) {
        _top1.text = @"0/0";
    }else {
        _top1.text = [NSString stringWithFormat:@"主: %zd/%zd\n(%.2f)",model.homePush_red,model.homePush,model.homePush_red * 1.0/model.homePush];
    }
    
    if (model.homePush + model.awayPush == 0) {
        _top2.text = @"0/0";
    }else {
        _top2.text = [NSString stringWithFormat:@"总: %zd/%zd\n(%.2f)",model.homePush_red + model.awayPush_red,model.homePush + model.awayPush,(model.homePush_red + model.awayPush_red) * 1.0/(model.homePush + model.awayPush)];
    }
    
    if (model.homePush == 0) {
        _top3.text = @"0/0";
    }else {
        _top3.text = [NSString stringWithFormat:@"主: %zd/%zd\n(%.2f)",model.homePush_normal_red,model.homePush,model.homePush_normal_red * 1.0/model.homePush];
    }
    
    if (model.homePush + model.awayPush == 0) {
        _top4.text = @"0/0";
    }else {
        _top4.text = [NSString stringWithFormat:@"总: %zd/%zd\n(%.2f)",model.homePush_normal_red + model.awayPush_normal_red,model.homePush + model.awayPush,(model.homePush_normal_red + model.awayPush_normal_red) * 1.0/(model.homePush + model.awayPush)];
    }
    
    if (model.awayPush == 0) {
        _middle1.text = @"0/0";
    }else {
        _middle1.text = [NSString stringWithFormat:@"客: %zd/%zd\n(%.2f)",model.awayPush_red,model.awayPush,model.awayPush_red * 1.0/model.awayPush];
    }
    
    if (model.awayPush == 0) {
        _middle3.text = @"0/0";
    }else {
        _middle3.text = [NSString stringWithFormat:@"客: %zd/%zd\n(%.2f)",model.awayPush_normal_red,model.awayPush,model.awayPush_normal_red * 1.0/model.awayPush];
    }
    
}
@end

@implementation SYGameTeamModel

@end
