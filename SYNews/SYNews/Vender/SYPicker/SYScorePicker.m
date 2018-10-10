//
//  SYScorePicker.m
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYScorePicker.h"

@interface SYScorePicker()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation SYScorePicker
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
    NSString *homeScore = [self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0];
    NSString *awayScore = [self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:1] forComponent:1];
    if (self.scoreAction) {
        self.scoreAction(homeScore, awayScore);
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 11;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%zd",row];
}

@end
