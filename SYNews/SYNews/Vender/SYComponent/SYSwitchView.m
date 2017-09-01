//
//  SYSwitchView.m
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYSwitchView.h"

@interface SYSwitchView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation SYSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.line];
        [self addSubview:self.bottomLine];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    CGFloat totalW = 0;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *item = [[UIButton alloc] init];
        item.titleLabel.font = [UIFont systemFontOfSize:14];
        
        NSString *title = self.titles[i];
        [item setTitle:title forState:UIControlStateNormal];
        
        item.tag = 100 + i;
        CGFloat w = title.length * 7 + 15;
        item.frame = CGRectMake(totalW, 0, w, self.sy_height-2);
        totalW += w;
        
        if (i == 0) {
            self.selectedBtn = item;
            [item setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
            self.line.sy_width = w;
        }else {
            [item setTitleColor:[UIColor sy_colorWithRGB:0x999999] forState:UIControlStateNormal];
        }
        [item addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:item];
    }
    self.scrollView.contentSize = CGSizeMake(totalW, 0);
}

- (void)buttonAction:(UIButton *)sender {
    if (self.selectedBtn == sender) {
        return;
    }
    
    [self.selectedBtn setTitleColor:[UIColor sy_colorWithRGB:0x999999] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
    self.selectedBtn = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.line.sy_width = sender.sy_width;
        self.line.sy_x = sender.sy_x;
    }];
    
    if (self.selectBlock) {
        self.selectBlock(sender.tag -100);
    }
}

- (void)setIndex:(NSInteger)index {
    if (index != self.selectedBtn.tag - 100) {
        UIButton *currentBtn = [self viewWithTag:index + 100];
        [self.selectedBtn setTitleColor:[UIColor sy_colorWithRGB:0x999999] forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
        self.selectedBtn = currentBtn;
        [UIView animateWithDuration:0.25 animations:^{
            self.line.sy_width = currentBtn.sy_width;
            self.line.sy_x = currentBtn.sy_x;
        }];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = @[@"Headline",@"Business",@"Shanghai",@"China",@"World",@"Sport",@"Feature"];
    }
    return _titles;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] initWithFrame: CGRectMake(0, self.sy_height - 2,0,2)];
        _line.backgroundColor = [UIColor appMainColor];
    }
    return _line;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - 0.5, self.sy_width,0.5)];
        _bottomLine.backgroundColor = [UIColor lineDefaultColor];
    }
    return _bottomLine;
}

@end
