//
//  SYBasketballListCell.h
//  SYNews
//
//  Created by leju_esf on 2019/1/3.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYBasketBallModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SYBasketballListCell : UITableViewCell
@property (nonatomic, strong) SYBasketBallModel *model;
@property (nonatomic, strong) SYBasketBallModel *currentGame;
@end

NS_ASSUME_NONNULL_END
