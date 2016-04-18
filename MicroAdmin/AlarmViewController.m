//
//  AlarmViewController.m
//  MicroAdmin
//
//  Created by dev on 2016. 3. 8..
//  Copyright © 2016년 company. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController (){
    NSUserDefaults *ahour, *twohours, *aday, *twodays;
    NSDateFormatter *DateFormatter;
}

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.oneHourText.delegate = self;
    self.twoHourText.delegate = self;
    self.adayText.delegate = self;
    self.twodayText.delegate = self;
    
    [self checkAlarmSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)oneHourClick:(id)sender {
    
    
    NSString *str = [_oneHourText text];
    if ([str isEqualToString:@""]) {
        [_oneHourSwitch setOn:NO animated:NO];
        [self alertMessage:@"NO" :@""];
        return;
    }
    
    if (_oneHourSwitch.on){
        
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.minute = 1;
        
        NSDate *currentDatePlus1Hour = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
        NSLog(@"Update Date = %@", currentDatePlus1Hour);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentLocalDateAsStr = [dateFormatter stringFromDate:currentDatePlus1Hour];

        [self scheduleLocalNotificationWithDate:currentDatePlus1Hour :str :@"oneHour"];
        
        ahour = [NSUserDefaults standardUserDefaults];
        [ahour setObject:str forKey:@"hour_title"];
        _oneHourText.enabled = NO;
        [self alertMessage:@"YES" :[NSString stringWithFormat:@"Setting Alarm after a hour.(%@)", currentLocalDateAsStr]];
    }
    else{
        ahour = [NSUserDefaults standardUserDefaults];
        [ahour setObject:@"" forKey:@"hour_title"];
        [_oneHourText setText:@""];
        _oneHourText.enabled = YES;
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ID"]];
            if ([uid isEqualToString:@"oneHour"])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                //break;
            }
        }
    }
}
- (IBAction)twoHourClick:(id)sender {
    NSString *str = [_twoHourText text];
    if ([str isEqualToString:@""]) {
        [_twoHourSwitch setOn:NO animated:NO];
        [self alertMessage:@"NO" :@""];
        return;
    }
    if (_twoHourSwitch.on){
        
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.minute = 3;
        
        NSDate *currentDatePlus2Hour = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
        NSLog(@"Update Date = %@", currentDatePlus2Hour);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentLocalDateAsStr = [dateFormatter stringFromDate:currentDatePlus2Hour];
        
        [self scheduleLocalNotificationWithDate:currentDatePlus2Hour :str :@"twoHour"];
        
        twohours = [NSUserDefaults standardUserDefaults];
        [twohours setObject:str forKey:@"twohours_title"];
        _twoHourText.enabled = NO;
        [self alertMessage:@"YES" :[NSString stringWithFormat:@"Setting Alarm after two hours.(%@)", currentLocalDateAsStr]];
    }
    else{
        twohours = [NSUserDefaults standardUserDefaults];
        [twohours setObject:@"" forKey:@"twohours_title"];
        [_twoHourText setText:@""];
        _twoHourText.enabled = YES;
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ID"]];
            if ([uid isEqualToString:@"twoHour"])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                //break;
            }
        }
    }
}
- (IBAction)twodayClick:(id)sender {
    NSString *str = [_twodayText text];
    if ([str isEqualToString:@""]) {
        [_twodaySwitch setOn:NO animated:NO];
        [self alertMessage:@"NO" :@""];
        return;
    }
    if (_twodaySwitch.on){
        
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.minute = 5;
        
        NSDate *currentDatePlus2Days = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
        NSLog(@"Update Date = %@", currentDatePlus2Days);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentLocalDateAsStr = [dateFormatter stringFromDate:currentDatePlus2Days];
        
        [self scheduleLocalNotificationWithDate:currentDatePlus2Days :str :@"twoday"];
        
        twodays = [NSUserDefaults standardUserDefaults];
        [twodays setObject:str forKey:@"twoday_title"];
        _twodayText.enabled = NO;
        [self alertMessage:@"YES" :[NSString stringWithFormat:@"Setting Alarm after 2 days.(%@)", currentLocalDateAsStr]];
    }
    else{
        twodays = [NSUserDefaults standardUserDefaults];
        [twodays setObject:@"" forKey:@"twoday_title"];
        [_twodayText setText:@""];
        _twodayText.enabled = YES;
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ID"]];
            if ([uid isEqualToString:@"twoday"])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                //break;
            }
        }
    }
}
- (IBAction)adayClick:(id)sender {
    NSString *str = [_adayText text];
    if ([str isEqualToString:@""]) {
        [_adaySwitch setOn:NO animated:NO];
        [self alertMessage:@"NO" :@""];
        return;
    }
    if (_adaySwitch.on){
        
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.minute = 7;
        
        NSDate *currentDatePlus1Day = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
        NSLog(@"Update Date = %@", currentDatePlus1Day);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentLocalDateAsStr = [dateFormatter stringFromDate:currentDatePlus1Day];
        
        [self scheduleLocalNotificationWithDate:currentDatePlus1Day :str :@"aday"];
        
        aday = [NSUserDefaults standardUserDefaults];
        [aday setObject:str forKey:@"aday_title"];
        _adayText.enabled = NO;
        [self alertMessage:@"YES" :[NSString stringWithFormat:@"Setting Alarm after a day.(%@)", currentLocalDateAsStr]];
    }
    else{
        aday = [NSUserDefaults standardUserDefaults];
        [aday setObject:@"" forKey:@"aday_title"];
        [_adayText setText:@""];
        _adayText.enabled = YES;
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ID"]];
            if ([uid isEqualToString:@"aday"])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                //break;
            }
        }
    }
}

