//
//  SYDataProbability.m
//  SYNews
//
//  Created by leju_esf on 2018/12/6.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYDataProbability.h"

@implementation SYSportDataProbability
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"kellys":@"SYDataProbability"
             };
}
@end

@implementation SYDataProbability
+ (instancetype)modelWithType:(SYHDAType)type home:(NSInteger)home draw:(NSInteger)draw away:(NSInteger)away total:(NSInteger)total {
    SYDataProbability *model = [SYDataProbability new];
    model.type = type;
    if (total != 0) {
        model.gl_home = home * 1.0/total;
        model.count_home = home;
        model.gl_draw = draw * 1.0/total;
        model.count_draw = draw;
        model.gl_away = away * 1.0/total;
        model.count_away = away;
        model.total = total;
    }
    return model;
}
@end
