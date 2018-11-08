//
//  SYAddNewRecommendView.h
//  SYNews
//
//  Created by leju_esf on 2018/11/8.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAddNewRecommendView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, assign) BOOL isAdd;
+ (instancetype)viewFromNib;
@end

NS_ASSUME_NONNULL_END
