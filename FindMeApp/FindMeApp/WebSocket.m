//
//  WebSocket.m
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "WebSocket.h"

@implementation WebSocket{
    SRWebSocket *webSocket;
}

- (void)connect {
    webSocket.delegate = nil;
    webSocket = nil;
    
    NSString *urlString = @"wss://findme-edivando.rhcloud.com:8443/server";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}


#pragma mark - SRWebSocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    webSocket = newWebSocket;
    //[webSocket send:[NSString stringWithFormat:@"Hello from %@", [UIDevice currentDevice].name]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connect];
    NSLog(@"Error: %@",error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Reason: %@",reason);
    [self connect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSError* error;
    
    if ([message rangeOfString: @"{\"connectionInfo\"" ].location != NSNotFound && [message rangeOfString: @"{\"connectionInfo\"" ].location <20) {
        //Extraindo o connectionId da mensagem
        ConnectionInfoMessage *recebida = [[ConnectionInfoMessage alloc] initWithString:message error:&error];
        
        //Atualizar o usuario default com o connectionId atual
        UserInfoDAO *dao = [[UserInfoDAO alloc] init];
        if ([[dao fetchWithKey:@"defaultuser" andValue:@"YES"] count]!=0) {
            NSManagedObject *fetchResult = [[dao fetchWithKey:@"defaultuser" andValue:@"YES"] objectAtIndex:0];
            [fetchResult setValue:recebida.connectionInfo.userInfo.connectionId forKey:@"connectionId"];
            NSLog(@"%@",[dao update:fetchResult]);
        }
        
        
        //Teste
        for (UserInfo *userAtivo in recebida.connectionInfo.activeUsers) {
                [dao save:userAtivo];
        }
        
        
        //Atualiza usuarios ativos
        for (UserInfo *userBD in [dao convertToUsersInfo:[dao fetchWithKey:@"defaultuser" andValue:@"NO"]]) {
            for (UserInfo *userAtivo in recebida.connectionInfo.activeUsers) {
                if ([userAtivo isEqualUser:userBD]) {
                    userBD.latitude     = userAtivo.latitude;
                    userBD.longitude    = userAtivo.longitude;
                    userBD.connectionId = userAtivo.connectionId;
                    [dao updateUserInfo:userBD];
                }
            }
            
        }
        
    }
    if ([message rangeOfString: @"{\"userInfo\"" ].location != NSNotFound && [message rangeOfString:@"{\"userInfo\""].location < 10) {
        NSLog(@"USER INFO: %@",message);
    }
    if ([message rangeOfString: @"{\"statusInfo\"" ].location != NSNotFound && [message rangeOfString:@"{\"statusInfo\""].location < 12) {
        //Se usuario desconectar, excluir usuario do banco
        NSLog(@"STATUS INFO: %@",message);
    }
}

-(void) sendMessage:(NSString*)message{
    [webSocket send:message];
}

@end
