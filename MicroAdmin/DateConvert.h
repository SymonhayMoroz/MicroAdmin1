//
//  DateConvert.h
//  AlarmMonster
//
//  Created by 秋山友也 on 2016/02/20.
//  Copyright © 2016年 developers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateConvert : NSObject {
    NSDateFormatter *alarmFormat;
    NSDateFormatter *nowDateFormat;
    NSDateFormatter *interimFormat;
}

//成形された日付データを取得
- (NSDate *) getFormatDate : (NSString *) alarmDateStr;
//今日の時間か
- (BOOL) isTodaysTime : (NSDate *) orgDate;
//今日の日付か
- (BOOL) isNowDate : (NSDate *) compareDate;
//次の秒数を取得(0,15,30,45)
- (NSDate *) getNextSecondsDate : (NSDate *) orgDate repeatIndex : (int) repeatIndex;
@end
