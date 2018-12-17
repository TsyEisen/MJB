//
//Created by ESJsonFormatForMac on 18/12/13.
//

#import <Foundation/Foundation.h>

/*
 {
 "sid": 1648074,
 "sclassID": 805,
 "state": -1,
 "time": "20181212183000",
 "time2": "20181212193400",
 "hTeam": "里烙汉后备队",
 "gTeam": "南区后备队",
 "hOrder": "",
 "gOrder": "",
 "hScore": "1",
 "gScore": "2",
 "hHScore": "0",
 "gHScore": "2",
 "hRed": "0",
 "gRed": "0",
 "hYellow": "0",
 "gYellow": "1",
 "hCorner": "8",
 "gCorner": "2",
 "hWin": "",
 "gWin": "",
 "draw": "",
 "letGoal": "",
 "hOdds": "",
 "gOdds": "",
 "totalGoal": "",
 "upOdds": "",
 "downOdds": "",
 "ifVideo": false,
 "explain": "",
 "isGoalC": 0,
 "isWfc": 0,
 "isJc": 0
 }
 */

@interface SYGameResultModel : NSObject

@property (nonatomic, copy) NSString *hOrder;

@property (nonatomic, copy) NSString *hWin;

@property (nonatomic, copy) NSString *draw;

@property (nonatomic, copy) NSString *hHScore;

@property (nonatomic, copy) NSString *gTeam;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *gScore;

@property (nonatomic, copy) NSString *gYellow;

@property (nonatomic, copy) NSString *downOdds;

@property (nonatomic, assign) NSInteger isWfc;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *letGoal;

@property (nonatomic, copy) NSString *time2;

@property (nonatomic, copy) NSString *hYellow;

@property (nonatomic, assign) NSInteger isGoalC;

@property (nonatomic, copy) NSString *gOrder;

@property (nonatomic, assign) NSInteger isJc;

@property (nonatomic, copy) NSString *hOdds;

@property (nonatomic, assign) BOOL ifVideo;

@property (nonatomic, copy) NSString *sclassID;

@property (nonatomic, copy) NSString *upOdds;

@property (nonatomic, copy) NSString *gRed;

@property (nonatomic, copy) NSString *explain;

@property (nonatomic, copy) NSString *gOdds;

@property (nonatomic, copy) NSString *gCorner;

@property (nonatomic, copy) NSString *hRed;

@property (nonatomic, copy) NSString *hScore;

@property (nonatomic, copy) NSString *hCorner;

@property (nonatomic, copy) NSString *totalGoal;

@property (nonatomic, copy) NSString *gWin;

@property (nonatomic, copy) NSString *hTeam;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *gHScore;

@end
