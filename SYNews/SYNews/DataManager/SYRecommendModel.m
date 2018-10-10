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
@end

@implementation SYRecommendModel

- (void)saveModel:(SYGameListModel *)model {
    
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

- (NSMutableArray *)list {
    if (_list == nil) {
        _list = [[NSMutableArray alloc] initWithContentsOfFile:self.path];
    }
    return _list;
}
@end
