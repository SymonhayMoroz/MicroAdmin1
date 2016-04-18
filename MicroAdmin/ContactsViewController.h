//
//  ContactsViewController.h
//  MicroAdmin
//
//  Created by dev on 2/18/16.
//  Copyright © 2016 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblContacts;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
