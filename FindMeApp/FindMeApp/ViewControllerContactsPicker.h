//
//  ViewControllerContactsPicker.h
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "WebSocket.h"
#import "WebSocketSingleton.h"
#import "UserInfoDAO.h"
#import "TableViewCell.h"
#import "PermissionInfoMessage.h"
#import "ContactPickerDelegate.h"

@interface ViewControllerContactsPicker : UIViewController <ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,ContactPickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addContato:(UIButton *)sender;

@end
