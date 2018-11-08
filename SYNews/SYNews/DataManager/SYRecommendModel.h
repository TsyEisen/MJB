//
//  SYRecommendModel.h
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYRecommendModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger tag;
//@property (nonatomic, strong,readonly) NSArray *datas;
- (void)saveModel:(SYGameListModel *)model;
- (void)changeModelInformation:(SYGameListModel *)model;
- (void)deleteModel:(SYGameListModel *)model;
+ (NSArray *)models;
- (NSArray *)datas;
@end
