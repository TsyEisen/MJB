//
//  SYGameListModel.m
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameListModel.h"
#import "NSDate+SYExtension.h"

@implementation SYGameListModel
- (CGFloat)totalPAmount {
    return self.BfAmountHome + self.BfAmountAway + self.BfAmountDraw;
}

- (NSInteger)dateSeconds {
    if (_dateSeconds == 0) {
        NSDate *date = [NSDate sy_dateWithString:[self.MatchTime stringByReplacingOccurrencesOfString:@"T" withString:@"-"] formate:@"yyyy-MM-dd-HH:mm:ss"];
        _dateSeconds = [date timeIntervalSince1970];
    }
    return _dateSeconds;
}

- (NSInteger)updateSeconds {
    if (_updateSeconds == 0) {
        NSDate *date = [NSDate sy_dateWithString:[self.MaxUpdateTime stringByReplacingOccurrencesOfString:@"T" withString:@"-"] formate:@"yyyy-MM-dd-HH:mm:ss"];
        _updateSeconds = [date timeIntervalSince1970];
    }
    return _updateSeconds;
}

- (SYGameScoreType)resultType {
    SYGameScoreType type = 0;
    if (self.score.length > 0) {
        if ([self.homeScore integerValue] == [self.awayScore integerValue]) {
            type = SYGameScoreTypeDraw;
        }else if ([self.homeScore integerValue] < [self.awayScore integerValue]) {
            type = SYGameScoreTypeAway;
        }else if ([self.homeScore integerValue] > [self.awayScore integerValue]){
            type = SYGameScoreTypeHome;
        }
    }
    return type;
}

- (NSString *)HomeTeam {
    NSString *name = [[SYSportDataManager sharedSYSportDataManager].replaceNames objectForKey:self.HomeTeamId];
    if (name.length > 0) {
        return name;
    }
    return _HomeTeam;
}

- (NSString *)AwayTeam {
    NSString *name = [[SYSportDataManager sharedSYSportDataManager].replaceNames objectForKey:self.AwayTeamId];
    if (name.length > 0) {
        return name;
    }
    return _AwayTeam;
}

- (NSString *)SortName {
    if ([_SortName isEqualToString:@"日联杯"]) {
        return @"日职";
    }else if ([_SortName isEqualToString:@"J2联赛"]) {
        return @"日乙";
    }else {
        return _SortName;
    }
}

@end

@implementation SYNumberModel
+ (instancetype)modelWithStatus:(SYGameScoreType)type num:(CGFloat)num {
    SYNumberModel *model = [SYNumberModel new];
    model.status = type;
    model.num = num;
    return model;
}
@end
