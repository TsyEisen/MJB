//
//  SYDateAnalysisCell.m
//  SYNews
//
//  Created by leju_esf on 2019/1/28.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYDateAnalysisCell.h"

@interface SYDateAnalysisCell()
@property (weak, nonatomic) IBOutlet UILabel *top1;
@property (weak, nonatomic) IBOutlet UILabel *top2;
@property (weak, nonatomic) IBOutlet UILabel *top3;
@property (weak, nonatomic) IBOutlet UILabel *top4;
@property (weak, nonatomic) IBOutlet UILabel *bottom1;
@property (weak, nonatomic) IBOutlet UILabel *bottom2;
@property (weak, nonatomic) IBOutlet UILabel *bottom3;
@property (weak, nonatomic) IBOutlet UILabel *bottom4;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation SYDateAnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(SYHomeAwayPushModel *)model {
    _model = model;
    
    _timeLabel.text = model.time;
    
    _top1.text = [NSString stringWithFormat:@"主: %zd/%zd",model.homePush_red,model.homePush];
    _top2.text = [NSString stringWithFormat:@"总: %zd/%zd/%zd",model.homePush_red + model.awayPush_red,model.homePush + model.awayPush,model.total];
    _top3.text = [NSString stringWithFormat:@"主: %zd/%zd",model.homePush_normal_red,model.homePush];
    _top4.text = [NSString stringWithFormat:@"总: %zd/%zd/%zd",model.homePush_normal_red + model.awayPush_normal_red,model.homePush + model.awayPush,model.total];
    
    _bottom1.text = [NSString stringWithFormat:@"客: %zd/%zd",model.awayPush_red,model.awayPush];
    _bottom2.text = model.homePush_red + model.awayPush_red > (model.homePush + model.awayPush)*0.5 ? @"红" : @"黑";
    _bottom2.textColor = model.homePush_red + model.awayPush_red > (model.homePush + model.awayPush)*0.5 ? [UIColor redColor] : [UIColor sy_colorWithRGB:0x333333];
    _bottom3.text = [NSString stringWithFormat:@"客: %zd/%zd",model.awayPush_normal_red,model.awayPush];
    _bottom4.text = model.homePush_normal_red + model.awayPush_normal_red > (model.homePush + model.awayPush)*0.5 ? @"红" : @"黑";
    _bottom4.textColor = model.homePush_normal_red + model.awayPush_normal_red > (model.homePush + model.awayPush)*0.5 ? [UIColor redColor] : [UIColor sy_colorWithRGB:0x333333];
}

@end

@implementation SYHomeAwayPushModel
@end
