//  TableViewCell.h
//  FindMeApp
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "PermissionInfoMessage.h"
#import "UserInfoDAO.h"
#import "WebSocketSingleton.h"
#import "ViewControllerContactsPicker.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic) UserInfo *userCell;
@property (nonatomic) ViewControllerContactsPicker *pickerDelegate;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *imgUserColor;
- (IBAction)btPermission:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *permission;

@end
