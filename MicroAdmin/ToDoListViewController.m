//
//  ToDoListViewController.m
//  LocalNotificationDemo
//
//  Created by Maksim S. on 2/5/2016.
//

#import "ToDoListViewController.h"

@interface ToDoListViewController ()
- (void)reloadTable;

@end

@implementation ToDoListViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _helper = [[AlarmDBHelper alloc] init];
    _model = [[AlarmModel alloc] init];
    [_model setAlarmArray:[_helper selectAll]];
    [self.tableList reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableList.delegate = self;
    _tableList.dataSource = self;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"reloadData"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int ii = [[_model getAlarmArray] count];
    return [[_model getAlarmArray] count];
//    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    for (UIView *subview in [cell.contentView subviews]) {
//        [subview removeFromSuperview];
//    }
    
    NSString *alarm_list = [_model getAlarmList:indexPath.row];
    UILabel *to = (UILabel*) [cell viewWithTag:1];
    [to setText:alarm_list];
    
    NSString *alarm = [_model getAlarm:indexPath.row];
    UILabel *toDoList = (UILabel*) [cell viewWithTag:2];
    [toDoList setText:alarm];
    
    
    
//    UILabel *hiddenid = (UILabel*) [cell viewWithTag:3];
//    [hiddenid setText:localNotification.userInfo[@"ID"]];
    
    
    
    
//    CGRect alarmRect = CGRectMake(5, 5, 100, 30);
//    UILabel *alarmLabel = [LabelFactory planeLabel:alarmRect
//                                              text:alarm
//                                              font:[UIFont boldSystemFontOfSize:20]
//                                         textColor:[UIColor lightGrayColor]
//                                     textAlignment:NSTextAlignmentCenter
//                                   backgroundColor:[UIColor clearColor]];
    
    BOOL flag = ([[_model getRunFlag:indexPath.row] isEqualToString:@"1"]) ? YES : NO;
//    UISwitch *flagSwitch = (UISwitch*)[cell viewWithTag:5];
//    [flagSwitch setOn:flag animated:flag];
//    [flagSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    [switchView setOn:flag animated:flag];
    
    [switchView addTarget:self action:@selector(switchChanged: ) forControlEvents:UIControlEventValueChanged];
    switchView.tag = indexPath.row;
    
//    CGRect flagRect = CGRectMake(self.frame.size.width-55, 5, 40, 30);
//    UISwitch *flagSwitch = [SwitchFactory planeSwitch:flagRect
//                                                   on:flag
//                                             delegate:self
//                                               action:@selector(changeRunFlag:)
//                                                  tag:indexPath.row];
//    cell.backgroundColor = (flag) ? [UIColor whiteColor] : HIDDEN_COLOR;
//    
//    [cellView addSubview:alarmLabel];
//    [cellView addSubview:flagSwitch];
//    
//    [cell.contentView addSubview:cellView];
    return cell;

    
    
    
    
    
    
    
    
    
    
    
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Get list of local notifications
//    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    UILocalNotification *localNotification = [localNotifications objectAtIndex:indexPath.row];
//    
//    
//    
//    
//    
//    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
//    dateFormatter.timeStyle = NSDateFormatterShortStyle;
//    dateFormatter.dateStyle = NSDateFormatterShortStyle;
//    NSString *dateTimeString = [dateFormatter stringFromDate:localNotification.fireDate];
//    
//    
//    UILabel *toDoList = (UILabel*) [cell viewWithTag:1];
//    [toDoList setText:localNotification.alertBody];
//    UILabel *remindme = (UILabel*) [cell viewWithTag:2];
//    [remindme setText:dateTimeString];
//
//    UILabel *hiddenid = (UILabel*) [cell viewWithTag:3];
//    [hiddenid setText:localNotification.userInfo[@"ID"]];
    
    // Display notification info
//    [cell.textLabel setText:localNotification.alertBody];
//    [cell.detailTextLabel setText:[localNotification.fireDate description]];
    
//    return cell;
}

- (void)reloadTable
{
    [_model setAlarmArray:[_helper selectAll]];
    [_tableList reloadData];
}

- (void) switchChanged:(UISwitch*)sw {
    NSString *flag = (sw.on) ? @"1" : @"0";
    NSMutableDictionary *takeDic = [_model getAlarmDic:sw.tag];
    [takeDic setObject:flag forKey:@"RUN_FLAG"];
    
    [_helper update:takeDic];
    [_model setAlarmNotification];
    [self reloadTable];
}

//- (IBAction)changeRunFlag:(id)sender {
////    NSString *flag = (_changFlag.on) ? @"1" : @"0";
////    NSMutableDictionary *takeDic = [_model getAlarmDic:_changFlag.tag];
////    [takeDic setObject:flag forKey:@"RUN_FLAG"];
////    
////    [_helper update:takeDic];
////    [_model setAlarmNotification];
////    [self reloadTable];
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
//     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//     
//     
//     UILabel *hiddenid = (UILabel*) [cell viewWithTag:3];
//     NSString *ID =hiddenid.text;
//     
//     
//     UIApplication *app = [UIApplication sharedApplication];
//     NSArray *eventArray = [app scheduledLocalNotifications];
//     for (int i=0; i<[eventArray count]; i++)
//     {
//         UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//         NSDictionary *userInfoCurrent = oneEvent.userInfo;
//         NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"ID"]];
//         if ([uid isEqualToString:ID])
//         {
//             //Cancelling local notification
//             [app cancelLocalNotification:oneEvent];
//             //break;
//         }
//     }
//     
//     [NSThread sleepForTimeInterval:0.5];
//     AddToDoViewController *addController = [[AddToDoViewController alloc] init];
//     [addController initArray:ID];
//     [self reloadTable];
// 
// }
// else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
// }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                title:@"Delete"
                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                  [_helper delete:[_model getAlarmDic:indexPath.row]];
                                                  [self reloadTable];
                                              }]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
