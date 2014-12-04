//
//  WebSocket.m
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "WebSocket.h"
#import "ViewController.h"

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
    UserInfoDAO *dao = [[UserInfoDAO alloc] init];
    //ViewController* controllerMap;

    //Bloco para controle de mensagens de conexao
    if ([message rangeOfString: @"{\"connectionInfo\"" ].location != NSNotFound && [message rangeOfString: @"{\"connectionInfo\"" ].location <20) {
        //Extraindo o connectionId da mensagem
        ConnectionInfoMessage *recebida = [[ConnectionInfoMessage alloc] initWithString:message error:&error];
        
        //Atualizar o usuario default com o connectionId atual
        if ([[dao fetchWithKey:@"defaultuser" andValue:@"YES"] count]!=0) {
            NSManagedObject *fetchResult = [[dao fetchWithKey:@"defaultuser" andValue:@"YES"] objectAtIndex:0];
            [fetchResult setValue:recebida.connectionInfo.userInfo.connectionId forKey:@"connectionId"];
            [dao update:fetchResult];
        }
        
        //Atualiza usuarios ativos
        for (NSManagedObject *userBD in [dao fetchWithKey:@"defaultuser" andValue:@"NO"]) {
            for (UserInfo *userAtivo in recebida.connectionInfo.activeUsers) {
                if ([userAtivo isEqualUser:[dao convertToUserInfo:userBD]]) {
                    [userBD setValue:@"CONNECTED" forKey:@"status"];
                    [userBD setValue:@(userAtivo.latitude) forKey:@"latitude"];
                    [userBD setValue:@(userAtivo.longitude) forKey:@"longitude"];
                    [userBD setValue:userAtivo.connectionId forKey:@"connectionId"];
                    [dao update:userBD];
                }
            }
            
        }
        
    }
    else if ([message rangeOfString: @"{\"userInfo\"" ].location != NSNotFound && [message rangeOfString:@"{\"userInfo\""].location < 10) {
        NSLog(@"USER INFO: %@",message);
    }
    
    //Bloco para controle de mensagens de status
    else if ([message rangeOfString: @"{\"statusInfo\"" ].location != NSNotFound && [message rangeOfString:@"{\"statusInfo\""].location < 12) {
        //Se usuario desconectar, excluir usuario do banco
        StatusInfoMessage *recebida = [[StatusInfoMessage alloc] initWithString:message error:&error];
        //recebida.statusInfo.userInfo
        NSArray *usuarios = [dao fetchWithKey:@"connectionId" andValue:recebida.statusInfo.userInfo.connectionId];
        if (usuarios.count > 0) {
            NSManagedObject *result = [usuarios objectAtIndex:0];
            [result setValue:recebida.statusInfo.status forKey:@"status"];
            if ([recebida.statusInfo.status isEqualToString:@"EXITED"]) {
                [dao deleteManaged:result];
            }
            else{
                [dao update:result];
            }
        }
    }
    
    //Bloco para controlar mensagens de requisicao
    else if ([message rangeOfString: @"{\"permissionInfo\"" ].location != NSNotFound && [message rangeOfString: @"{\"permissionInfo\"" ].location <20) {
        PermissionInfoMessage *recebida = [[PermissionInfoMessage alloc] initWithString:message error:&error];
        if ([recebida.permissionInfo.status isEqualToString:@"NOT_CONNECT"]) {
            NSLog(@"Usuario nao existe");
        }
        else if ([recebida.permissionInfo.status isEqualToString:@"YES"]) {
            NSLog(@"Permissao concedida");
            NSArray *usuarios = [dao fetchWithKey:@"telefone" andValue:recebida.permissionInfo.to.telefone];
            if(usuarios.count>0){
                NSManagedObject *result = [usuarios objectAtIndex:0];
                [result setValue:@"permission" forKey:@"YES"];
                [dao update:result];
            }
            //Atualizar usuario "to"no banco
        }
        else if ([recebida.permissionInfo.status isEqualToString:@"NO"]){
            NSLog(@"Permissao negada");
            NSArray *usuarios = [dao fetchWithKey:@"telefone" andValue:recebida.permissionInfo.to.telefone];
            if(usuarios.count>0){
                NSManagedObject *result = [usuarios objectAtIndex:0];
                [result setValue:@"permission" forKey:@"NO"];
                [dao update:result];
            }
            //Atualizar usuario "to" no banco
        }
        else {
            NSLog(@"Requisicao de permissao");
            //alert
        }
        
    }
}

-(void) sendMessage:(NSString*)message{
    [webSocket send:message];
}


@end
