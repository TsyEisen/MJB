//
//  ListRequestManager.h
//  redpoppy
//
//  Created by leju_esf on 2018/7/17.
//  Copyright © 2018年 Hale Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ListRequestPageType) {
    ListRequestPageTypeHomeSport,
    ListRequestPageTypeCatagorySport,
    ListRequestPageTypeGameDetail
};

@interface ListRequestManager : NSObject
- (instancetype)initWithType:(ListRequestPageType)type;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, assign) ListRequestPageType type;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy) void(^reloadOtherData)(id info);
@property (nonatomic, copy) void(^reloadData)(NSIndexPath *indexPath);
- (void)loadNewData;
- (void)loadMoreData;
@end
