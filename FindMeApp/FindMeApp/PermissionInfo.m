//
//  PermissionInfo.m
//  FindMeApp
//
//  Created by Yuri Anfrisio Reis on 12/3/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "PermissionInfo.h"

@implementation PermissionInfo

-(instancetype) initPermissionWithUserFrom:(UserInfo*)from
                                    userTo:(UserInfo*)to
                                    status:(NSString*)status{
    self = [super init];
    if (self) {
        _from = from;
        _to = to;
        _status = status;
    }
    return self;
}


@end
