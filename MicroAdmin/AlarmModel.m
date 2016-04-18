//
//  AlarmModel.m
//  AlarmMonster
//
//  Created by 秋山友也 on 2016/02/13.
//  Copyright © 2016年 developers. All rights reserved.
//

#import "AlarmModel.h"

@implementation AlarmModel
#define NO_ALARM_MESSAGE @"Setting"
#define REPEAT_INDEX 4

- (void) setAlarmArray:(NSMutableArray *)ary {
    alarmArray = ([ary count] > 0) ? [ary mutableCopy]: [NSMutableArray array];
}

- (NSMutableArray *) getAlarmArray {
    return alarmArray;
}

- (NSMutableDictionary *) getAlarmDic:(NSInteger)indexRow {
    NSMutableDictionary *retDic = ([alarmArray count] > 0) ? alarmArray[indexRow] : [NSMutableDictionary dictionary];
    return retDic;
}

- (NSString *) getId : (NSInteger) indexRow {
    NSString *retId = ([alarmArray count] > 0) ? alarmArray[indexRow][@"ID"] : @"";
    return retId;
}
- (NSString *) getAlarm : (NSInteger) indexRow {
    NSString *retAlarm = ([alarmArray count] > 0) ? alarmArray[indexRow][@"ALARM"] : NO_ALARM_MESSAGE;
    return retAlarm;
}
- (NSString *) getAlarmList : (NSInteger) indexRow{
    NSString *retAlarm = ([alarmArray count] > 0) ? alarmArray[indexRow][@"ALARM_LIST"] : @"";
    return retAlarm;
}
- (NSString *) getRunFlag : (NSInteger) indexRow {
    NSString *retRunFlag = ([alarmArray count] > 0) ? alarmArray[indexRow][@"RUN_FLAG"] : @"0";
    return retRunFlag;
}
- (NSString *) getRepeatFlag : (NSInteger) indexRow {
    NSString *retRepeatFlag = ([alarmArray count] > 0) ? alarmArray[indexRow][@"REPEAT_FLAG"] : @"0";
    return retRepeatFlag;
}
- (NSString *) getFirstAlarm {
    
    if([alarmArray count] == 0) { return NO_ALARM_MESSAGE; }
    
    DateConvert *converter = [[DateConvert alloc] init];
    for (NSDictionary *dic in alarmArray) {
        if([converter isNowDate:[converter getFormatDate:dic[@"ALARM"]]]) {
            return dic[@"ALARM"];
        }
    }
    
    return alarmArray[0][@"ALARM"];
}
- (void) setAlarmNotification {
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray* oldNotifications = [app scheduledLocalNotifications];
    // 新しい通知を予約する前に古い通知を削除。
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];

    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.minute = 1;
    
    NSDate *currentDatePlus1Hour = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    //formaterを作成
    DateConvert *converter = [[DateConvert alloc] init];
    for (NSDictionary *alarmDic in alarmArray) {
        if([alarmDic[@"RUN_FLAG"] isEqualToString:@"1"]) {
            for (int index=0; index < REPEAT_INDEX; index++) {
                UILocalNotification* alarm = [[UILocalNotification alloc] init];
                //アラームを鳴らす日付
                NSData *d =[converter getNextSecondsDate:[converter getFormatDate:alarmDic[@"ALARM"]]  repeatIndex:index] ;
                alarm.fireDate = [converter getNextSecondsDate:[converter getFormatDate:alarmDic[@"ALARM"]]  repeatIndex:index] ;
                //alarm.fireDate = currentDatePlus1Hour;
                //現在地のタイムゾーン設定(おそらく日本に変えた方がいい)
                alarm.timeZone = [NSTimeZone defaultTimeZone];
                //リピート回数(設定するならリピートできる仕組みを作る必要あり)
                alarm.repeatInterval = 0;
                //鳴らす音楽ファイル名しょう
                alarm.soundName = @"alarm.mp3";
                //バックグラウンド時に表示するメッセージ
                alarm.alertBody = [NSString stringWithFormat:@"This is at %@. Reminder Me.",alarmDic[@"ALARM"]];
                //アラート情報
                alarm.userInfo = alarmDic;
                [app scheduleLocalNotification:alarm];
            }
        }
    }
}

@end
