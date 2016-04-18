//
//  AddToDoViewController.m
//  LocalNotificationDemo
//
//  Created by Maksim S. on 2/5/2016.
//

#import "AddToDoViewController.h"

@interface AddToDoViewController (){
    NSUserDefaults *list;
}
#define REPEAT_INDEX 4
@end

@implementation AddToDoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//================ Keyboard Hidden Functions ================
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.itemText resignFirstResponder];
    return NO;
}
//==========================================================



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSDate *currentDate = [NSDate date];
//    
//    NSDate* timestamp;
    
    //NSLog(@"Time 10 second print");
//    int i = 0;
//    while (i < 1) {
//        timestamp = [NSDate date];
//        if (fabs([currentDate timeIntervalSinceDate:timestamp]) > 5){
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
//                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            break;
//        }
//    }

    _helper = [[AlarmDBHelper alloc] init];
    
    [self checkToDoList];
    self.itemText.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) scheduleLocalNotificationWithDate:(NSDate *)fireDate :(NSString *)message :(NSString *)ID
{
        UIApplication* application = [UIApplication sharedApplication];
    
        UILocalNotification* alarm = [[UILocalNotification alloc] init];
        alarm.fireDate = fireDate;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = NSMinuteCalendarUnit;
        alarm.soundName = @"alarm-clock-1.mp3";
        alarm.alertBody = message;
        NSArray *keys = [NSArray arrayWithObjects:@"ID", @"ALARM", nil];
        NSArray *objects = [NSArray arrayWithObjects:ID, message, nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objects
                                                             forKeys:keys];
        
        alarm.userInfo = userInfo;
        [application scheduleLocalNotification:alarm];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}




-(void)scheduleLocalNotificationDeletID:(NSString *)ID{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ID"]];
        if ([uid isEqualToString:ID])
        {
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}

-(void)alertSetting:(int)val{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSString *result;
    if (_dataPickerSwitch.on){
        NSDate *currentDate = [_datePicker date];
        NSDateComponents *dateComponents = [NSDateComponents new];
        
        dateComponents.minute = val;
        NSDate *currentDatePlus = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
        
        result = [formatter stringFromDate:currentDatePlus];
    }
    else{
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [NSDateComponents new];
        
        dateComponents.minute = val;
        NSDate *currentDatePlus = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
        
        result = [formatter stringFromDate:currentDatePlus];
    }
    
    
    NSString *listItem = _itemText.text;
    
    NSMutableDictionary *alarmDic = [NSMutableDictionary dictionary];
    [alarmDic setObject:result forKey:@"ALARM"];
    [alarmDic setObject:@"1" forKey:@"RUN_FLAG"];
    [alarmDic setObject:@"1" forKey:@"REPEAT_FLAG"];
    [alarmDic setObject:listItem forKey:@"ALARM_LIST"];
    BOOL ret = [_helper insert:alarmDic];
    
    //INSERT成功したら
    if(ret) {
        AlarmModel *model = [[AlarmModel alloc] init];
        [model setAlarmArray:[_helper selectAll]];
        [model setAlarmNotification];
        [self.navigationController popViewControllerAnimated:YES];
        
        //INSERT失敗したら
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder Me." message:@"This is at time." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (IBAction)oneHourSwitchClick:(id)sender {
    
       NSString *str = [_itemText text];
       if (_oneHourSwitch.on){
            if ([str isEqualToString:@""]) {
                [_oneHourSwitch setOn:NO animated:NO];
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
                                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
           [self alertSetting:1];
       }
       else{
           [_itemText setText:@""];
       }
//   NSString *str = [_itemText text];
//    NSString *ID = @"oneHour";
//   if (_oneHourSwitch.on){
//        if ([str isEqualToString:@""]) {
//            [_oneHourSwitch setOn:NO animated:NO];
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
//                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//       NSDate *currentDate = [_datePicker date];
//       NSDateComponents *dateComponents = [NSDateComponents new];
//       dateComponents.minute = 1;
//       
//       NSDate *currentDatePlus = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
//       NSLog(@"Update Date = %@", currentDatePlus);
//       
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:str forKey:ID];
//        [list setObject:currentDatePlus forKey:@"oneHour_date"];
//        [self scheduleLocalNotificationWithDate:currentDatePlus :str :ID];
//    }
//    else{
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:@"" forKey:ID];
//        [_itemText setText:@""];
//        [self scheduleLocalNotificationDeletID:ID];
//    }
}
- (IBAction)twoHourSwitchClick:(id)sender {
    NSString *str = [_itemText text];
    if (_twoHourSwitch.on){
        if ([str isEqualToString:@""]) {
            [_twoHourSwitch setOn:NO animated:NO];
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self alertSetting:2];
    }
    else{
        [_itemText setText:@""];
    }

//    NSString *ID = @"twoHour";
//
//    if (_twoHourSwitch.on){
//        if ([str isEqualToString:@""]) {
//            [_twoHourSwitch setOn:NO animated:NO];
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
//                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//        
//        NSDate *currentDate = [_datePicker date];
//        NSDateComponents *dateComponents = [NSDateComponents new];
//        dateComponents.minute = 2;
//        
//        NSDate *currentDatePlus = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
//        NSLog(@"Update Date = %@", currentDatePlus);
//        
//        
//
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:str forKey:ID];
//        [list setObject:currentDatePlus forKey:@"twoHour_date"];
//        [self scheduleLocalNotificationWithDate:currentDatePlus :str :ID];
//    }
//    else{
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:@"" forKey:ID];
//        [_itemText setText:@""];
//        [self scheduleLocalNotificationDeletID:ID];
//    }
}
- (IBAction)adaySwitchClick:(id)sender {
    
    NSString *str = [_itemText text];
    if (_adaySwitch.on){
        if ([str isEqualToString:@""]) {
            [_adaySwitch setOn:NO animated:NO];
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self alertSetting:5];
    }
    else{
        [_itemText setText:@""];
    }
//    NSString *str = [_itemText text];
//    NSString *ID = @"aday";
//    
//    
//    if (_adaySwitch.on){
//        if ([str isEqualToString:@""]) {
//            [_adaySwitch setOn:NO animated:NO];
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
//                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//        
//        NSDate *currentDate = [_datePicker date];
//        NSDateComponents *dateComponents = [NSDateComponents new];
//        dateComponents.minute = 3;
//        
//        NSDate *currentDatePlus = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
//        NSLog(@"Update Date = %@", currentDatePlus);
//        
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:str forKey:ID];
//        [list setObject:currentDatePlus forKey:@"aday_date"];
//        [self scheduleLocalNotificationWithDate:currentDatePlus :str :ID];
//    }
//    else{
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:@"" forKey:ID];
//        [_itemText setText:@""];
//        [self scheduleLocalNotificationDeletID:ID];
//    }
}
- (IBAction)twodaySwitch:(id)sender {
    NSString *str = [_itemText text];
    if (_twodaySwitch.on){
        if ([str isEqualToString:@""]) {
            [_twodaySwitch setOn:NO animated:NO];
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self alertSetting:10];
    }
    else{
        [_itemText setText:@""];
    }
//    NSString *str = [_itemText text];
//    NSString *ID = @"twoday";
//    
//    
//    if (_twodaySwitch.on){
//        if ([str isEqualToString:@""]) {
//            [_twodaySwitch setOn:NO animated:NO];
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's list!"
//                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//        NSDate *currentDate = [_datePicker date];
//        NSDateComponents *dateComponents = [NSDateComponents new];
//        dateComponents.minute = 4;
//        
//        NSDate *currentDatePlus = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
//        NSLog(@"Update Date = %@", currentDatePlus);
//        
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:str forKey:ID];
//        [list setObject:currentDatePlus forKey:@"twoday_date"];
//        [self scheduleLocalNotificationWithDate:currentDatePlus :str :ID];
//    }
//    else{
//        list = [NSUserDefaults standardUserDefaults];
//        [list setObject:@"" forKey:ID];
//        [_itemText setText:@""];
//        [self scheduleLocalNotificationDeletID:ID];
//    }
}

