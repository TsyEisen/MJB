//
//  SYRecommendPicker.m
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYRecommendPicker.h"

@interface SYRecommendPicker()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation SYRecommendPicker
- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
        __weak typeof(self) weakSelf = self;
        [self setDoneAction:^{
            [weakSelf completionAction];
        }];
    }
    return self;
}

- (void)completionAction {
    SYRecommendModel *model = [[SYSportDataManager sharedSYSportDataManager].recommends objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    NSInteger row = [self.pickerView selectedRowInComponent:1];
    SYGameScoreType type;
    switch (row) {
        case 0:
            type = SYGameScoreTypeHome|SYGameScoreTypeDraw;
            break;
        case 1:
            type = SYGameScoreTypeHome;
            break;
        case 2:
            type = SYGameScoreTypeDraw;
            break;
        case 3:
            type = SYGameScoreTypeAway;
            break;
        case 4:
            type = SYGameScoreTypeAway|SYGameScoreTypeDraw;
            break;
    }
    self.model.recommendType = type;
    [model saveModel:self.model];
    [MBProgressHUD showSuccess:@"收藏成功" toView:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? [SYSportDataManager sharedSYSportDataManager].recommends.count : 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[row];
        return model.name;
    }else {
        switch (row) {
            case 0:
                return @"主不败";
                break;
            case 1:
                return @"胜";
                break;
            case 2:
                return @"平";
                break;
            case 3:
                return @"负";
                break;
            case 4:
                return @"客不败";
                break;
            default:
                return nil;
                break;
        }
    }
}
@end
