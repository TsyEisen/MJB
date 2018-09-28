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

@end

@implementation SYNumberModel
+ (instancetype)modelWithStatus:(SYGameScoreType)type num:(CGFloat)num {
    SYNumberModel *model = [SYNumberModel new];
    model.status = type;
    model.num = num;
    return model;
}
@end
