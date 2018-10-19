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
    if (self.list.count > 0 && model.recommendType > 0) {
        SYGameListModel *exitItem = nil;
        for (SYGameListModel *item in self.list) {
            if (item.EventId == model.EventId) {
                exitItem = item;
            }
        }
        
        if (exitItem) {
            if (model.recommendType == 0) {
                model.recommendType = exitItem.recommendType;
            }
            [self.list replaceObjectAtIndex:[self.list indexOfObject:exitItem] withObject:model];
        }else {
            if (model.recommendType > 0) {
                [self.list addObject:model];
            }
        }
    
    }else {
        if (model.recommendType > 0) {
            [self.list addObject:model];
        }
    }
    
    [self.jsons setObject:[model mj_keyValues] forKey:[NSString stringWithFormat:@"%zd",model.EventId]];
    [self.jsons writeToFile:self.path atomically:YES];
}

- (void)changeModelInformation:(SYGameListModel *)model {
    NSDictionary *dict = [self.jsons objectForKey:[NSString stringWithFormat:@"%zd",model.EventId]];
    if (dict) {
        model.recommendType = [dict[@"recommendType"] integerValue];
        [self.jsons setObject:[model mj_keyValues] forKey:[NSString stringWithFormat:@"%zd",model.EventId]];
        [self.jsons writeToFile:self.path atomically:YES];
    }
}

- (void)deleteModel:(SYGameListModel *)model {
    [self.list removeObject:model];
    [self.jsons removeObjectForKey:[NSString stringWithFormat:@"%zd",model.EventId]];
    [self.jsons writeToFile:self.path atomically:YES];
}

- (NSString *)path {
    if (_path == nil) {
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"SYRecommend"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL isDirExist = [fileManager fileExistsAtPath:directory isDirectory:&isDir];
        if(!(isDirExist && isDir)){
            BOOL bCreateDir = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
                if(!bCreateDir){
                    NSLog(@"创建文件夹失败！");
                }
        }
        _path = [directory stringByAppendingFormat:@"/SYRecommend_%zd.plist",self.tag];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_path]) {
            [[NSFileManager defaultManager] createFileAtPath:_path contents:nil attributes:nil];
        }
    }
    return _path;
}

- (NSArray *)datas {
    return self.list;
}

- (NSMutableDictionary *)jsons {
    if (_jsons == nil) {
        _jsons = [[NSMutableDictionary alloc] initWithContentsOfFile:self.path];
        if (_jsons == nil) {
            _jsons = [NSMutableDictionary dictionary];
        }
    }
    return _jsons;
}

- (NSMutableArray *)list {
    if (_list == nil) {
        if (self.jsons.count > 0) {
            NSArray *array = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.jsons.allValues];
            NSSortDescriptor *contidion = [NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:YES];
            array = [array sortedArrayUsingDescriptors:@[contidion]];
            _list = [NSMutableArray arrayWithArray:array];
        }else {
            _list = [NSMutableArray array];
        }
    }
    return _list;
}
@end
