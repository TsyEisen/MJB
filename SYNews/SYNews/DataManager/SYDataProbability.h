//
//  SYDataProbability.h
//  SYNews
//
//  Created by leju_esf on 2018/12/6.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SYHDAType) {
    SYHDAType_HDA = 0,
    SYHDAType_HAD,
    SYHDAType_AHD,
    SYHDAType_ADH,
    SYHDAType_DHA,
    SYHDAType_DAH
};

@interface SYSportDataProbability : NSObject

@property (nonatomic, copy) NSString *SortName;
@property (nonatomic, strong) NSArray *kellys;

@property (nonatomic, strong) NSArray *homeRedKellyScore;
@property (nonatomic, strong) NSArray *drawRedKellyScore;
@property (nonatomic, strong) NSArray *awayRedKellyScore;
@property (nonatomic, strong) NSArray *allRedKellyScore;
@end

@interface SYDataProbability : NSObject
@property (nonatomic, assign) SYHDAType type;
@property (nonatomic, assign) double gl_home;
@property (nonatomic, assign) double gl_draw;
@property (nonatomic, assign) double gl_away;
@property (nonatomic, assign) NSInteger count_home;
@property (nonatomic, assign) NSInteger count_draw;
@property (nonatomic, assign) NSInteger count_away;
@property (nonatomic, assign) NSInteger total;
+ (instancetype)modelWithType:(SYHDAType)type home:(NSInteger)home draw:(NSInteger)draw away:(NSInteger)away total:(NSInteger)total;
@end




