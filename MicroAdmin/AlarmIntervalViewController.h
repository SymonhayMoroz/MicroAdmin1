//
//  AlarmIntervalViewController.h
//  MicroAdmin
//
//  Created by dev on 2016. 3. 11..
//  Copyright © 2016년 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmIntervalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *alarmListText;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicer;

@property (strong, nonatomic) IBOutlet UISwitch *oneHourSwitch;
- (IBAction)oneHourSwitchClick:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *twoHourSwitch;
- (IBAction)twoHourSwitchClick:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *adaySwitch;
- (IBAction)adaySwitchClick:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *twodaySwitch;
- (IBAction)twodaySwitchClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
