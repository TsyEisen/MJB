//
//  SYDateAnalysisCell.h
//  SYNews
//
//  Created by leju_esf on 2019/1/28.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYHomeAwayPushModel : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger homePush;
@property (nonatomic, assign) NSInteger awayPush;
@property (nonatomic, assign) NSInteger homePush_red;
@property (nonatomic, assign) NSInteger awayPush_red;
@property (nonatomic, assign) NSInteger homePush_normal_red;
@property (nonatomic, assign) NSInteger awayPush_normal_red;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger single_score;
@property (nonatomic, assign) NSInteger double_score;
@end


@interface SYDateAnalysisCell : UITableViewCell
@property (nonatomic, strong) SYHomeAwayPushModel *model;
@end

NS_ASSUME_NONNULL_END
