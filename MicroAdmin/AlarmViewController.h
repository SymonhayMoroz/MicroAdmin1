//
//  AlarmViewController.h
//  MicroAdmin
//
//  Created by dev on 2016. 3. 8..
//  Copyright © 2016년 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *oneHourText;
@property (strong, nonatomic) IBOutlet UISwitch *oneHourSwitch;
- (IBAction)oneHourClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *twoHourText;
@property (strong, nonatomic) IBOutlet UISwitch *twoHourSwitch;
- (IBAction)twoHourClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *adayText;
@property (strong, nonatomic) IBOutlet UISwitch *adaySwitch;
- (IBAction)adayClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *twodayText;
@property (strong, nonatomic) IBOutlet UISwitch *twodaySwitch;
- (IBAction)twodayClick:(id)sender;
-(void)checkAlarmSetting;
-(void)checkSwitchDisable:(NSString*)key;

@end
