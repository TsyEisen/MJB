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
@end
