//
//  SYGameDetailView.h
//  SYNews
//
//  Created by leju_esf on 2018/9/29.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGameDetailView : UIView
+ (instancetype)viewFromNib;
@property (nonatomic, strong) SYGameListModel *model;
@end
