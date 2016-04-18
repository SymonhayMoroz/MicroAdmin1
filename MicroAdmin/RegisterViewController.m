//
//  RegisterViewController.m
//  MicroAdmin
//
//  Created by dev on 2/25/16.
//  Copyright © 2016 company. All rights reserved.
//

#import "RegisterViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface RegisterViewController ()

@property (strong, nonatomic) MBProgressHUD *loader;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    
    self.loader = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    self.loader.labelText = @"Please wait for a moment.";
    self.loader.labelFont = [UIFont fontWithName:@"Bariol-Bold" size:[UIFont systemFontSize]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.regWeb.delegate = self;
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ikzzp.nl/microadmin"]];
    [self.regWeb loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loader hide:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
