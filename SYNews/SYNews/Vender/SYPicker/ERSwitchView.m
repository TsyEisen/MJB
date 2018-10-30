//
//  ERSwitchView.m
//  RoomPrice
//
//  Created by sy_esf on 16/4/25.
//  Copyright © 2016年 leju. All rights reserved.
//

#import "ERSwitchView.h"

#define BaseTag 1000

@interface ERSwitchView ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ERSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedColor = [UIColor appMainColor];
        _minMargin = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    for (UIView *sub in self.subviews) {
        if (sub.tag >= 100) {
            [sub removeFromSuperview];
        }
    }
    [self setUpUI];
}

- (void)setIndexs:(NSArray *)indexs {
    _indexs = indexs;
    if (indexs.count > 0 && self.selectedBtn) {
        for (UIView *sub in self.subviews) {
            if (sub.tag > 100) {
                UIButton *btn = (UIButton *)sub;
                if ([self.titles containsObject:btn.titleLabel.text]) {
                    NSInteger index = [self.titles indexOfObject:btn.titleLabel.text];
                    if ([self.indexs objectAtIndex:index]) {
                        sub.tag = [[indexs objectAtIndex:index] integerValue] + BaseTag;
                    }
                }
            }
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.line.backgroundColor = selectedColor;
    [self.selectedBtn setTitleColor:self.selectedColor forState:UIControlStateNormal];
}

- (void)setMinMargin:(CGFloat)minMargin {
    if (minMargin > _minMargin) {
        _minMargin = minMargin;
    }

    if (self.selectedBtn) {

        NSInteger count = 0;
        for (int i = 0; i< self.titles.count; i++) {
            NSString *title = self.titles[i];
            count += title.length;
        }

        CGFloat w = self.bounds.size.width;
        if (w == 0) {
            w = ScreenW;
        }
        CGFloat lastX = 0;
        CGFloat marginX = MAX((w - (count * 15) - 10 * self.titles.count)/(self.titles.count + 1), minMargin) ;
        for (UIView *sub in self.subviews) {
            UIButton *btn = (UIButton *)sub;
            if (btn.tag >= 100) {
                btn.frame = CGRectMake(lastX + marginX, 0, btn.titleLabel.text.length * 15 + 10, self.bounds.size.height);
            }
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.line.frame = CGRectMake(self.selectedBtn.sy_x, self.selectedBtn.sy_height - 3, self.selectedBtn.sy_width, 3);
        }];

        self.scrollView.contentSize = marginX > _minMargin ? CGSizeMake(self.sy_width, self.sy_height):CGSizeMake(lastX + marginX, self.sy_height);
    }
}

- (void)setUpUI {

    NSInteger count = 0;
    for (int i = 0; i< self.titles.count; i++) {
        NSString *title = self.titles[i];
        count += title.length;
    }

    CGFloat w = self.bounds.size.width;
    if (w == 0) {
        w = ScreenW;
    }

    CGFloat lastX = 0;
    CGFloat marginX = MAX((w - (count * 15) - 10 * self.titles.count)/(self.titles.count + 1), _minMargin) ;

    for (int i = 0; i< self.titles.count; i++) {
        NSString *title = self.titles[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor sy_colorWithRGB:0x333333] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        NSInteger index = [self.indexs objectAtIndex:i] == nil ? i : [[self.indexs objectAtIndex:i] integerValue];
        btn.tag = index+BaseTag;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(lastX + marginX, 0, title.length * 15 + 10, self.bounds.size.height);
        [self.scrollView addSubview:btn];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFun:)];
        longPress.minimumPressDuration = 3;
        [btn addGestureRecognizer:longPress];

        if (i == 0) {
            [btn setTitleColor:self.selectedColor forState:UIControlStateNormal];
            self.selectedBtn = btn;
        }
        lastX = CGRectGetMaxX(btn.frame);
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - 0.5, self.sy_width, 0.5)];
    line.backgroundColor = [UIColor lineDefaultColor];
    [self addSubview:line];

    self.scrollView.contentSize = marginX > _minMargin ? CGSizeMake(self.sy_width, self.sy_height):CGSizeMake(lastX + marginX, self.sy_height);
}

- (void)buttonClick:(UIButton *)sender {

    if (sender.tag == self.selectedBtn.tag) {
        return;
    }else {
        [self exchangeStatusWithButton:sender andButton:self.selectedBtn];
        self.selectedBtn = sender;
        if (self.buttonAciton) {
            self.buttonAciton(sender.tag - BaseTag);
        }
    }
}

- (void)setSelectedBtn:(UIButton *)selectedBtn {
    _selectedBtn = selectedBtn;
    _index = selectedBtn.tag - BaseTag;
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake(selectedBtn.sy_x, selectedBtn.sy_height - 3, selectedBtn.sy_width, 3);
    }completion:^(BOOL finished) {
        [self.scrollView addSubview:self.line];
    }];
}

- (void)setIndex:(NSInteger)index {
    UIButton *lastBtn = [self viewWithTag:index+BaseTag];
    if (lastBtn) {
        [self buttonClick:lastBtn];
    }
}

/**
 *  切换两个按钮的状态
 */
- (void)exchangeStatusWithButton:(UIButton *)sender1 andButton:(UIButton *)sender2 {
    [sender1 setTitleColor:self.selectedColor forState:UIControlStateNormal];
    [sender2 setTitleColor:[UIColor sy_colorWithRGB:0x333333] forState:UIControlStateNormal];
}

- (void)longPressFun:(UILongPressGestureRecognizer *)sender {
    if (self.longPressAction) {
        self.longPressAction(sender.view.tag - BaseTag);
    }
//    CGPoint point = [sender locationInView:self];
//
//    for (UIView *sub in self.subviews) {
//        if (sub.tag >= 100) {
//            if (CGRectContainsPoint(sub.frame, point)) {
//                if (self.longPressAction) {
//                    self.longPressAction(sender.view.tag - BaseTag);
//                    return;
//                }
//            }
//        }
//    }
}

#pragma mark - 懒加载
- (UIView *)line {
    if (_line == nil) {
        _line = [UIView new];
        _line.backgroundColor = self.selectedColor;
    }
    return _line;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
