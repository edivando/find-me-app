//
//  ViewControllerSocket.h
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRWebSocket.h>
#import "AppDelegate.h"
#import "UserInfoDAO.h"
#import "UserInfo.h"
#import "WebSocketSingleton.h"

@interface ViewControllerSocket : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *telefone;
- (IBAction)sendMessage:(UIButton *)sender;
- (IBAction)loadData:(UIButton *)sender;

@end
