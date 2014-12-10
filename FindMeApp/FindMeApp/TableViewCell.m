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
        // Initialization code
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
    NSArray *usuarios = [dao fetchWithKey:@"defaultuser" andValue:@"YES"];
    [socket sendPermissionMessageFrom:self.userCell To:[dao convertToUserInfo:[usuarios objectAtIndex:0]] status:[self.userCell.permission isEqualToString:@"YES" ]? @"NO": @"YES"];
    NSManagedObject *result = [[dao fetchWithKey:@"telefone" andValue:[self.userCell telefoneFormat]] objectAtIndex:0];
    //result setValue: forKey:<#(NSString *)#>
}



//{"permissionInfo":{
//    "from":{"deviceId":"99C87580-9B52-4372-86BC-02A2B047D130","connectionId":"07234FC742B25B07D5BDD516945A9090","user":"yuri","email":"","telefone":"99772712","latitude":-3.74,"longitude":-38.5},
//    "to":{"deviceId":"146twfw45wr252","connectionId":"A9C3A6F80F693F6995F06F3B8428029B","user":"Edivando Alves","email":"edivando@gmail.com","telefone":"8589227247","latitude":-3.745,"longitude":-38.678},
//    "status":"YES"}}

@end
