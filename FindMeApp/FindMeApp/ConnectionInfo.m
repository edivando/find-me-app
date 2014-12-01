//
//  ConnectionInfo.m
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ConnectionInfo.h"

@implementation ConnectionInfo

-(instancetype) initConnectionInfoWithUser:(UserInfo*)userInfo
                               activeUsers:(NSArray*)activeUsers{
    self = [super init];
    if (self) {
        _userInfo = userInfo;
        _activeUsers = activeUsers;
    }
    return self;
}

@end
