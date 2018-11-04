//
//  SYDataAnalysisView.h
//  SYNews
//
//  Created by 冯娇娇 on 2018/11/4.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYResultModel : NSObject
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL red;
@end

@interface SYDataAnalysisModel : NSObject
@property (nonatomic, copy) NSString *oneStr;
@property (nonatomic, copy) NSString *twoStr;
@property (nonatomic, copy) NSString *threeStr;
@property (nonatomic, copy) NSString *fourStr;

+ (instancetype)modelWithTitle:(NSString *)title statusCount:(NSInteger)status statusRedCount:(NSInteger)statusRedCount total:(NSInteger)total;

+ (instancetype)modelWithTitle:(NSString *)title
                      statusGL:(NSNumber *)statusGL
                      globalGL:(NSNumber *)globalGL
                     gameCount:(NSString *)gameCount;

+ (instancetype)modelWithTitle:(NSString *)title home:(NSInteger)home draw:(NSInteger)draw away:(NSInteger)away total:(NSInteger)total;

+ (instancetype)modelWithOne:(NSString *)one two:(NSString *)two three:(NSString *)three four:(NSString *)four;
@end


@interface SYDataAnalysisView : UIView
+ (instancetype)viewFromNib;
@property (nonatomic, strong) NSArray *datas;
@end

NS_ASSUME_NONNULL_END
