//
//  AlarmModel.h
//  AlarmMonster
//
//  Created by 秋山友也 on 2016/02/13.
//  Copyright © 2016年 developers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DateConvert.h"

@interface AlarmModel : NSObject {
    NSMutableArray *alarmArray;
}

- (void) setAlarmArray : (NSMutableArray *) ary;
- (NSMutableArray *) getAlarmArray;
- (NSMutableDictionary *) getAlarmDic : (NSInteger) indexRow;
- (NSString *) getId : (NSInteger) indexRow;
- (NSString *) getAlarm : (NSInteger) indexRow;
- (NSString *) getAlarmList : (NSInteger) indexRow;
- (NSString *) getRunFlag : (NSInteger) indexRow;
- (NSString *) getRepeatFlag : (NSInteger) indexRow;
- (NSString *) getFirstAlarm;
- (void) setAlarmNotification;

@end
