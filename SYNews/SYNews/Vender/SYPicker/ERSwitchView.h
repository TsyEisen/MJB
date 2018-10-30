//
//  RPSwithView.h
//  RoomPrice
//
//  Created by leju_esf on 16/4/25.
//  Copyright © 2016年 leju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ERSwitchView : UIView
@property (nonatomic, copy) void(^buttonAciton)(NSInteger index);

@property (nonatomic, copy) void(^longPressAction)(NSInteger index);
/**
 当前索引
 */
@property (nonatomic, assign) NSInteger index;
/**
 标题数组
 */
@property (nonatomic, strong) NSArray *titles;
/**
 自定义索引,默认是从0 开始,可以不设置
 @[@(0),@(1)]或者@[@"0",@"1"]
 */
@property (nonatomic, strong) NSArray *indexs;
@property (nonatomic, strong) UIColor *selectedColor;
/**
 默认为 0
 */
@property (nonatomic, assign) CGFloat minMargin;
@end
