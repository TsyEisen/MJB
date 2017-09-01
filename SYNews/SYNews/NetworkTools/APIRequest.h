//
//  APIRequest.h
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APIRequestMethod) {
    APIRequestMethodGet,
    APIRequestMethodHead,
    APIRequestMethodPost,
    APIRequestMethodPut,
    APIRequestMethodPatch,
    APIRequestMethodDelete
};

@interface APIRequest : NSObject

@property (nonatomic) APIRequestMethod method;

@property (nonatomic, copy) NSString *apiPath;

@property (nonatomic, copy) NSDictionary *parameters;

@end
