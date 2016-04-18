//
//  AlarmDBHelper.h
//  AlarmMonster
//
//  Created by 秋山友也 on 2016/02/07.
//  Copyright © 2016年 developers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface AlarmDBHelper : NSObject
- (NSMutableArray *) selectAll;
- (NSMutableArray *) selectRunAlarms;
- (BOOL) insert : (NSMutableDictionary *) alarmDic;
- (BOOL) update : (NSMutableDictionary *) alarmDic;
- (BOOL) delete : (NSMutableDictionary *) alarmDic;
- (NSMutableDictionary *) select : (NSInteger) alarmId;
@end
