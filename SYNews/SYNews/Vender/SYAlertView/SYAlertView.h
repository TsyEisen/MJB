//
//  SYAlertView.h
//  SYNews
//
//  Created by leju_esf on 2018/11/8.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAlertView : UIView
/**
 *  右侧确定按钮的事件
 */
@property (nonatomic, copy) void(^conformAction)();
/**
 *  左侧取消按钮的事件
 */
@property (nonatomic, copy) void(^cancleAction)();
/**
 *  View点击事件
 */
@property (nonatomic, copy) void(^viewClickBlock)();
/**
 *  右侧确定按钮的事件执行前的校验  判断是否需要执行
 */
@property (nonatomic, copy) BOOL (^conformActionBlock)();
/**
 *  展示动画结束后的回调
 */
@property (nonatomic, copy) void(^showAnimationCompletionBlock)();
/**
 *  点击背景是否消失,默认是NO
 */
@property (nonatomic, assign) BOOL allowTapBackgroundDismiss;
/**
 *  是否展示进场动画  默认NO
 */
@property (nonatomic, assign) BOOL allowShowAnimation;
/**
 *  是否展示出场动画 默认NO
 */
@property (nonatomic, assign) BOOL allowDismissAnimation;
/**
 普通的文字提示弹框
 
 @param message 提示信息,可以是NSString 也可以是富文本
 @param cancel 取消
 @param conform 确定
 @return 弹框
 */
- (instancetype)initWithMessage:(id)message cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform;

/**
 带有标题的文字提示弹框
 
 @param title 标题
 @param message 提示信息,可以是NSString 也可以是富文本
 @param cancel 取消
 @param conform 确定
 @return 弹框
 */
- (instancetype)initWithTitle:(id)title message:(id)message cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform;

/**
 自定义view的弹框
 
 @param custom 自定义view
 @param cancel 取消按钮
 @param conform 确定按钮
 @return 弹框
 */
- (instancetype)initWithCustom:(UIView *)custom cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform;
- (instancetype)initWithCustom:(UIView *)custom cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform size:(CGSize)size;

/**
 *  展示
 */
- (void)show;

/**
 *  消失
 */
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
