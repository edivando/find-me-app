//
//  PermissionInfoMessage.m
//  FindMeApp
//
//  Created by Yuri Anfrisio Reis on 12/3/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "PermissionInfoMessage.h"

@implementation PermissionInfoMessage

-(instancetype) initWithPermission:(PermissionInfo*) permissionInfo{
    self = [super init];
    if (self) {
        _permissionInfo = permissionInfo;
    }
    return self;
}

@end
