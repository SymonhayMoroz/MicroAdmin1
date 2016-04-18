//
//  AppDelegate.m
//  MicroAdmin
//
//  Created by dev on 2016. 2. 13..
//  Copyright © 2016년 company. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AlarmViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    
    
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeSound)
                                                                                         categories:nil];
    [[UIApplication sharedApplication]registerUserNotificationSettings:notificationSettings];
    
    
    // Handle launching from a notification
//    application.applicationIconBadgeNumber = 0;
//    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (locationNotification) {
//        // Set icon badge number to zero
//        application.applicationIconBadgeNumber = 0;
//    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    // アプリ起動中(フォアグラウンド)に通知が届いた場合
    if(application.applicationState == UIApplicationStateActive) {
        
        //起動中は通知がこないため処理が必要
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder"
//                                                                                 message:[NSString stringWithFormat:@"This is %@. Reminder Me!",notification.userInfo[@"ALARM"]]
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        
//        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder"
                                                                                 message:[NSString stringWithFormat:@"This is %@. Reminder Me!",notification.userInfo[@"ALARM_LIST"]]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        
        
        UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
            baseView = baseView.presentedViewController;
        }
        [baseView presentViewController:alertController animated:YES completion:nil];
    }
    
    // アプリがバックグラウンドにある状態で通知が届いた場合
    if(application.applicationState == UIApplicationStateInactive) {
        
    }
    
    // 通知領域から対象のアラート設定だけ削除する
    //[[UIApplication sharedApplication] cancelLocalNotification:notification];
    
    for(UILocalNotification *allNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        // 通知に登録されているキーで検索
        if([allNotification.userInfo[@"ID"] isEqualToString:notification.userInfo[@"ID"]]) {
            // キーが一致したら、対象の通知を削除
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    //    //アラート設定をオフにする
    AlarmDBHelper *helper = [[AlarmDBHelper alloc] init];
    AlarmModel *model = [[AlarmModel alloc] init];
    NSMutableDictionary *targetAlarmDic = [notification.userInfo mutableCopy];
    [targetAlarmDic setObject:@"0" forKey:@"RUN_FLAG"];
    [helper update:targetAlarmDic];
    [model setAlarmNotification];
    
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray* oldNotifications = [app scheduledLocalNotifications];
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    [model setAlarmNotification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];

//    if(application.applicationState == UIApplicationStateActive) {
//        
//        //NSLog(@"Switch change%@", notification.userInfo[@"ID"]);
//        AlarmViewController *al = [[AlarmViewController alloc] init];
//        [al checkSwitchDisable:notification.userInfo[@"ID"]];
//
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder"
//                                                                                 message:[NSString stringWithFormat:@"%@",notification.userInfo[@"ALARM"]]
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        }]];
//        
//        UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
//        while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
//            baseView = baseView.presentedViewController;
//        }
//        [baseView presentViewController:alertController animated:YES completion:nil];
//    }
//    
//
//    if(application.applicationState == UIApplicationStateInactive) {
//        
//    }
//    
// 
//    //[[UIApplication sharedApplication] cancelLocalNotification:notification];
//    
//    for(UILocalNotification *allNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
//        
//        if([allNotification.userInfo[@"ID"] isEqualToString:notification.userInfo[@"ID"]]) {
//            
//            AddToDoViewController *addController = [[AddToDoViewController alloc] init];
//            [addController initArray:notification.userInfo[@"ID"]];
//            [[UIApplication sharedApplication] cancelLocalNotification:notification];
//        }
//    }
//    
//    AddToDoViewController *addController = [[AddToDoViewController alloc] init];
//    [addController initArray:notification.userInfo[@"ID"]];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
//    
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *eventArray = [app scheduledLocalNotifications];
//    for (int i=0; i<[eventArray count]; i++)
//    {
//        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//        NSDictionary *userInfoCurrent = oneEvent.userInfo;
//        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ID"]];
//        if ([uid isEqualToString:notification.userInfo[@"ID"]]){
//            AddToDoViewController *addController = [[AddToDoViewController alloc] init];
//            [addController initArray:uid];
//            [app cancelLocalNotification:oneEvent];
//        }
//    }
//    
//
//    
//    
////    UIApplication* app = [UIApplication sharedApplication];
////    NSArray* oldNotifications = [app scheduledLocalNotifications];
////    if ([oldNotifications count] > 0)
////        [app cancelAllLocalNotifications];
//    
//
////    AlarmDBHelper *helper = [[AlarmDBHelper alloc] init];
////    AlarmModel *model = [[AlarmModel alloc] init];
////    NSMutableDictionary *targetAlarmDic = [notification.userInfo mutableCopy];
////    [targetAlarmDic setObject:@"0" forKey:@"RUN_FLAG"];
////    [helper update:targetAlarmDic];
////    [model setAlarmNotification];
}

@end
