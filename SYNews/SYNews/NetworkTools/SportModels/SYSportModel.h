//
//  SYSportModel.h
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYSportModel : NSObject
@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, copy) NSString *Eng;
@property (nonatomic, copy) NSString *Chs;
@property (nonatomic, copy) NSString *FullName;
@property (nonatomic, copy) NSString *SortName;
@property (nonatomic, strong) NSNumber *Classification;
@property (nonatomic, strong) NSNumber *SportTypeId;
@end
