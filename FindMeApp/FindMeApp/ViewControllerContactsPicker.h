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

@interface ViewControllerContactsPicker : ViewController <ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbNome;
@property (weak, nonatomic) IBOutlet UILabel *lbTel;
- (IBAction)showPicker:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
