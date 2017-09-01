//
//  SYHomeNewsModel.h
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHomeNewsModel : NSObject
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Summary;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *image;
@end

@interface SYNewsDetailModel : NSObject
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSArray *captions;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSArray *images;
@end
