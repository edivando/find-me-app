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

@interface ViewControllerContactsPicker : ViewController <ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbNome;
@property (weak, nonatomic) IBOutlet UILabel *lbTel;
- (IBAction)showPicker:(UIButton *)sender;

@end
