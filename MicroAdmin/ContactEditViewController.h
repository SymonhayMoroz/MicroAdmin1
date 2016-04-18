//
//  ContactModifyViewController.h
//  MicroAdmin
//
//  Created by dev on 2/18/16.
//  Copyright © 2016 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactEditViewController : UIViewController<UITextFieldDelegate, NSURLConnectionDelegate>{
    UIDatePicker *datePicker;
    NSMutableData *mutableData;
}


@property (strong, nonatomic) IBOutlet UIButton *btnCustomer;
- (IBAction)btnCustomerClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnGender;
- (IBAction)btnGenderClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSelectCountry;
- (IBAction)btnSelectCountryClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnPostalCountry;
- (IBAction)btnPostalCountryClick:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddr;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAddr;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtPostalAddr;
@property (weak, nonatomic) IBOutlet UITextField *txtPostalZip;
@property (weak, nonatomic) IBOutlet UITextField *txtPostalCity;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterNote;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany;


- (IBAction)OnSaveContact:(id)sender;

- (IBAction)OnDeleteContact:(id)sender;

@property (strong, nonatomic) NSString *contactID;

@end
