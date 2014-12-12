//
//  TableViewCell.m
//  FindMeApp
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell{
    UserInfoDAO *dao;
    WebSocket *socket;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btPermission:(UIButton *)sender {
    dao = [[UserInfoDAO alloc] init];
    socket = [WebSocketSingleton getConnection];
    NSString *permission = [self.userCell.permission isEqualToString:@"YES"]? @"NO": @"CONNECT";
    NSArray *usuarios = [dao fetchWithKey:@"defaultuser" andValue:@"YES"];
    if ([permission isEqualToString:@"CONNECT"]) {
        _permission.hidden = YES;
        _loadPermission.hidden = NO;
        [_loadPermission startAnimating];
        [self performSelector:@selector(stopIndicator) withObject:self afterDelay:100000];
        
        
        [socket sendPermissionMessageFrom:[dao convertToUserInfo:[usuarios objectAtIndex:0]] To:self.userCell status:permission];
    }else if([permission isEqualToString:@"NO"]){
        _permission.hidden = NO;
        _loadPermission.hidden = YES;
        [socket sendPermissionMessageFrom:self.userCell To:[dao convertToUserInfo:[usuarios objectAtIndex:0]] status:permission];
    }else{
        [socket sendPermissionMessageFrom:self.userCell To:[dao convertToUserInfo:[usuarios objectAtIndex:0]] status:permission];
    }
    NSManagedObject *result = [[dao fetchWithKey:@"deviceId" andValue:self.userCell.deviceId] objectAtIndex:0];
    [result setValue:permission forKey:@"permission"];
    [dao update:result];
    [[self pickerDelegate] updateTable];
}

-(void)stopIndicator
{
    [_loadPermission stopAnimating];
}

@end
