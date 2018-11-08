//
//  SYAlertView.m
//  SYNews
//
//  Created by sy_esf on 2018/11/8.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYAlertView.h"
#import "SYAttributedStringModel.h"

static CGFloat margin = 20;

@interface SYAlertView ()
@property (nonatomic, strong) UIView *shadow;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *conformBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation SYAlertView

- (instancetype)initWithCustom:(UIView *)custom cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform size:(CGSize)size {
    CGFloat w = MIN(ScreenW - 2*margin*(ScreenW/320) , size.width);
    CGFloat h = size.height + 45;
    CGFloat y = (ScreenH - h)*0.5;
    CGRect frame = CGRectMake((ScreenW - w)*0.5, y, w, h);
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.allowShowAnimation = NO;
        self.allowDismissAnimation = NO;
        
        if (conform == nil && cancel == nil) {
            self.frame = CGRectMake((ScreenW - size.width)*0.5, (ScreenH - size.height)*0.5, size.width, size.height);
            if (custom) {
                custom.frame = self.bounds;
                [self addSubview:custom];
            }
        }else {
            if (custom) {
                custom.frame = CGRectMake(0, 0, self.sy_width, self.sy_height - 45);
                [self addSubview:custom];
            }
            
            [self addSubview:self.line];
            
            if (cancel == nil) {
                self.cancelBtn.sy_width = 0;
                self.conformBtn.sy_width = w;
                self.conformBtn.sy_x = 0;
            }else {
                [self.cancelBtn setTitle:cancel forState:UIControlStateNormal];
            }
            
            if (conform == nil) {
                self.cancelBtn.sy_width = w;
                self.conformBtn.sy_width = 0;
            }else {
                [self.conformBtn setTitle:conform forState:UIControlStateNormal];
            }
            
            [self addSubview:self.conformBtn];
            [self addSubview:self.cancelBtn];
        }
    }
    return self;
}

//- (CGRect)messageFrameWithMessage:(id)message WithLabel:(UILabel *)messageLabel {
//    CGSize size = CGSizeZero;
//    if ([message isKindOfClass:[NSAttributedString class]]) {
//        size = [ERAttributedStringModel sizeForAttributedString:message withLabelWidth:self.bounds.size.width - 30];
//    }else if ([message isKindOfClass:[NSString class]]) {
//        size = [message sizeWithMaxSize:CGSizeMake(self.bounds.size.width - 30, MAXFLOAT) andFont:messageLabel.font];
//    }
//    if (size.height < self.bounds.size.height - 84) {
//        return CGRectMake(15, 40, self.bounds.size.width - 30, self.bounds.size.height - 94);
//    }else {
//        return CGRectMake(15, 40, self.bounds.size.width - 30, size.height);
//    }
//}

- (instancetype)initWithTitle:(id)title message:(id)message cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform {
    UIView *customView = [[UIView alloc] init];
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [customView addGestureRecognizer:tap];
    if (title) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        if ([title isKindOfClass:[NSString class]]) {
            titleLabel.text = title;
        }else if ([title isKindOfClass:[NSAttributedString class]]) {
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithAttributedString:title];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            [attriStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attriStr.length)];
            titleLabel.attributedText = attriStr;
        }
        [customView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(customView).offset(15);
            make.right.equalTo(customView).offset(-15);
            make.top.equalTo(customView).offset(10);
            make.height.mas_equalTo(30);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineDefaultColor];
        [customView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(customView);
            make.top.equalTo(customView).offset(40);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    if (message) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textColor = [UIColor darkTextColor];
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        if ([message isKindOfClass:[NSString class]]) {
            messageLabel.text = message;
        }else if ([message isKindOfClass:[NSAttributedString class]]) {
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithAttributedString:message];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            [attriStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attriStr.length)];
            messageLabel.attributedText = attriStr;
        }
        
        messageLabel.numberOfLines = 0;
        [customView addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(customView).offset(15);
            make.right.equalTo(customView).offset(-15);
            make.bottom.equalTo(customView).offset(-10);
            make.top.equalTo(customView).offset(title==nil?10:45);
        }];
    }
    
    CGSize size = CGSizeZero;
    if ([message isKindOfClass:[NSAttributedString class]]) {
        size = [((NSAttributedString *)message) sy_sizeWithWidth:250];
        // iOS8 计算偏差
        if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
            size = CGSizeMake(size.width, size.height + 20);
        }
    }else if ([message isKindOfClass:[NSString class]]) {
        size = [((NSString *)message) sy_sizeWithWidth:250 andFont:15];
    }
    
    if (title) {
        size.height = size.height + 55;
    }else {
        size.height += 20;
    }
    
    if (size.height < 120) {
        size.height = 120;
    }else if (size.height > ScreenH - 45) {
        size.height = ScreenH - 45;
    }
    
    return [self initWithCustom:customView cancelButtonTitle:cancel conformButtonTitle:conform size:CGSizeMake(280, size.height)];
}

