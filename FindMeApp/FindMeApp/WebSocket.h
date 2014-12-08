//
//  WebSocket.h
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>
#import "UserInfo.h"
#import "UserInfoMessage.h"
#import "UserInfoDAO.h"
#import "ConnectionInfoMessage.h"
#import "StatusInfoMessage.h"
#import "PermissionInfoMessage.h"
#import "ContactPickerDelegate.h"

@interface WebSocket : NSObject <SRWebSocketDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) id <ContactPickerDelegate> delegate;

- (void)connect;
//- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket;
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

- (void)sendMessage:(NSString*)message;


-(void) sendUserInfoMessage:(UserInfo*)user;
-(void) sendPermissionMessageFrom:(UserInfo*)userFrom To:(UserInfo*)userTo status:(NSString*)status;
@end
