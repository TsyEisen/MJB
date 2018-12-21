//
//Created by ESJsonFormatForMac on 18/12/13.
//

#import "SYGameResultModel.h"
@implementation SYGameResultModel

- (NSInteger)dateSeconds {
    if (_dateSeconds == 0) {
        NSDate *date = [NSDate sy_dateWithString:self.time formate:@"yyyyMMddHHmmss"];
        _dateSeconds = [date timeIntervalSince1970];
    }
    return _dateSeconds;
}
@end

