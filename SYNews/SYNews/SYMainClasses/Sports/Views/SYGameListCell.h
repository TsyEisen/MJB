//
//  SYGameListCell.h
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/23.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGameListModel.h"

@interface SYGameListCell : UITableViewCell
@property (nonatomic, strong) SYGameListModel *model;
@property(nonatomic,assign)BOOL recommend;
@end
