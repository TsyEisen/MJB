//
//  SYSwitchView.h
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYSwitchView : UIView
@property (nonatomic, copy) void(^selectBlock)(NSInteger index);
- (void)setIndex:(NSInteger)index;
@end
