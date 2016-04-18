//
//  ViewController.h
//  MicroAdmin
//
//  Created by dev on 2016. 2. 13..
//  Copyright © 2016년 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewController : UIViewController<NSURLConnectionDelegate, UITextFieldDelegate, NIDropDownDelegate>{
    NSMutableData *mutableData;
    #define URL @"http://www.earchief.nl/microadmin/?obj=authentication&func=process&au_then_ti_ca_tion=PostLogin"
    
    #define URL1 @"http://www.ikzzp.nl/microadmin/?obj=authentication&func=process&au_then_ti_ca_tion=PostLogin" 
    IBOutlet UIButton *btnSelect;
    NIDropDown *dropDown;
}

- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *pswText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)selectClicked:(id)sender;
-(void)rel;
@end

