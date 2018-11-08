//
//  SYAddNewRecommendView.m
//  SYNews
//
//  Created by leju_esf on 2018/11/8.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYAddNewRecommendView.h"

@interface SYAddNewRecommendView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SYAddNewRecommendView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = self.isAdd;
    self.tableView.tableFooterView = [UIView new];
}

- (void)setIsAdd:(BOOL)isAdd {
    _isAdd = isAdd;
    self.tableView.hidden = isAdd;
}

+ (instancetype)viewFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].firstObject;
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SYSportDataManager sharedSYSportDataManager].recommends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor sy_colorWithRGB:0x333333];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath;
}

- (void)setSelectedIndex:(NSIndexPath *)selectedIndex {
    UITableViewCell *lastcell = [self.tableView cellForRowAtIndexPath:_selectedIndex];
    lastcell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndex];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedIndex = selectedIndex;
}
@end
