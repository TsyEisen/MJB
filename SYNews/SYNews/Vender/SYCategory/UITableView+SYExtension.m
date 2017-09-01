
#import "UITableView+SYExtension.h"

@implementation UITableView (SYExtension)
#pragma mark - 注册cell
- (void)sy_registerNibWithClass:(Class)customClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(customClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(customClass)];
}
- (void)sy_registerCellWithClass:(Class)customClass {
    [self registerClass:customClass forCellReuseIdentifier:NSStringFromClass(customClass)];
}

#pragma mark - 注册SectionHeaderFooter
- (void)sy_registerNibForSectionHeaderFooterWithClass:(Class)customClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(customClass) bundle:nil]  forHeaderFooterViewReuseIdentifier:NSStringFromClass(customClass)];
}
- (void)sy_registerClassForSectionHeaderFooterWithClass:(Class)customClass {
    [self registerClass:customClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(customClass)];
}

@end

