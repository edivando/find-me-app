//
//  ViewControllerRegistration.h
//  FindMeApp
//
//  Created by Yuri Anfrisio Reis on 11/29/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "UserInfoDAO.h"
#import "ViewController.h"
#import "UserInfoMessage.h"
#import "WebSocket.h"
#import "WebSocketSingleton.h"

@interface ViewControllerRegistration : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textNome;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textTelefone;
- (IBAction)btDone:(UIButton *)sender;

@end
