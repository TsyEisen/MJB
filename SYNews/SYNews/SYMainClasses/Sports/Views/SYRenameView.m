//
//  SYRenameView.m
//  SYNews
//
//  Created by leju_esf on 2018/11/8.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYRenameView.h"

@interface SYRenameView ()

@end

@implementation SYRenameView

+ (instancetype)viewFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].firstObject;
}

@end
