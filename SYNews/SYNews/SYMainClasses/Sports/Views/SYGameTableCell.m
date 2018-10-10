//
//  SYGameTableCell.m
//  SYNews
//
//  Created by leju_esf on 2018/9/28.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameTableCell.h"

@implementation SYGameTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat w = SYGameTableCellWidth;
    CGFloat h = SYGameTableCellHeight;
    for (int i = 0; i < 10; i++) {
        SYDataLabel *label = [[SYDataLabel alloc] initWithFrame:CGRectMake(i*w, 0, w, h)];
        label.tag = i;
        [self.contentView addSubview:label];
    }
}

- (void)setModel:(SYGameListModel *)model {
    _model = model;
    
    NSMutableArray *temp_pay = [NSMutableArray array];
    NSMutableArray *temp_kelly = [NSMutableArray array];
    NSMutableArray *temp_gl = [NSMutableArray array];
    
    SYNumberModel *pay_home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:model.BfAmountHome/model.totalPAmount];
    SYNumberModel *pay_draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:model.BfAmountDraw/model.totalPAmount];
    SYNumberModel *pay_away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:model.BfAmountAway/model.totalPAmount];
    [temp_pay addObjectsFromArray:@[pay_home,pay_draw,pay_away]];
    
    SYNumberModel *kelly_home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:model.KellyHome];
    SYNumberModel *kelly_draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:model.KellyDraw];
    SYNumberModel *kelly_away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:model.KellyAway];
    [temp_kelly addObjectsFromArray:@[kelly_home,kelly_draw,kelly_away]];
    
    SYNumberModel *gl_home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:model.BfIndexHome/100];
    SYNumberModel *gl_draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:model.BfIndexDraw/100];
    SYNumberModel *gl_away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:model.BfIndexAway/100];
    [temp_gl addObjectsFromArray:@[gl_home,gl_draw,gl_away]];
    NSSortDescriptor *numSD = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:NO];
    NSArray *pay_array = [[temp_pay sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
    NSArray *kelly_array = [[temp_kelly sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
    NSArray *gl_array = [[temp_gl sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
    
    SYGameScoreType type = SYGameScoreTypeHome;
    
    if ([model.homeScore integerValue] == [model.awayScore integerValue]) {
        type = SYGameScoreTypeDraw;
    }else if ([model.homeScore integerValue] < [model.awayScore integerValue]) {
        type = SYGameScoreTypeAway;
    }
    
    
    SYGameScoreType sigle_pay_type = model.MaxTeamId == model.HomeTeamId?SYGameScoreTypeHome : SYGameScoreTypeAway;
    
    SYNumberModel *sigle_pay = [SYNumberModel modelWithStatus:sigle_pay_type num:model.MaxTradedChange/10000];
    
    for (SYDataLabel *label in self.contentView.subviews) {
        switch (label.tag) {
            case 0:
                label.model = gl_array[0];
                label.type = type;
                break;
            case 1:
                label.model = gl_array[1];
                label.type = type;
                break;
            case 2:
                label.model = gl_array[2];
                label.type = type;
                break;
            case 3:
                label.model = pay_array[0];
                label.type = type;
                break;
            case 4:
                label.model = pay_array[1];
                label.type = type;
                break;
            case 5:
                label.model = pay_array[2];
                label.type = type;
                break;
            case 6:
                label.model = kelly_array[0];
                label.type = type;
                break;
            case 7:
                label.model = kelly_array[1];
                label.type = type;
                break;
            case 8:
                label.model = kelly_array[2];
                label.type = type;
                break;
            case 9:
                label.model = sigle_pay;
                label.type = type;
                break;
            default:
                break;
        }
    }
}

@end

@implementation SYDataLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor sy_colorWithRGB:0x333333];
        self.font = [UIFont boldSystemFontOfSize:10];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor sy_colorWithRGB:0xdddddd].CGColor;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setModel:(SYNumberModel *)model {
    _model = model;
    NSString *name = @"主";
    if (model.status == SYGameScoreTypeAway) {
        name = @"客";
    }else if (model.status == SYGameScoreTypeDraw){
        name = @"平";
    }
    if (model.num > 1) {
        self.text = [NSString stringWithFormat:@"%@%.f",name,model.num];
    }else {
        self.text = [NSString stringWithFormat:@"%@%.2f",name,model.num];
    }
}

- (void)setType:(SYGameScoreType)type {
    _type = type;
    self.red = type == self.model.status;
}

- (void)setRed:(BOOL)red {
    _red = red;
    if (red) {
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor redColor];
    }else {
        self.textColor = [UIColor sy_colorWithRGB:0x333333];
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
