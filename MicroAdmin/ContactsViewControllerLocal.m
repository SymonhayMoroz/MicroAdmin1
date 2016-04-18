//
//  ContactsViewController.m
//  MicroAdmin
//
//  Created by dev on 2/18/16.
//  Copyright © 2016 company. All rights reserved.
//

#import "ContactsViewControllerLocal.h"
#import "getData.h"
#import "ContactDetailViewController.h"

@interface ContactsViewControllerLocal ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *strFilter;
@property (nonatomic, strong) NSMutableArray *filteredKey;
@end

@implementation ContactsViewControllerLocal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _navBar.bounds.size.height)];
    _searchBar.showsCancelButton = YES;
    
    _searchBar.backgroundColor = [UIColor lightGrayColor];
    _searchBar.delegate = self;
    
    //    [self.tblContacts setContentOffset:CGPointMake(0, 44) animated:YES];
    [self.searchBar resignFirstResponder];
    
    _strFilter = @"";
    [self FilterData];
    
    //self.tblContacts.tableHeaderView = _searchBar;
    [self.navBar addSubview:_searchBar];
    _searchBar.hidden = YES;
    
    // Do any additional setup after loading the view.
    _tblContacts.delegate = self;
    _tblContacts.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -tblContacts tableView delegate & datasources

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection

    NSDictionary *contactOne = [contactsData objectForKey:[_filteredKey objectAtIndex:indexPath.row]];
    NSString *phNo = [contactOne objectForKey:@"phone"];
    //NSString *phNo = @"+8617073474541";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        NSString *strMessage = [[NSString alloc]initWithFormat:@"Call facility is not available! '%@'", phNo];
        [self show_toast:strMessage];
    }
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_filteredKey count];
}

// This will tell your UITableView what data to put in which cells in your table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"contact_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    NSDictionary *contactOne = [contactsData objectForKey:[_filteredKey objectAtIndex:indexPath.row]];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:1];
    NSString *strName = [[NSString alloc]initWithFormat:@"%@ %@", [contactOne objectForKey:@"firstname"], [contactOne objectForKey:@"lastname"]];
    nameLabel.text = strName;
    
    UILabel *phoneNumber = (UILabel*) [cell viewWithTag:2];
    phoneNumber.text = [contactOne objectForKey:@"phone"];
    
    UIImageView *personImage = (UIImageView*)[cell viewWithTag:4];
    personImage.image = [UIImage imageNamed:@"person1.png"];
    
    UIImageView *phoneImage = (UIImageView*)[cell viewWithTag:3];
    phoneImage.image = [UIImage imageNamed:@"phone.jpg"];
    
    return cell;
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


- (IBAction)OnSearch:(id)sender {
    _searchBar.text = @"";
    _searchBar.hidden = NO;
//    [self.tblContacts setContentOffset:CGPointMake(0, 0) animated:YES];
//
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    _strFilter = [searchBar.text lowercaseString];
    
    [self FilterData];

    [_tblContacts reloadData];
}

-(void) FilterData{
    
    if (_filteredKey == nil) {
        _filteredKey = [[NSMutableArray alloc]init];
    }else{
        [_filteredKey removeAllObjects];
    }
    if ([_strFilter isEqualToString:@""]) {
        _filteredKey = [orderedKeys mutableCopy];
        return;
    }
    NSString *strFirstName;
    NSString *strLastName;

    for (int i = 0; i < [orderedKeys count]; i++)
    {
        strFirstName = [[contactsData objectForKey:orderedKeys[i]] objectForKey:@"firstname"];
        strFirstName = [strFirstName lowercaseString];
        strLastName = [[contactsData objectForKey:orderedKeys[i]] objectForKey:@"lastname"];
        strLastName = [strLastName lowercaseString];
        if ([strFirstName rangeOfString:_strFilter].location != NSNotFound || [strLastName rangeOfString:_strFilter].location != NSNotFound ) {
            [_filteredKey addObject:orderedKeys[i]];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [self.tblContacts setContentOffset:CGPointMake(0, 44) animated:YES];
//    [self.searchBar resignFirstResponder];
    [_searchBar resignFirstResponder];
    _searchBar.hidden = YES;
    _strFilter = @"";
    [self FilterData];
    [_tblContacts reloadData];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueDetailContact"]) {
        ContactDetailViewController *contactDetail = (ContactDetailViewController *)[segue destinationViewController];
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:_tblContacts];
        NSIndexPath *hitIndex = [_tblContacts indexPathForRowAtPoint:hitPoint];
        NSString *contactID = [_filteredKey objectAtIndex:hitIndex.row];
        [contactDetail setContactID:contactID];
    }
    //
}

@end
