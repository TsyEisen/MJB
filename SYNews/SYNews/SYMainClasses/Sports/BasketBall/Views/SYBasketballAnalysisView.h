//
//  SYBasketballAnalysisView.h
//  SYNews
//
//  Created by leju_esf on 2019/1/7.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYBasketballAnalysisView : UIView
+ (instancetype)viewFromNib;
@property (nonatomic, strong) NSArray *datas;
@end

NS_ASSUME_NONNULL_END
