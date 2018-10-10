//
//  SYScorePicker.h
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYPickerViewTool.h"

@interface SYScorePicker : SYPickerViewTool
@property (nonatomic, copy) void(^scoreAction)(NSString *homeScore,NSString *awayScore);
@end
