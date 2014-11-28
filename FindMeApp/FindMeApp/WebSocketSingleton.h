//
//  WebSocketSingleton.h
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSocket.h"

@interface WebSocketSingleton : NSObject

+(WebSocket*) getConnection;

@end
