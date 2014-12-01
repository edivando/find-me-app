//
//  ConnectionInfoMessage.m
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ConnectionInfoMessage.h"

@implementation ConnectionInfoMessage

-(instancetype) initWithConnectionInfo:(ConnectionInfo*)connectionInfo{
    self = [super init];
    if (self) {
        _connectionInfo = connectionInfo;
    }
    return self;
}

@end
