//
//  SYGameTableCell.h
//  SYNews
//
//  Created by leju_esf on 2018/9/28.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYDataLabel : UILabel
@property (nonatomic, assign) BOOL red;
@end

@interface SYGameTableCell : UITableViewCell
@property (nonatomic, strong) SYGameListModel *model;
@end