-(void)alertMessage:(NSString*)flag :(NSString*)msg{
    UIAlertView *alert;
    if ([flag isEqualToString:@"NO"])
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's title!"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:nil message:msg
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

-(void)checkAlarmSetting{
    ahour = [NSUserDefaults standardUserDefaults];
    NSString *ahour_str = [ahour objectForKey:@"hour_title"];
    if ([ahour_str isEqualToString:@""] || ahour_str == nil) {
        [_oneHourSwitch setOn:NO animated:NO];
        _oneHourText.enabled = YES;
    }
    else{
        [_oneHourText setText:ahour_str];
        _oneHourText.enabled = NO;
        [_oneHourSwitch setOn:YES animated:YES];
    }
    twohours = [NSUserDefaults standardUserDefaults];
    NSString *twohour_str = [twohours objectForKey:@"twohours_title"];
    if ([twohour_str isEqualToString:@""] || twohour_str == nil) {
        [_twoHourSwitch setOn:NO animated:NO];
        _twoHourText.enabled = YES;
    }
    else{
        [_twoHourText setText:twohour_str];
        _twoHourText.enabled = NO;
        [_twoHourSwitch setOn:YES animated:YES];
    }
    aday = [NSUserDefaults standardUserDefaults];
    NSString *aday_str = [aday objectForKey:@"aday_title"];
    if ([aday_str isEqualToString:@""] || aday_str == nil) {
        [_adaySwitch setOn:NO animated:NO];
        _adayText.enabled = YES;
    }
    else{
        [_adayText setText:aday_str];
        _adayText.enabled = NO;
        [_adaySwitch setOn:YES animated:YES];
    }
    twodays = [NSUserDefaults standardUserDefaults];
    NSString *twodays_str = [twodays objectForKey:@"twoday_title"];
    if ([twodays_str isEqualToString:@""] || twodays_str == nil) {
        [_twodaySwitch setOn:NO animated:NO];
        _twodayText.enabled = YES;
    }
    else{
        [_twodayText setText:twodays_str];
        _twodayText.enabled = NO;
        [_twodaySwitch setOn:YES animated:YES];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void) scheduleLocalNotificationWithDate:(NSDate *)fireDate :(NSString *)message :(NSString *)ID
{
    UIApplication* app = [UIApplication sharedApplication];
//    NSArray* oldNotifications = [app scheduledLocalNotifications];
//    if ([oldNotifications count] > 0)
//        [app cancelAllLocalNotifications];
    

            for (int index=0; index < 4; index++) {
                UILocalNotification* alarm = [[UILocalNotification alloc] init];
                alarm.fireDate = [self getNextSecondsDate:fireDate repeatIndex:index];
                alarm.timeZone = [NSTimeZone defaultTimeZone];
                alarm.repeatInterval = 0;
                alarm.soundName = @"alarm-clock-1.mp3";
                alarm.alertBody = message;
                //NSDictionary *userInfo = [NSDictionary dictionaryWithObject: @"oneHour" forKey:@"ID"];
                //userInfo = [NSDictionary dictionaryWithObject: oneHour forKey:@"ALARM"];

                NSArray *keys = [NSArray arrayWithObjects:@"ID", @"ALARM", nil];
                NSArray *objects = [NSArray arrayWithObjects:ID, message, nil];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objects
                                                                       forKeys:keys];
                
                alarm.userInfo = userInfo;
                [app scheduleLocalNotification:alarm];
            }
    
    
}
- (NSDate *) getNextSecondsDate:(NSDate *)orgDate repeatIndex:(int)repeatIndex {
    NSDate *nextSecondDate = [orgDate initWithTimeInterval:(repeatIndex * 15) sinceDate:orgDate];
    return nextSecondDate;
}
-(void)checkSwitchDisable:(NSString*)key{

    if ([key isEqualToString:@"oneHour"]) {
        ahour = [NSUserDefaults standardUserDefaults];
        [ahour setObject:@"" forKey:@"hour_title"];
    }
    if ([key isEqualToString:@"twoHour"]) {
        twohours = [NSUserDefaults standardUserDefaults];
        [twohours setObject:@"" forKey:@"twohours_title"];
    }
    if ([key isEqualToString:@"aday"]) {
        aday = [NSUserDefaults standardUserDefaults];
        [aday setObject:@"" forKey:@"aday_title"];
    }
    if ([key isEqualToString:@"twoday"]) {
        twodays = [NSUserDefaults standardUserDefaults];
        [twodays setObject:@"" forKey:@"twoday_title"];
    }
}

@end
