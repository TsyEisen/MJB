//
//Created by ESJsonFormatForMac on 18/09/21.
//

#import <Foundation/Foundation.h>

@class Baseinfohighest,Match,Baseinfolowest,Baseinfo;
@interface SYGameModel : NSObject

@property (nonatomic, strong) Baseinfohighest *BaseInfoHighest;

@property (nonatomic, strong) Match *Match;

@property (nonatomic, strong) Baseinfolowest *BaseInfoLowest;

@property (nonatomic, strong) Baseinfo *BaseInfo;

@property (nonatomic, copy) NSString *EventId;

@property (nonatomic, copy) NSString *sportName;
//@property (nonatomic, strong) NSDate *sy_date;

@end
@interface Baseinfohighest : NSObject

@property (nonatomic, assign) NSInteger ElAmountAway;

@property (nonatomic, assign) CGFloat UoPerOver;

@property (nonatomic, assign) CGFloat BfPerDraw;

@property (nonatomic, assign) NSInteger JcOddsAway;

@property (nonatomic, assign) NSInteger ElOddsAway;

@property (nonatomic, assign) CGFloat BfHotDraw;

@property (nonatomic, assign) CGFloat AsianIndex;

@property (nonatomic, assign) NSInteger ElStockDraw;

@property (nonatomic, assign) CGFloat BfIndexHome;

@property (nonatomic, assign) NSInteger ElPerHome;

@property (nonatomic, assign) NSInteger ElAmountHome;

@property (nonatomic, assign) CGFloat UoIndexOver;

@property (nonatomic, copy) NSString *AsianAvrLet;

@property (nonatomic, assign) CGFloat BfAmountAway;

@property (nonatomic, assign) CGFloat AsianAvrAway;

@property (nonatomic, assign) NSInteger EventId;

@property (nonatomic, assign) NSInteger ElIndexAway;

@property (nonatomic, assign) CGFloat BfPerAway;

@property (nonatomic, assign) CGFloat BfPayoutDraw;

@property (nonatomic, assign) CGFloat BfHotAway;

@property (nonatomic, assign) CGFloat UoStockOver;

@property (nonatomic, assign) NSInteger JcOddsDraw;

@property (nonatomic, assign) CGFloat The6;

@property (nonatomic, assign) CGFloat AsianAvrHome;

@property (nonatomic, assign) CGFloat BfAmountHome;

@property (nonatomic, assign) CGFloat BfStockAway;

@property (nonatomic, assign) CGFloat EuroAvrDraw;

@property (nonatomic, assign) NSInteger ElOddsDraw;

@property (nonatomic, assign) NSInteger AsianHandyGamesAway;

@property (nonatomic, assign) NSInteger ElIndexHome;

@property (nonatomic, assign) NSInteger UoAmount;

@property (nonatomic, assign) CGFloat The48;

@property (nonatomic, assign) NSInteger UoGamesUnder;

@property (nonatomic, assign) CGFloat BfStockHome;

@property (nonatomic, assign) NSInteger UoGamesOver;

@property (nonatomic, assign) CGFloat BfOddsHome;

@property (nonatomic, assign) NSInteger ElStockAway;

@property (nonatomic, copy) NSString *UpdateTime;

@property (nonatomic, assign) NSInteger MediaIndexAway;

@property (nonatomic, assign) CGFloat BfPayoutAway;

@property (nonatomic, assign) CGFloat UoAmountOver;

@property (nonatomic, assign) CGFloat UoStockUnder;

@property (nonatomic, assign) NSInteger JcIndexDraw;

@property (nonatomic, assign) NSInteger ZcIndexDraw;

@property (nonatomic, assign) CGFloat UoPerUnder;

@property (nonatomic, copy) NSString *AsianHandyGamesLine;

@property (nonatomic, assign) CGFloat CsIndex;

@property (nonatomic, assign) NSInteger ElStockHome;

@property (nonatomic, assign) CGFloat BfPayoutHome;

@property (nonatomic, assign) NSInteger BfAmount;

@property (nonatomic, assign) CGFloat BfPerHome;

