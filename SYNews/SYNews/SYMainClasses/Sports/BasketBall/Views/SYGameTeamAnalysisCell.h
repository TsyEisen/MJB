//
//  SYGameTeamAnalysisCell.h
//  SYNews
//
//  Created by leju_esf on 2019/1/29.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYGameTeamModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, assign) NSInteger homeCount;
@property (nonatomic, assign) NSInteger awayCount;
@property (nonatomic, assign) NSInteger homePush;
@property (nonatomic, assign) NSInteger awayPush;
@property (nonatomic, assign) NSInteger homePush_red;
@property (nonatomic, assign) NSInteger awayPush_red;
@property (nonatomic, assign) NSInteger homePush_normal_red;
@property (nonatomic, assign) NSInteger awayPush_normal_red;

@property (nonatomic, assign) NSInteger homeUnPush;
@property (nonatomic, assign) NSInteger awayUnPush;
@property (nonatomic, assign) NSInteger homeUnPush_red;
@property (nonatomic, assign) NSInteger awayUnPush_red;
@property (nonatomic, assign) NSInteger homeUnPush_normal_red;
@property (nonatomic, assign) NSInteger awayUnPush_normal_red;
@end

@interface SYGameTeamAnalysisCell : UITableViewCell
@property (nonatomic, strong) SYGameTeamModel *model;
@end

NS_ASSUME_NONNULL_END
