//
//  SYBasketBallModel.m
//  SYNews
//
//  Created by leju_esf on 2019/1/3.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYBasketBallModel.h"

@implementation SYBasketBallModel
- (CGFloat)totalPAmount {
    return self.BfAmountHome + self.BfAmountAway;
}

- (NSInteger)dateSeconds {
    if (_dateSeconds == 0) {
        if (self.MatchTime.length > 0) {
            NSDate *date = [NSDate sy_dateWithString:[self.MatchTime stringByReplacingOccurrencesOfString:@"T" withString:@"-"] formate:@"yyyy-MM-dd-HH:mm:ss"];
            _dateSeconds = [date timeIntervalSince1970];
        }
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

- (NSString *)showTime {
    if (_showTime == nil) {
        if (self.MatchTime.length > 0) {
            _showTime = [NSDate sy_showMatchTimeWithTime:self.MatchTime];
        }
    }
    return _showTime;
}

- (NSString *)homeGroupRank {
    if (_homeGroupRank == nil) {
        _homeGroupRank = [[SYNBADataManager sharedSYNBADataManager].ranks objectForKey:self.HomeTeam];
    }
    return _homeGroupRank;
}

- (NSString *)awayGroupRank {
    if (_awayGroupRank == nil) {
        _awayGroupRank = [[SYNBADataManager sharedSYNBADataManager].ranks objectForKey:self.AwayTeam];
    }
    return _awayGroupRank;
}
@end