@property (nonatomic, assign) CGFloat KellyDraw;

@property (nonatomic, assign) NSInteger MediaIndexHome;

@property (nonatomic, assign) CGFloat UoAmountUnder;

@property (nonatomic, assign) CGFloat BfHotHome;

@property (nonatomic, assign) CGFloat EuroAvrAway;

@property (nonatomic, assign) CGFloat UoOddsOver;

@property (nonatomic, assign) NSInteger UserIndexDraw;

@property (nonatomic, assign) NSInteger UserIndexAway;

@property (nonatomic, assign) NSInteger ElPerDraw;

@property (nonatomic, assign) NSInteger AsianHandyAway;

@property (nonatomic, assign) CGFloat EuroAvrHome;

@property (nonatomic, assign) CGFloat KellyAway;

@property (nonatomic, assign) NSInteger JcOddsHome;

@property (nonatomic, assign) NSInteger ElOddsHome;

@property (nonatomic, assign) NSInteger AsianHandyGamesHome;

@property (nonatomic, assign) CGFloat BfIndexDraw;

@property (nonatomic, assign) CGFloat UoIndexUnder;

@property (nonatomic, copy) NSString *UoGamesLine;

@property (nonatomic, assign) NSInteger MediaIndexDraw;

@property (nonatomic, assign) NSInteger UserIndexHome;

@property (nonatomic, copy) NSString *AsianHandyLine;

@property (nonatomic, assign) NSInteger ElPerAway;

@property (nonatomic, assign) CGFloat BfOddsAway;

@property (nonatomic, assign) NSInteger JcIndexAway;

@property (nonatomic, assign) NSInteger AsianHandyHome;

@property (nonatomic, assign) CGFloat The1;

@property (nonatomic, assign) NSInteger ElAmountDraw;

@property (nonatomic, assign) NSInteger ZcIndexAway;

@property (nonatomic, assign) CGFloat The24;

@property (nonatomic, assign) NSInteger ElIndexDraw;

@property (nonatomic, assign) NSInteger JcIndexHome;

@property (nonatomic, assign) CGFloat UoOddsUnder;

@property (nonatomic, copy) NSString *JcOddsLet;

@property (nonatomic, assign) NSInteger ZcIndexHome;

@property (nonatomic, assign) CGFloat BfAmountDraw;

@property (nonatomic, assign) CGFloat BfOddsDraw;

@property (nonatomic, assign) CGFloat BfStockDraw;

@property (nonatomic, assign) CGFloat BfIndexAway;

@property (nonatomic, assign) CGFloat KellyHome;

@end

@interface Match : NSObject

@property (nonatomic, copy) NSString *HomeTeamName;

@property (nonatomic, copy) NSString *Final;

@property (nonatomic, assign) NSInteger HomeTeamId;

@property (nonatomic, assign) NSInteger JcIssueNo;

@property (nonatomic, assign) NSInteger TxoddsMid;

@property (nonatomic, assign) NSInteger AsianSelectionId;

@property (nonatomic, copy) NSString *MatchTime;

@property (nonatomic, copy) NSString *MarketName1;

@property (nonatomic, assign) NSInteger AsianLineId;

@property (nonatomic, assign) NSInteger ElHomeSelectionId;

@property (nonatomic, assign) NSInteger MarketId2;

@property (nonatomic, assign) NSInteger MarketId4;

@property (nonatomic, copy) NSString *HomeTeam;

@property (nonatomic, copy) NSString *MatchPath;

@property (nonatomic, assign) NSInteger ElAwaySelectionId;

@property (nonatomic, assign) NSInteger LeagueId;

@property (nonatomic, assign) BOOL NeedRunning;

@property (nonatomic, assign) BOOL TxoddsBit;

@property (nonatomic, assign) NSInteger GuestTeamId;

@property (nonatomic, assign) NSInteger JcMatchNo;

@property (nonatomic, copy) NSString *StartTime;

@property (nonatomic, assign) NSInteger EventTypeId;

@property (nonatomic, assign) BOOL Allow;

@property (nonatomic, copy) NSString *GuestTeamName;

