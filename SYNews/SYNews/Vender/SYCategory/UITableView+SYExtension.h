
#import <UIKit/UIKit.h>

@interface UITableView (SYExtension)

#pragma mark - 注册cell
/**
 *  注册自定义cell(有xib)
 *
 *  @param customClass 类名
 */
- (void)sy_registerNibWithClass:(Class)customClass;
/**
 *  注册自定义cell(无xib)
 *
 *  @param customClass 类名
 */
- (void)sy_registerCellWithClass:(Class)customClass;

#pragma mark - 注册SectionHeaderFooter
/**
 *  注册自定义header footer (有xib)
 *
 *  @param customClass 类名
 */
- (void)sy_registerNibForSectionHeaderFooterWithClass:(Class)customClass;
/**
 *  注册自定义header footer (无xib)
 *
 *  @param customClass 类名
 */
- (void)sy_registerClassForSectionHeaderFooterWithClass:(Class)customClass;
@end
