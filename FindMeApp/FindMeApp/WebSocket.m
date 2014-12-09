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
    UIAlertView *alert;
    NSString *jsonMessage;
    UserInfoDAO *dao;
}

- (void)connect {
    webSocket.delegate = nil;
    webSocket = nil;
    NSString *urlString = @"wss://findme-edivando.rhcloud.com:8443/server";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    dao = [[UserInfoDAO alloc] init];
    srandom(time(nil));
    [newWebSocket open];
}


#pragma mark - SRWebSocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    webSocket = newWebSocket;
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
    jsonMessage = message;

    //Bloco para controle de mensagens de conexao
    if ([message rangeOfString: @"{\"connectionInfo\"" ].location != NSNotFound && [message rangeOfString: @"{\"connectionInfo\"" ].location <20) {
        [self receiveConnectionInfo];
    }
    
    else if ([message rangeOfString: @"{\"userInfo\"" ].location != NSNotFound && [message rangeOfString:@"{\"userInfo\""].location < 10) {
        NSLog(@"USER INFO: %@",message);
    }
    
    //Bloco para controle de mensagens de status
    else if ([message rangeOfString: @"{\"statusInfo\"" ].location != NSNotFound && [message rangeOfString:@"{\"statusInfo\""].location < 12) {
        [self receiveStatusInfo];
    }
    
    //Bloco para controlar mensagens de requisicao
    else if ([message rangeOfString: @"{\"permissionInfo\"" ].location != NSNotFound && [message rangeOfString: @"{\"permissionInfo\"" ].location <20) {
        [self receivePermissionInfo];
    }
    [self.pickerContacts updateTable];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSError* error;
    PermissionInfoMessage *pi = [[PermissionInfoMessage alloc] initWithString:jsonMessage error:&error];
    pi.permissionInfo.status = buttonIndex == 0 ? @"NO" : @"YES";
    [self sendMessage:[pi toJSONString]];

    NSArray *usuarios = [dao fetchWithKey:@"telefone" andValue:pi.permissionInfo.from.telefone];
    if(usuarios.count>0){
        NSManagedObject *result = [usuarios objectAtIndex:0];
        [result setValue:pi.permissionInfo.status forKey:@"permission"];
        [result setValue:@"CONNECTED" forKey:@"status"];
        [dao update:result];
    }else{
        pi.permissionInfo.from.status = @"CONNECTED";
        pi.permissionInfo.from.permission = pi.permissionInfo.status;
        pi.permissionInfo.from.cor = [self randCor];
        [dao save:pi.permissionInfo.from];
    }
}

#pragma mark receiveMessages
-(void) receiveConnectionInfo{
    NSError* error;
    //Extraindo o connectionId da mensagem
    ConnectionInfoMessage *recebida = [[ConnectionInfoMessage alloc] initWithString:jsonMessage error:&error];
    
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

-(void) receiveStatusInfo{
    NSError* error;
    //Se usuario desconectar, excluir usuario do banco
    StatusInfoMessage *recebida = [[StatusInfoMessage alloc] initWithString:jsonMessage error:&error];
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

-(void) receivePermissionInfo{
    NSError* error;
    PermissionInfoMessage *recebida = [[PermissionInfoMessage alloc] initWithString:jsonMessage error:&error];
    if ([recebida.permissionInfo.status isEqualToString:@"NOT_CONNECT"]) {
        NSArray *contatos = [dao fetchWithKey:@"nome" andValue:recebida.permissionInfo.to.user];
        [dao deleteManaged:[contatos objectAtIndex:0]];
        alert = [[UIAlertView alloc] initWithTitle:@"Esse usuário não está cadastrado" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([recebida.permissionInfo.status isEqualToString:@"YES"] || [recebida.permissionInfo.status isEqualToString:@"NO"]) {
        [self updateUserInfo:recebida.permissionInfo.to.telefone status:recebida.permissionInfo.status];
    }
    else if([recebida.permissionInfo.status isEqualToString:@"CONNECT"]){
        alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"O usuario %@ esta querendo te encontrar",recebida.permissionInfo.from.user] message:@"Deseja permitir que ele te localize?" delegate:self cancelButtonTitle:@"Nao" otherButtonTitles:@"Sim",nil];
        [alert show];
    }

}

-(void) updateUserInfo:(NSString*)telefone status:(NSString*)status {
    NSArray *usuarios = [dao fetchWithKey:@"telefone" andValue:telefone];
    if(usuarios.count>0){
        NSManagedObject *result = [usuarios objectAtIndex:0];
        [result setValue:status forKey:@"permission"];
        [result setValue:@"CONNECTED" forKey:@"status"];
        [dao update:result];
    }
}

#pragma mark sendMessages
-(void) sendMessage:(NSString*)message{
    [webSocket send:message];
}

-(void) sendUserInfoMessage:(UserInfo*)user{
    UserInfoMessage *message = [[UserInfoMessage alloc] initWithUser:user];
    [self sendMessage:[message toJSONString]];
}

-(void) sendPermissionMessageFrom:(UserInfo*)userFrom To:(UserInfo*)userTo status:(NSString*)status{
    PermissionInfo *permission = [[PermissionInfo alloc] initPermissionWithUserFrom:userFrom userTo:userTo status:status];
    PermissionInfoMessage *permissionMessage = [[PermissionInfoMessage alloc] initWithPermission:permission];
    [self sendMessage:[permissionMessage toJSONString]];
}


-(NSString*) randCor{
    return [NSString stringWithFormat:@"%ld|%ld|%ld", random()%255,random()%50,random()%255];
}
@end
