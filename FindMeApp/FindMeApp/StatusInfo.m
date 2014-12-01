//
//  StatusInfo.m
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "StatusInfo.h"

@implementation StatusInfo

-(instancetype) initStatusWithUser:(UserInfo*)userInfo
                            status:(NSString*)status{
    self = [super init];
    if (self) {
        _userInfo = userInfo;
        _status = status;
    }
    return self;
}

@end
