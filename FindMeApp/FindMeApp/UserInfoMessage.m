//
//  UserInfoMessage.m
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "UserInfoMessage.h"

@implementation UserInfoMessage

-(instancetype) initWithUser:(UserInfo*) userInfo{
    self = [super init];
    if (self) {
        _userInfo = userInfo;
    }
    return self;
}

@end
