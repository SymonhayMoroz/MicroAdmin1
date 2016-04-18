//
//  GPSViewController.m
//  MicroAdmin
//
//  Created by dev on 2016. 2. 22..
//  Copyright © 2016년 company. All rights reserved.
//

#import "GPSViewController.h"


#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "getData.h"

@interface GPSViewController ()
@property (strong, nonatomic) MBProgressHUD *loginProgress;
@end

@implementation GPSViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _Travel_History.delegate = self;
    [self.SubmitButton setEnabled:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"status"];
    if ([str isEqualToString:@""] || str == nil) {
        [_GPSEnable setOn:NO animated:NO];
        _Travel_History.enabled = YES;
    }
    else{
        [_Travel_History setText:str];
        _Travel_History.enabled = NO;
        [_GPSEnable setOn:YES animated:YES];
    }
    _Travel_History.keyboardType = UIKeyboardTypeDefault;
    _Travel_History.returnKeyType = UIReturnKeyDone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    location = [locations lastObject];
    
    NSDate* timestamp = location.timestamp;
    
    //NSLog(@"Time 10 second print");
    
    if (fabs([init_Timer timeIntervalSinceDate:timestamp]) > 300){
        init_Timer = timestamp;
        str_travel = [_Travel_History text];
        
        NSLog(@"latitude = %.6f, laongitude = %.6f message = %@",location.coordinate.latitude, location.coordinate.longitude, str_travel);
        NSLog(@"Time 10 second print");
        NSString *post = [[NSString alloc] initWithFormat:@"gps_lat=%.6f&gps_long=%.6f&message=%@",location.coordinate.latitude,location.coordinate.longitude, str_travel];
        //NSString *post = [[NSString alloc] initWithFormat:@"gps_lat=%.6f&gps_long=%.6f&message=%@",12545.23333,4587.255, str_travel];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSURL *url = [NSURL URLWithString:URL1];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPBody:postData];
        
        NSURLConnection *theconnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [theconnection start];
        if( theconnection )
        {
            mutableData = [[NSMutableData alloc] init];
        }
        else
        {
            NSLog(@"Internet problem maybe...");
        }
        
    }
    else{
        NSLog(@"Time 10 more than print");
    }
}
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // show error
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *loginStatus = [[NSString alloc] initWithBytes: [mutableData mutableBytes] length:[mutableData length] encoding:NSUTF8StringEncoding];
    NSLog(@"after compareing data is %@", loginStatus);
//    if ([loginStatus isEqualToString:@"ok"]) {
//        NSLog(@"Log OK");
//    }
}


- (IBAction)GPS_Download_Setting:(id)sender {
    NSString *post = [NSString stringWithFormat:@"id_contact=%@",@"200"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.ikzzp.nl/microadmin/?json=post&obj=editcontact&act=delete"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [theConnection start];
    if( theConnection ){
        // indicator.hidden = NO;
        mutableData = [[NSMutableData alloc]init];
    }


}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = 216-(460-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}





- (IBAction)GPSEnable:(id)sender {
    
    str_travel = [_Travel_History text];
    if ([str_travel isEqualToString:@""]) {
        
        [_GPSEnable setOn:NO animated:NO];
        
        NSString *message = @"Show Message...\n Input Correctly Travel status:";
        UIAlertView *toast = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [toast show];
        int duration = 5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration *NSEC_PER_SEC), dispatch_get_main_queue(), ^{[toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        
        return;
    }
    
    
    if (_GPSEnable.on) {
        if (nil == self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
        }
        self.locationManager.delegate = self;
        init_Timer = [NSDate date];
        
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        
        [self.view endEditing:YES];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:str_travel forKey:@"status"];
        _Travel_History.enabled = NO;
    }
    else{
        [_Travel_History setText:@""];
        _Travel_History.enabled = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"" forKey:@"status"];
        [self stopUpdatingLocationWithMessage:NSLocalizedString(@"Error", @"Error")];
    }
}
- (void)stopUpdatingLocationWithMessage:(NSString *)state {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (IBAction)onSubmit:(id)sender {
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    self.loginProgress.labelText = @"Downloading...";
    self.loginProgress.labelFont = [UIFont fontWithName:@"Bariol-Bold" size:[UIFont systemFontSize]];
    
    [self getRequestData];
}

- (IBAction)DownLoadEnable:(id)sender {
    if (_DownloadEnable.on)
        [self.SubmitButton setEnabled:YES];
    else
        [self.SubmitButton setEnabled:NO];
}

- (void)getRequestData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [[manager HTTPRequestOperationWithRequest:[getData searchRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // init data
        // init _category_Dic
        if (contactsData == nil) {
            contactsData = [[NSMutableDictionary alloc]init];
            orderedKeys = [[NSMutableArray alloc]init];
        }else{
            [contactsData removeAllObjects];
            contactsData = nil;
            contactsData = [[NSMutableDictionary alloc]init];
            
            [orderedKeys removeAllObjects];
            orderedKeys = nil;
            orderedKeys = [[NSMutableArray alloc]init];
        }
        
        contactsData = [[responseObject objectForKey:@"data"] mutableCopy];
        [self sortContacts];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        
        [self.loginProgress hide:YES];
        [defaults setObject:contactsData forKey:@"contactData"];
        [self show_toast:@"download complete"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.loginProgress hide:YES];
        NSString *strError = [[NSString init]initWithFormat:@"%@", error];
        //UIAlertView to let them know that something happened with the network connection...
        [self show_toast:strError];
    }] start];
}

-(void)show_toast:(NSString *)message{
    //diplay message--------------
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    toast.backgroundColor=[UIColor redColor];
    [toast show];
    int duration = 2; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{                [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
    //----------------------------
}
-(void)sortContacts{
    
    orderedKeys = [[contactsData allKeys] mutableCopy];
    orderedKeys = [[orderedKeys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSNumericSearch];
    }]mutableCopy];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan) {
        for (UIView *view in [self.view subviews]) {
            if ([view isFirstResponder]) {
                [view resignFirstResponder];
                break;
            }
        }
    }
}

@end
