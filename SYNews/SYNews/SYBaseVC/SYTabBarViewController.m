//
//  SYTabBarViewController.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYTabBarViewController.h"
#import "SYNavgationViewController.h"
#import "SYBaseViewController.h"

@interface SYTabBarViewController ()
@property (nonatomic, strong) NSArray *childVCModels;
@property (nonatomic, strong) UIImageView *line;

@end

@implementation SYTabBarViewController

- (instancetype)init {
    if (self = [super init]) {
        
        self.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBar.tintColor = [UIColor sy_colorWithRGB:0xE73859];
        self.tabBar.backgroundColor = [UIColor whiteColor];
        [self.tabBar addSubview:self.line];
        
        for (SYChildVCModel *model in self.childVCModels) {
            NSString*nibPath = [[NSBundle mainBundle] pathForResource:model.className ofType:@"nib"];
            SYBaseViewController *baseVc = [[NSClassFromString(model.className) alloc] init];
            if (nibPath) {
                baseVc = [(SYBaseViewController *)[NSClassFromString(model.className) alloc] initWithNibName:model.className bundle:nil];
            }
            
            if ([model.className isEqualToString:@"SYListViewController"]) {
                [baseVc setValue:@(model.type) forKey:@"type"];
            }
            
            SYNavgationViewController *nvaVc = [[SYNavgationViewController alloc] initWithRootViewController:baseVc];
//            baseVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:model.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:model.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            baseVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:model.imageName] selectedImage:[UIImage imageNamed:model.selectedImageName]];
            baseVc.tabBarItem.title = model.title;
            baseVc.title = model.title;
            [self addChildViewController:nvaVc];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)childVCModels {
    if (_childVCModels == nil) {
        _childVCModels = [SYChildVCModel tabBarVcModels];
    }
    return _childVCModels;
}

- (UIImageView *)line {
    if (_line == nil) {
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 2)];
        _line.image = [UIImage imageNamed:@"tab_line"];
    }
    return _line;
}

@end

@implementation SYChildVCModel

+ (NSArray *)moreVcModels {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SYMoreVCData" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return [SYChildVCModel mj_objectArrayWithKeyValuesArray:array];
}
+ (NSArray *)tabBarVcModels {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SYViewControllerData" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return [SYChildVCModel mj_objectArrayWithKeyValuesArray:array];
}

@end