@property (nonatomic, assign) NSInteger LotteryId;

@property (nonatomic, assign) NSInteger LotteryOrder;

@property (nonatomic, assign) NSInteger MarketId1;

@property (nonatomic, assign) NSInteger EventId;

@property (nonatomic, copy) NSString *GuestTeam;

@property (nonatomic, assign) NSInteger MarketId3;

@property (nonatomic, assign) NSInteger MarketId5;

@end

@interface Baseinfolowest : NSObject

@property (nonatomic, assign) NSInteger ElAmountAway;

@property (nonatomic, assign) CGFloat UoPerOver;

@property (nonatomic, assign) CGFloat BfPerDraw;

@property (nonatomic, assign) NSInteger JcOddsAway;

@property (nonatomic, assign) NSInteger ElOddsAway;

@property (nonatomic, assign) CGFloat BfHotDraw;

@property (nonatomic, assign) CGFloat AsianIndex;

@property (nonatomic, assign) NSInteger ElStockDraw;

@property (nonatomic, assign) CGFloat BfIndexHome;

@property (nonatomic, assign) NSInteger ElPerHome;

@property (nonatomic, assign) NSInteger ElAmountHome;

@property (nonatomic, assign) CGFloat UoIndexOver;

@property (nonatomic, copy) NSString *AsianAvrLet;

@property (nonatomic, assign) CGFloat BfAmountAway;

@property (nonatomic, assign) CGFloat AsianAvrAway;

@property (nonatomic, assign) NSInteger EventId;

@property (nonatomic, assign) NSInteger ElIndexAway;

@property (nonatomic, assign) CGFloat BfPerAway;

@property (nonatomic, assign) CGFloat BfPayoutDraw;

@property (nonatomic, assign) CGFloat BfHotAway;

@property (nonatomic, assign) CGFloat UoStockOver;

@property (nonatomic, assign) NSInteger JcOddsDraw;

@property (nonatomic, assign) CGFloat The6;

@property (nonatomic, assign) CGFloat AsianAvrHome;

@property (nonatomic, assign) CGFloat BfAmountHome;

@property (nonatomic, assign) CGFloat BfStockAway;

@property (nonatomic, assign) CGFloat EuroAvrDraw;

@property (nonatomic, assign) NSInteger ElOddsDraw;

@property (nonatomic, assign) NSInteger AsianHandyGamesAway;

@property (nonatomic, assign) NSInteger ElIndexHome;

@property (nonatomic, assign) NSInteger UoAmount;

@property (nonatomic, assign) CGFloat The48;

@property (nonatomic, assign) NSInteger UoGamesUnder;

@property (nonatomic, assign) CGFloat BfStockHome;

@property (nonatomic, assign) NSInteger UoGamesOver;

@property (nonatomic, assign) CGFloat BfOddsHome;

@property (nonatomic, assign) NSInteger ElStockAway;

@property (nonatomic, copy) NSString *UpdateTime;

@property (nonatomic, assign) NSInteger MediaIndexAway;

@property (nonatomic, assign) CGFloat BfPayoutAway;

@property (nonatomic, assign) CGFloat UoAmountOver;

@property (nonatomic, assign) CGFloat UoStockUnder;

@property (nonatomic, assign) NSInteger JcIndexDraw;

@property (nonatomic, assign) NSInteger ZcIndexDraw;

@property (nonatomic, assign) CGFloat UoPerUnder;

@property (nonatomic, copy) NSString *AsianHandyGamesLine;

@property (nonatomic, assign) CGFloat CsIndex;

@property (nonatomic, assign) NSInteger ElStockHome;

@property (nonatomic, assign) CGFloat BfPayoutHome;

@property (nonatomic, assign) NSInteger BfAmount;

@property (nonatomic, assign) CGFloat BfPerHome;

@property (nonatomic, assign) CGFloat KellyDraw;

@property (nonatomic, assign) NSInteger MediaIndexHome;

@property (nonatomic, assign) CGFloat UoAmountUnder;

@property (nonatomic, assign) CGFloat BfHotHome;

@property (nonatomic, assign) CGFloat EuroAvrAway;

