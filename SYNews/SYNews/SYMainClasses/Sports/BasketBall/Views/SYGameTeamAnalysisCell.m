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
    self.timeLabel.text = [model.name stringByAppendingFormat:@"(%@)",model.rank];
    
    if (model.homeCount == 0) {
        _top1.text = @"0/0/0";
    }else {
        
        if (model.homePush == 0) {
            _top1.text = [NSString stringWithFormat:@"主: %zd/%zd/%zd\n0",model.homePush_red,model.homePush,model.homeCount];
        }else {
            _top1.text = [NSString stringWithFormat:@"主: %zd/%zd/%zd\n(%.2f)",model.homePush_red,model.homePush,model.homeCount,model.homePush_red * 1.0/model.homePush];
        }
        
    }
    
    if (model.homeUnPush == 0) {
        _top2.text = @"0/0";
    }else {
        _top2.text = [NSString stringWithFormat:@"非: %zd/%zd\n(%.2f)",model.homeUnPush_red,model.homeUnPush,model.homeUnPush_red * 1.0/model.homeUnPush];
    }
    
    if (model.homeCount == 0) {
        _top3.text = @"0/0/0";
    }else {
        
        if (model.homePush == 0) {
            _top3.text = [NSString stringWithFormat:@"主: %zd/%zd/%zd\n0",model.homePush_normal_red,model.homePush,model.homeCount];
        }else {
            _top3.text = [NSString stringWithFormat:@"主: %zd/%zd/%zd\n(%.2f)",model.homePush_normal_red,model.homePush,model.homeCount,model.homePush_normal_red * 1.0/model.homePush];
        }
    }
    
    if (model.homeUnPush == 0) {
        _top4.text = @"0/0";
    }else {
        _top4.text = [NSString stringWithFormat:@"非: %zd/%zd\n(%.2f)",model.homeUnPush_normal_red,model.homeUnPush,model.homeUnPush_normal_red * 1.0/model.homeUnPush];
    }
    
    if (model.awayCount == 0) {
        _middle1.text = @"0/0/0";
    }else {
        if (model.awayPush == 0) {
            _middle1.text = [NSString stringWithFormat:@"客: %zd/%zd/%zd\n0",model.awayPush_red,model.awayPush,model.awayCount];
        }else {
            _middle1.text = [NSString stringWithFormat:@"客: %zd/%zd/%zd\n(%.2f)",model.awayPush_red,model.awayPush,model.awayCount,model.awayPush_red * 1.0/model.awayPush];
        }
    }
    
    if (model.awayUnPush == 0) {
        _middle2.text = @"0/0";
    }else {
        _middle2.text = [NSString stringWithFormat:@"非: %zd/%zd\n(%.2f)",model.awayUnPush_red,model.awayUnPush,model.awayUnPush_red * 1.0/model.awayUnPush];
    }
    
    
    if (model.awayCount == 0) {
        _middle3.text = @"0/0/0";
    }else {
        if (model.awayPush == 0) {
            _middle3.text = [NSString stringWithFormat:@"客: %zd/%zd/%zd\n0",model.awayPush_normal_red,model.awayPush,model.awayCount];
        }else {
            _middle3.text = [NSString stringWithFormat:@"客: %zd/%zd/%zd\n(%.2f)",model.awayPush_normal_red,model.awayPush,model.awayCount,model.awayPush_normal_red * 1.0/model.awayPush];
        }
    }
    
    if (model.awayUnPush == 0) {
        _middle4.text = @"0/0";
    }else {
        _middle4.text = [NSString stringWithFormat:@"非: %zd/%zd\n(%.2f)",model.awayUnPush_normal_red,model.awayUnPush,model.awayUnPush_normal_red * 1.0/model.awayUnPush];
    }
}
@end

@implementation SYGameTeamModel

@end
