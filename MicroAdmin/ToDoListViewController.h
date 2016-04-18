//
//  ToDoListViewController.h
//
//  LocalNotificationDemo
//
//  Created by Maksim S. on 2/5/2016.
//

#import <UIKit/UIKit.h>
#import "AddToDoViewController.h"

@interface ToDoListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableList;


@property AlarmModel *model;
@property AlarmDBHelper *helper;

@end
