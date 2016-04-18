//
//  YelpYapper.m
//  Glutton
//
//  Created by Tyler on 4/2/15.
//  Copyright (c) 2015 TylerCo. All rights reserved.
//

#import "getData.h"
#import <AFNetworking/AFNetworking.h>
//#import "NSURLRequest+OAuth.h"
/**
 Default paths and search terms used in this example
 */
static NSString * const kAPIHost           = @"ikzzp.nl";
static NSString * const kSearchPath        = @"/microadmin/";

NSMutableDictionary *contactsData;
NSMutableArray *orderedKeys;
@implementation getData


//+ (NSArray *)getBusinesses:(float)offsetFromCurrentLocation {
////    NSLog(@"In the other business method");
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [[manager HTTPRequestOperationWithRequest:[self searchRequest:CLLocationCoordinate2DMake(0.0, 0.0) withOffset:0] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",[responseObject objectForKey:@"businesses"]);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }] start];
//    return nil;
//}

//+ (NSArray *)getRequest{
//    //    NSLog(@"In the other business method");
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [[manager HTTPRequestOperationWithRequest:[self searchRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",[responseObject objectForKey:@"businesses"]);
//    
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    
//    }] start];
//    return nil;
//}


+ (NSURLRequest *)searchRequest{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"rows" forKey:@"json"];
    [params setObject:@"obj" forKey:@"listcontacts"];
    
     NSURL *url = [NSURL URLWithString:@"http://www.ikzzp.nl/microadmin/?json=rows&obj=listcontacts"];
    return [NSURLRequest requestWithURL:url];
}

+ (NSURLRequest *)searchRequestContact:(NSString*)contactID{
    
 
    NSString *strURL = [[NSString alloc]initWithFormat:@"http://www.ikzzp.nl/microadmin/?json=row&obj=editcontact&id_contact=%@",contactID];
    NSURL *url = [NSURL URLWithString:strURL];
    return [NSURLRequest requestWithURL:url];
}

+ (NSURLRequest *)DeleteRequestContact:(NSString*)postString{
    
    //NSString *strURL =[[NSString alloc]initWithFormat:@"%@&%@", @"http://www.ikzzp.nl/microadmin?json=post&obj=editcontact&act=delete", postString];
    NSString *strURL =@"http://www.ikzzp.nl/microadmin?json=post&obj=editcontact&act=delete";
//    NSString *post = [[NSString alloc] initWithFormat:@"gps_lat=%.6f&gps_long=%.6f&message=%@",location.coordinate.latitude,location.coordinate.longitude, @"travel"];
//    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:postData];
    return theRequest;
    
}

+ (NSURLRequest *)UpdateRequestContact:(NSString*)postString{
    
   //NSString *strURL =[[NSString alloc]initWithFormat:@"%@&%@", @"http://www.ikzzp.nl/microadmin?json=post&obj=editcontact&act=update", postString];
    NSString *strURL = @"http://www.ikzzp.nl/microadmin?json=post&obj=editcontact&act=update";
   // NSString *strURL1 = [[NSString alloc] initWithFormat:@"%@&%@", strURL, postString];
   NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    return theRequest;
    
}
@end
