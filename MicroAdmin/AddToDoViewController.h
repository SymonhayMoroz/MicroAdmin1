//
//  AddToDoViewController.h
//  LocalNotificationDemo
//
//  Created by Maksim S. on 2/5/2016.
//

#import <UIKit/UIKit.h>
#import "AlarmDBHelper.h"
#import "AlarmModel.h"

@interface AddToDoViewController : UIViewController<UITextFieldDelegate>


@property AlarmDBHelper *helper;

@property (weak, nonatomic) IBOutlet UITextField *itemText;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel:(id)sender;


@property (strong, nonatomic) IBOutlet UISwitch *oneHourSwitch;
- (IBAction)oneHourSwitchClick:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *twoHourSwitch;
- (IBAction)twoHourSwitchClick:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *adaySwitch;
- (IBAction)adaySwitchClick:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *twodaySwitch;
- (IBAction)twodaySwitch:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *dataPickerSwitch;
- (IBAction)dataPickerEnable:(id)sender;

-(void)initArray:(NSString*)KEY;


@end
