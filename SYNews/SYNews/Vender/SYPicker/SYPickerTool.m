//
//  SYPickerTool.m
//  SYPicker
//
//  Created by leju_esf on 16/10/31.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYPickerTool.h"
#import "SYPickerViewTool.h"

@interface SYPickerTool ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) SYPickerViewTool *pickerViewTool;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation SYPickerTool

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.pickerViewTool.pickerView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataSource[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

- (void)show {
    [self.pickerViewTool show];
}

- (SYPickerViewTool *)pickerViewTool {
    if (_pickerViewTool == nil) {
        _pickerViewTool = [[SYPickerViewTool alloc] init];
        _pickerViewTool.delegate = self;
        __weak typeof(self) weakSelf = self;
        [_pickerViewTool setDoneAction:^{
            if (weakSelf.dataSource.count > 0) {
                weakSelf.doneAction(weakSelf.selectedIndex,weakSelf.dataSource[weakSelf.selectedIndex]);
            }
        }];
        
        _pickerViewTool.cancelAction = self.cancelAction;
    }
    return _pickerViewTool;
}
@end
