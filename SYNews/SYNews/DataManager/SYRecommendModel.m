//
//  SYRecommendModel.m
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYRecommendModel.h"

@interface SYRecommendModel ()
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *jsons;
@end

@implementation SYRecommendModel

- (void)saveModel:(SYGameListModel *)model {
    if (self.list.count > 0) {
        SYGameListModel *item = self.list.lastObject;
        if (item.EventId == model.EventId) {
            if (model.recommendType == 0) {
                model.recommendType = item.recommendType;
            }
            [self.list removeLastObject];
            [self.list addObject:model];
        }else {
            [self.list addObject:model];
        }
    }else {
        [self.list addObject:model];
    }
    
    [self.jsons setObject:[model mj_keyValues] forKey:[NSString stringWithFormat:@"%zd",model.EventId]];
    [self.jsons writeToFile:self.path atomically:YES];
}

- (void)changeModelInformation:(SYGameListModel *)model {
    if ([self.jsons.allKeys containsObject:[NSString stringWithFormat:@"%zd",model.EventId]]) {
        [self saveModel:model];
    }
}

- (NSString *)path {
    if (_path == nil) {
        _path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"SYRecommend/SYRecommend_%zd",self.tag]];
    }
    return _path;
}

- (NSArray *)datas {
    return self.list;
}

- (NSMutableDictionary *)jsons {
    if (_jsons == nil) {
        _jsons = [[NSMutableDictionary alloc] initWithContentsOfFile:self.path];
        if (_jsons) {
            _jsons = [NSMutableDictionary dictionary];
        }
    }
    return _jsons;
}

- (NSMutableArray *)list {
    if (_list == nil) {
        if (self.jsons.count > 0) {
            _list = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.jsons.allValues];
        }else {
            _list = [NSMutableArray array];
        }
    }
    return _list;
}
@end
