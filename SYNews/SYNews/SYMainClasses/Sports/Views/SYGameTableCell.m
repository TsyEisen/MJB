//
//  SYGameTableCell.m
//  SYNews
//
//  Created by leju_esf on 2018/9/28.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameTableCell.h"

@implementation SYGameTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    CGFloat w = 80;
    CGFloat h = 20;
    for (int i = 0; i < 10; i++) {
        SYDataLabel *label = [[SYDataLabel alloc] initWithFrame:CGRectMake(i*w, 0, w, h)];
        label.tag = i;
        [self.contentView addSubview:label];
    }
}

- (void)setModel:(SYGameListModel *)model {
    _model = model;
    
}

@end

@implementation SYDataLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor sy_colorWithRGB:0x333333];
        self.font = [UIFont boldSystemFontOfSize:10];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor sy_colorWithRGB:0xdddddd].CGColor;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setRed:(BOOL)red {
    _red = red;
    if (red) {
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor redColor];
    }else {
        self.textColor = [UIColor sy_colorWithRGB:0x333333];
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