@property (nonatomic, assign) CGFloat UoOddsOver;

@property (nonatomic, assign) NSInteger UserIndexDraw;

@property (nonatomic, assign) NSInteger UserIndexAway;

@property (nonatomic, assign) NSInteger ElPerDraw;

@property (nonatomic, assign) NSInteger AsianHandyAway;

@property (nonatomic, assign) CGFloat EuroAvrHome;

@property (nonatomic, assign) CGFloat KellyAway;

@property (nonatomic, assign) NSInteger JcOddsHome;

@property (nonatomic, assign) NSInteger ElOddsHome;

@property (nonatomic, assign) NSInteger AsianHandyGamesHome;

@property (nonatomic, assign) CGFloat BfIndexDraw;

@property (nonatomic, assign) CGFloat UoIndexUnder;

@property (nonatomic, copy) NSString *UoGamesLine;

@property (nonatomic, assign) NSInteger MediaIndexDraw;

@property (nonatomic, assign) NSInteger UserIndexHome;

@property (nonatomic, copy) NSString *AsianHandyLine;

@property (nonatomic, assign) NSInteger ElPerAway;

@property (nonatomic, assign) CGFloat BfOddsAway;

@property (nonatomic, assign) NSInteger JcIndexAway;

@property (nonatomic, assign) NSInteger AsianHandyHome;

@property (nonatomic, assign) CGFloat The1;

@property (nonatomic, assign) NSInteger ElAmountDraw;

@property (nonatomic, assign) NSInteger ZcIndexAway;

@property (nonatomic, assign) CGFloat The24;

@property (nonatomic, assign) NSInteger ElIndexDraw;

@property (nonatomic, assign) NSInteger JcIndexHome;

@property (nonatomic, assign) CGFloat UoOddsUnder;

@property (nonatomic, copy) NSString *JcOddsLet;

@property (nonatomic, assign) NSInteger ZcIndexHome;

@property (nonatomic, assign) CGFloat BfAmountDraw;

@property (nonatomic, assign) CGFloat BfOddsDraw;

@property (nonatomic, assign) CGFloat BfStockDraw;

@property (nonatomic, assign) CGFloat BfIndexAway;

@property (nonatomic, assign) CGFloat KellyHome;

@end

@interface Baseinfo : NSObject

@property (nonatomic, assign) NSInteger ElAmountAway;

@property (nonatomic, assign) CGFloat UoPerOver;

@property (nonatomic, assign) CGFloat BfPerDraw;

@property (nonatomic, assign) NSInteger JcOddsAway;

@property (nonatomic, assign) NSInteger ElOddsAway;

@property (nonatomic, assign) CGFloat BfHotDraw;

@property (nonatomic, assign) CGFloat AsianIndex;

@property (nonatomic, assign) NSInteger ElStockDraw;

@property (nonatomic, assign) CGFloat BfIndexHome;

@property (nonatomic, assign) NSInteger ElPerHome;

@property (nonatomic, assign) NSInteger ElAmountHome;

@property (nonatomic, assign) CGFloat UoIndexOver;

@property (nonatomic, copy) NSString *AsianAvrLet;

@property (nonatomic, assign) CGFloat BfAmountAway;

@property (nonatomic, assign) CGFloat AsianAvrAway;

@property (nonatomic, assign) NSInteger EventId;

@property (nonatomic, assign) NSInteger ElIndexAway;

@property (nonatomic, assign) CGFloat BfPerAway;

@property (nonatomic, assign) CGFloat BfPayoutDraw;

@property (nonatomic, assign) CGFloat BfHotAway;

@property (nonatomic, assign) CGFloat UoStockOver;

@property (nonatomic, assign) NSInteger JcOddsDraw;

@property (nonatomic, assign) CGFloat The6;

@property (nonatomic, assign) CGFloat AsianAvrHome;

@property (nonatomic, assign) CGFloat BfAmountHome;

@property (nonatomic, assign) CGFloat BfStockAway;

@property (nonatomic, assign) CGFloat EuroAvrDraw;

@property (nonatomic, assign) NSInteger ElOddsDraw;

