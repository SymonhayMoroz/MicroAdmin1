//
//  ViewController.m
//  MicroAdmin
//
//  Created by dev on 2016. 2. 13..
//  Copyright © 2016 year company. All rights reserved.
//

#import "ViewController.h"
#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "getData.h"

@interface ViewController (){
    NSString *strUsername;
    NSString *strPassword;
}
@property (strong, nonatomic) MBProgressHUD *loginProgress;
@property (strong, nonatomic) MBProgressHUD *loader;
@end

@implementation ViewController

@synthesize btnSelect;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnSelect.layer.borderWidth = 1;
    btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
    btnSelect.layer.cornerRadius = 5;
    
    _indicator.hidden = YES;
    self.emailText.delegate = self;
    self.pswText.delegate   = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    strUsername = [defaults objectForKey: @"username"];
    strPassword = [defaults objectForKey: @"password"];
    
    self.emailText.text = strUsername;
    self.pswText.text = strPassword;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
//    [self loginfunction];
//    return;
    
    NSString *userEmail = self.emailText.text;//_emailText.text;
    NSString *password = self.pswText.text;
    
    if ([userEmail isEqualToString:@""] || [password isEqualToString:@""]) {
        userEmail = @"auwdio@hotmail.com";
        password = @"testtest";
        strUsername = userEmail;
        strPassword = password;        
    }else{
        strUsername = self.emailText.text;
        strPassword = self.pswText.text;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@", userEmail, password];
    NSString *md5String = [NSString stringWithFormat:@"%@", [str MD5]];
    
    NSString *post = [[NSString alloc] initWithFormat:@"email=%@&myhash=%@",userEmail,md5String];
    
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
        //_indicator.hidden = NO;
        //[_indicator startAnimating];
        self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        self.loginProgress.labelText = @"Log in...";
        self.loginProgress.labelFont = [UIFont fontWithName:@"Bariol-Bold" size:[UIFont systemFontSize]];
        
        mutableData = [[NSMutableData alloc] init];
    }
    else
    {
        NSLog(@"Internet problem maybe...");
    }
}



#pragma mark NSURLConnection delegates

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
    //_indicator.hidden = YES;
    //[_indicator stopAnimating];
    [self.loginProgress hide:YES];
    [self show_toast:@"connection fail"];
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *loginStatus = [[NSString alloc] initWithBytes: [mutableData mutableBytes] length:[mutableData length] encoding:NSUTF8StringEncoding];
    NSLog(@"after compareing data is %@", loginStatus);
    if ([loginStatus isEqualToString:@"ok"]) {
        //[self show_toast:@"OK"];
        // right login
        [self getRequestData];
        
    } else {
        // wrong login
        [self show_toast:loginStatus];
    }
    [self.loginProgress hide:YES];
    //_indicator.hidden = YES;
    //[_indicator stopAnimating];
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

- (void)getRequestData {
    
    self.loader = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    self.loader.labelText = @"Please wait a moment...";
    self.loader.labelFont = [UIFont fontWithName:@"Bariol-Bold" size:[UIFont systemFontSize]];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [[manager HTTPRequestOperationWithRequest:[getData searchRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponseError = [responseObject objectForKey:@"err"];
        if ([strResponseError isKindOfClass:[NSNull class]]) {
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
            int i = (int)[contactsData count];
            if (i > 0) {
                [self sortContacts];
            }
            
            [self performSegueWithIdentifier:@"segueID_Contacts" sender:self];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:strUsername forKey:@"username"];
            [defaults setObject:strPassword forKey:@"password"];
            [defaults setObject:contactsData forKey:@"contactData"];
            
        }
        [self.loader hide:YES];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        //NSString *strError = [[NSString init]initWithFormat:@"%@", error];
        //UIAlertView to let them know that something happened with the network connection...
        [self show_toast:@"connection error"];
        [self.loader hide:YES];
    }] start];
}
-(void)sortContacts{
    
    orderedKeys = [[contactsData allKeys] mutableCopy];
    orderedKeys = [[orderedKeys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSNumericSearch];
    }]mutableCopy];
    
}

- (IBAction)OnOfflineAccess:(id)sender {
    
    NSMutableDictionary *contactDicTemp;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    contactDicTemp = [[defaults objectForKey:@"contactData"]mutableCopy];

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
    
    if (contactDicTemp != nil) {
        contactsData = [contactDicTemp mutableCopy];
        [self sortContacts];
        [self performSegueWithIdentifier:@"segueOfflineAccess" sender:self];
    }else{
        [self show_toast:@"No contact data"];
    }
}


//*************************** UITextfeild delegate ********************
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
    animatedDistance = 5;//????
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
//-----------------------------------------------------------------------



- (IBAction)selectClicked:(id)sender {
    NSArray *arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Hello 0", @"Hello 1", @"Hello 2", @"Hello 3", @"Hello 4", @"Hello 5", @"Hello 6", @"Hello 7", @"Hello 8", @"Hello 9",nil];
    
    NSArray * arrImage = [[NSArray alloc] init];
    //arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
- (void)viewDidUnload {
    //    [btnSelect release];
    btnSelect = nil;
    [self setBtnSelect:nil];
    [super viewDidUnload];
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    NSLog(@"%@", btnSelect.titleLabel.text);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
