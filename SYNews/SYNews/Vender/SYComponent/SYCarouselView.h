//
//  SYCarouselView.h
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/10.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYHomeNewsModel.h"

@interface SYCarouselCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end

@interface SYCarouselView : UIView
@property(nonatomic,copy) void(^clickAction)(NSString *newId);
@property (nonatomic, strong) NSArray *adList;
@end