@property (nonatomic, assign) NSInteger AsianHandyGamesAway;

@property (nonatomic, assign) NSInteger ElIndexHome;

@property (nonatomic, assign) NSInteger UoAmount;

@property (nonatomic, assign) CGFloat The48;

@property (nonatomic, assign) NSInteger UoGamesUnder;

@property (nonatomic, assign) CGFloat BfStockHome;

@property (nonatomic, assign) NSInteger UoGamesOver;

@property (nonatomic, assign) CGFloat BfOddsHome;

@property (nonatomic, assign) NSInteger ElStockAway;

@property (nonatomic, copy) NSString *UpdateTime;

@property (nonatomic, assign) NSInteger MediaIndexAway;

@property (nonatomic, assign) CGFloat BfPayoutAway;

@property (nonatomic, assign) CGFloat UoAmountOver;

@property (nonatomic, assign) CGFloat UoStockUnder;

@property (nonatomic, assign) NSInteger JcIndexDraw;

@property (nonatomic, assign) NSInteger ZcIndexDraw;

@property (nonatomic, assign) CGFloat UoPerUnder;

@property (nonatomic, copy) NSString *AsianHandyGamesLine;

@property (nonatomic, assign) CGFloat CsIndex;

@property (nonatomic, assign) NSInteger ElStockHome;

@property (nonatomic, assign) CGFloat BfPayoutHome;

@property (nonatomic, assign) NSInteger BfAmount;

@property (nonatomic, assign) CGFloat BfPerHome;

@property (nonatomic, assign) CGFloat KellyDraw;

@property (nonatomic, assign) NSInteger MediaIndexHome;

@property (nonatomic, assign) NSInteger UoAmountUnder;

@property (nonatomic, assign) CGFloat BfHotHome;

@property (nonatomic, assign) CGFloat EuroAvrAway;

@property (nonatomic, assign) CGFloat UoOddsOver;

@property (nonatomic, assign) NSInteger UserIndexDraw;

@property (nonatomic, assign) NSInteger UserIndexAway;

@property (nonatomic, assign) NSInteger ElPerDraw;

@property (nonatomic, assign) NSInteger AsianHandyAway;

@property (nonatomic, assign) CGFloat EuroAvrHome;

@property (nonatomic, assign) CGFloat KellyAway;

@property (nonatomic, assign) NSInteger JcOddsHome;

@property (nonatomic, assign) NSInteger ElOddsHome;

@property (nonatomic, assign) NSInteger AsianHandyGamesHome;

@property (nonatomic, assign) CGFloat BfIndexDraw;

@property (nonatomic, assign) CGFloat UoIndexUnder;

@property (nonatomic, copy) NSString *UoGamesLine;

@property (nonatomic, assign) NSInteger MediaIndexDraw;

@property (nonatomic, assign) NSInteger UserIndexHome;

@property (nonatomic, copy) NSString *AsianHandyLine;

@property (nonatomic, assign) NSInteger ElPerAway;

@property (nonatomic, assign) CGFloat BfOddsAway;

@property (nonatomic, assign) NSInteger JcIndexAway;

@property (nonatomic, assign) NSInteger AsianHandyHome;

@property (nonatomic, assign) CGFloat The1;

@property (nonatomic, assign) NSInteger ElAmountDraw;

@property (nonatomic, assign) NSInteger ZcIndexAway;

@property (nonatomic, assign) CGFloat The24;

@property (nonatomic, assign) NSInteger ElIndexDraw;

@property (nonatomic, assign) NSInteger JcIndexHome;

@property (nonatomic, assign) CGFloat UoOddsUnder;

@property (nonatomic, copy) NSString *JcOddsLet;

@property (nonatomic, assign) NSInteger ZcIndexHome;

@property (nonatomic, assign) CGFloat BfAmountDraw;

@property (nonatomic, assign) CGFloat BfOddsDraw;

@property (nonatomic, assign) CGFloat BfStockDraw;

@property (nonatomic, assign) CGFloat BfIndexAway;

@property (nonatomic, assign) CGFloat KellyHome;

@end