-(void)checkToDoList{
    list = [NSUserDefaults standardUserDefaults];
    if ([[list objectForKey:@"oneHour"] isEqualToString:@""] || [list objectForKey:@"oneHour"] == nil) {
        [_oneHourSwitch setOn:NO animated:NO];
        _itemText.enabled = YES;
    }
    else{
        if([self dataChangeFlage:@"oneHour_date"])
            [_oneHourSwitch setOn:YES animated:YES];
        else{
            [list setObject:@"" forKey:@"oneHour"];
            [_oneHourSwitch setOn:NO animated:NO];
        }
    }
    
    if ([[list objectForKey:@"twoHour"] isEqualToString:@""] || [list objectForKey:@"twoHour"] == nil) {
        [_twoHourSwitch setOn:NO animated:NO];
        _itemText.enabled = YES;
    }
    else{
        if([self dataChangeFlage:@"twoHour_date"])
            [_twoHourSwitch setOn:YES animated:YES];
        else{
            [list setObject:@"" forKey:@"twoHour"];
            [_twoHourSwitch setOn:NO animated:NO];
        }
    }
    
    if ([[list objectForKey:@"aday"] isEqualToString:@""] || [list objectForKey:@"aday"] == nil) {
        [_adaySwitch setOn:NO animated:NO];
        _itemText.enabled = YES;
    }
    else{
        if([self dataChangeFlage:@"aday_date"])
            [_adaySwitch setOn:YES animated:YES];
        else{
            [list setObject:@"" forKey:@"aday"];
            [_adaySwitch setOn:NO animated:NO];
        }
    }
    if ([[list objectForKey:@"twoday"] isEqualToString:@""] || [list objectForKey:@"twoday"] == nil) {
        [_twodaySwitch setOn:NO animated:NO];
        _itemText.enabled = YES;
    }
    else{
        if([self dataChangeFlage:@"twoday_date"])
            [_twodaySwitch setOn:YES animated:YES];
        else{
            [list setObject:@"" forKey:@"twoday"];
            [_twodaySwitch setOn:NO animated:NO];
        }
    }
}
- (IBAction)dataPickerEnable:(id)sender {
    if (_dataPickerSwitch.on)
        [_datePicker setHidden:FALSE];
    else
        [_datePicker setHidden:TRUE];
}

-(void)initArray:(NSString*)KEY{
    list = [NSUserDefaults standardUserDefaults];
    [list setObject:@"" forKey:KEY];
}
-(BOOL)dataChangeFlage:(NSString*)KEY{
    list = [NSUserDefaults standardUserDefaults];
    
    NSDate *setDate = [list objectForKey:KEY];
    
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval time = [setDate timeIntervalSinceDate:currentDate];
    if (time < 0){
        return FALSE;
    }

    return TRUE;
}
@end
