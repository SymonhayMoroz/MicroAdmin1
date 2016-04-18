//
//  GPSViewController.h
//  MicroAdmin
//
//  Created by dev on 2016. 2. 22..
//  Copyright © 2016년 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GPSViewController : UIViewController<CLLocationManagerDelegate, UITextFieldDelegate, NSURLConnectionDelegate>{
    CLLocation* location;
    NSDate* init_Timer;
    NSString *str_travel;
    NSMutableData *mutableData;
#define URL @"http://www.earchief.nl/microadmin/?obj=edittravelgpslog&json=post&act=insert"
    
#define URL1 @"http://www.ikzzp.nl/microadmin/?obj=edittravelgpslog&json=post&act=insert"
    
}

@property(strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)GPSEnable:(id)sender;
- (IBAction)DownLoadEnable:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SubmitButton;

@property (weak, nonatomic) IBOutlet UITextField *Travel_History;
@property (weak, nonatomic) IBOutlet UISwitch *GPSEnable;
@property (weak, nonatomic) IBOutlet UISwitch *DownloadEnable;
@end