- (instancetype)initWithCustom:(UIView *)custom cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform {
    //CGFloat w = ScreenW - 2*margin*(ScreenW/320);
    CGFloat w = 280;
    CGFloat h = w*5/7 - 45;
    return  [self initWithCustom:custom cancelButtonTitle:cancel conformButtonTitle:conform size:CGSizeMake(w, h)];
}

- (instancetype)initWithMessage:(id)message cancelButtonTitle:(NSString *)cancel conformButtonTitle:(NSString *)conform {
    return [self initWithTitle:nil message:message cancelButtonTitle:cancel conformButtonTitle:conform];
}

#pragma mark - 点击手势
-(void)tapAction:(id)sender{
    if (_viewClickBlock) {
        _viewClickBlock();
    }
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollview.scrollEnabled = YES;
    self.scrollView = scrollview;
    [window addSubview:self.shadow];
    [window addSubview:scrollview];
    [scrollview addSubview:self];
    if (self.allowShowAnimation) {
        [self popAnimation];
    }
    [window bringSubviewToFront:scrollview];
}

- (void)dismiss {
    if (self.allowShowAnimation) {
        [self dismissAnimation];
    }else {
        [self.shadow removeFromSuperview];
        [self.scrollView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (void)cancelButtonClick {
    if (self.cancleAction) {
        self.cancleAction();
    }
    [self dismiss];
}

- (void)conformButtonClick {
    BOOL success = NO;
    if(self.conformActionBlock) {
        success = self.conformActionBlock();
        if(success) {
            [self dismiss];
        }
        return;
    }
    if (self.conformAction) {
        self.conformAction();
    }
    [self dismiss];
}

- (void)dismissAction {
    if (self.allowTapBackgroundDismiss) {
        [self dismiss];
    }
}

#pragma mark - 懒加载
- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, self.sy_height - 45, self.sy_width*0.5, 45);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)conformBtn {
    if (_conformBtn == nil) {
        _conformBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _conformBtn.frame = CGRectMake(self.sy_width*0.5, self.sy_height - 45, self.sy_width*0.5, 45);
        _conformBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _conformBtn.backgroundColor = [UIColor appMainColor];
        [_conformBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_conformBtn addTarget:self action:@selector(conformButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conformBtn;
}

- (UIView *)shadow {
    if (_shadow == nil) {
        _shadow = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _shadow.backgroundColor = [UIColor sy_colorWithRGB:0x383838];
        _shadow.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
        [_shadow addGestureRecognizer:tap];
    }
    return _shadow;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - 45.5, self.sy_width, 0.5)];
        _line.backgroundColor = [UIColor lineDefaultColor];
    }
    return _line;
}

#pragma mark - 添加弹出动画
-(void) popAnimationLive {
    // 动画。。。
//    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.width);
//    positionAnimation.toValue = @([UIApplication sharedApplication].delegate.window.center.x);
//    positionAnimation.springBounciness = 20;
//    positionAnimation.springSpeed = 30;
//    [self.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

-(void) popAnimation {
    // 动画。。。
//    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height);
//    positionAnimation.toValue = @([UIApplication sharedApplication].delegate.window.center.y);
//    positionAnimation.springBounciness = 20;
//    positionAnimation.springSpeed = 30;
//    __weak typeof(self) weakSelf = self;
//    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        if([weakSelf showAnimationCompletionBlock]) {
//            [weakSelf showAnimationCompletionBlock]();
//        }
//    }];
//    [self.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

-(void) dismissAnimation {
//    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    offscreenAnimation.toValue = @(-self.center.y);
//    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        [self.shadow removeFromSuperview];
//        [self.scrollView removeFromSuperview];
//        [self removeFromSuperview];
//    }];
//    [self.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    
    [self.shadow removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self removeFromSuperview];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.bounds, point)) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, point)) {
            return YES;
        }
    }
    return NO;
}

@end
