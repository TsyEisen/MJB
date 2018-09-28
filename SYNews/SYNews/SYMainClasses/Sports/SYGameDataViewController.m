//
//  SYGameDataViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameDataViewController.h"
#import "SYGameModel.h"

@interface SYGameDataViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *payFlatLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *glWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *glFlatLabel;
@property (weak, nonatomic) IBOutlet UILabel *glLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *fcWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fcFlatLabel;
@property (weak, nonatomic) IBOutlet UILabel *fcLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsFlatLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTotal;
@property (nonatomic, strong) SYGameModel *model;
@end

@implementation SYGameDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SYCommentRequest requestGaneDataWithKeyWord:self.eventId completion:^(id result, NSError *error) {
        if (result) {
            self.model = result;
        }
    }];
}

- (void)setModel:(SYGameModel *)model {
    _model = model;
    //    NSDate *date = [NSDate sy_dateWithString:model.Match.MatchTime formate:@"yyyy-MM-ddTHH:mm:ss"];
    self.timeLabel.text = model.Match.MatchTime;
    self.payTotal.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfAmountHome + model.BaseInfo.BfAmountAway + model.BaseInfo.BfAmountDraw];
    self.title = [NSString stringWithFormat:@"%@ vs %@",model.Match.HomeTeam,model.Match.GuestTeam];
    self.payWinLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfPerHome];
    self.payFlatLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfPerDraw];
    self.payLoseLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfPerAway];
    self.glWinLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfIndexHome];
    self.glFlatLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfIndexDraw];
    self.glLoseLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfIndexAway];
    self.fcWinLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.KellyHome];
    self.fcFlatLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.KellyDraw];
    self.fcLoseLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.KellyAway];
    
    self.jsWinLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfPerHome * model.BaseInfo.BfIndexHome / model.BaseInfo.KellyHome];
    self.jsFlatLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfPerDraw * model.BaseInfo.BfIndexDraw / model.BaseInfo.KellyDraw];
    self.jsLoseLabel.text = [NSString stringWithFormat:@"%.02f",model.BaseInfo.BfPerDraw * model.BaseInfo.BfIndexAway / model.BaseInfo.KellyAway];
}

@end
