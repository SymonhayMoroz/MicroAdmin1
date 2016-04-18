//
//  AlarmIntervalViewController.m
//  MicroAdmin
//
//  Created by dev on 2016. 3. 11..
//  Copyright © 2016년 company. All rights reserved.
//

#import "AlarmIntervalViewController.h"

@interface AlarmIntervalViewController ()

@end

@implementation AlarmIntervalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _alarmListText.delegate = self;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Count  :  %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get list of local notifications
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *localNotification = [localNotifications objectAtIndex:indexPath.row];
    
    
    
    
    
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *dateTimeString = [dateFormatter stringFromDate:localNotification.fireDate];
    
    
    UILabel *toDoList = (UILabel*) [cell viewWithTag:1];
    [toDoList setText:localNotification.alertBody];
    UILabel *remindme = (UILabel*) [cell viewWithTag:2];
    [remindme setText:dateTimeString];
    
    NSLog(@"alertBody %@", localNotification.alertBody);
    NSLog(@"remindme %@", dateTimeString);
    
    // Display notification info
    //    [cell.textLabel setText:localNotification.alertBody];
    //    [cell.detailTextLabel setText:[localNotification.fireDate description]];
    
    return cell;
}

- (void)reloadTable
{
    NSLog(@"------- reloadTable View ----------");
    [_listTableView reloadData];
    NSLog(@"------- reloadTable View ----------");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)oneHourSwitchClick:(id)sender {
    NSString *str = [_alarmListText text];
    if ([str isEqualToString:@""]) {
        [_oneHourSwitch setOn:NO animated:NO];
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Alarm's title!"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (_adaySwitch.on){
        [self scheduleLocalNotificationWithDate:[_datePicer date] :str :@"oneHour"];
    }
    else{
        [self scheduleLocalNotificationDeletID:@"oneHour"];
    }
    
}
- (IBAction)twoHourSwitchClick:(id)sender {
}
- (IBAction)adaySwitchClick:(id)sender {
}
- (IBAction)twodaySwitchClick:(id)sender {
}

- (void) scheduleLocalNotificationWithDate:(NSDate *)fireDate :(NSString *)message :(NSString *)ID
{
//    UIApplication* app = [UIApplication sharedApplication];
//    //    NSArray* oldNotifications = [app scheduledLocalNotifications];
//    //    if ([oldNotifications count] > 0)
//    //        [app cancelAllLocalNotifications];
//    
//    
//    for (int index=0; index < 4; index++) {
//        UILocalNotification* alarm = [[UILocalNotification alloc] init];
//        alarm.fireDate = [self getNextSecondsDate:fireDate repeatIndex:index];
//        alarm.timeZone = [NSTimeZone defaultTimeZone];
//        alarm.repeatInterval = 0;
//        alarm.soundName = @"alarm-clock-1.mp3";
//        alarm.alertBody = message;
//        //NSDictionary *userInfo = [NSDictionary dictionaryWithObject: @"oneHour" forKey:@"ID"];
//        //userInfo = [NSDictionary dictionaryWithObject: oneHour forKey:@"ALARM"];
//        
//        NSArray *keys = [NSArray arrayWithObjects:@"ID", @"ALARM", nil];
//        NSArray *objects = [NSArray arrayWithObjects:ID, message, nil];
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objects
//                                                             forKeys:keys];
//        
//        alarm.userInfo = userInfo;
//        [app scheduleLocalNotification:alarm];
//    }
    NSArray *keys = [NSArray arrayWithObjects:@"ID", @"ALARM", nil];
    NSArray *objects = [NSArray arrayWithObjects:ID, message, nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objects
                                                         forKeys:keys];
    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = message;
    localNotification.alertAction = @"Show me the item";
    localNotification.soundName = @"alarm-clock-1.mp3";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Request to reload table view data
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    [self reloadTable];
    
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
            //break;
        }
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    [self reloadTable];

}

@end
