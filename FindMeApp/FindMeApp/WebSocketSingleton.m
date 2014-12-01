//
//  WebSocketSingleton.m
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "WebSocketSingleton.h"

@implementation WebSocketSingleton
    
static WebSocket *webSocket;

+(WebSocket*) getConnection{
    if(webSocket == NULL){
        webSocket = [WebSocket new];
        [webSocket connect];
    }
    return webSocket;
}


@end
