//
//Created by ESJsonFormatForMac on 18/09/21.
//

#import "SYGameModel.h"
@implementation SYGameModel

//- (NSDate *)sy_date {
//    if (_sy_date == nil) {
//        
//    }
//}

- (NSString *)sportName {
    if (_sportName == nil) {
        if (self.Match) {
            NSArray *array = [self.Match.MatchPath componentsSeparatedByString:@"\\"];
            _sportName = array[2];
        }
    }
    return _sportName;
}
@end

@implementation Baseinfohighest


@end


@implementation Match


@end


@implementation Baseinfolowest


@end


@implementation Baseinfo


@end


