//
//  SYRenameView.h
//  SYNews
//
//  Created by leju_esf on 2018/11/8.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYRenameView : UIView
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UITextField *homeTextField;
@property (weak, nonatomic) IBOutlet UITextField *awayTextField;
+ (instancetype)viewFromNib;
@end

NS_ASSUME_NONNULL_END
