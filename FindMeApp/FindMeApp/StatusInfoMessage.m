//
//  StatusInfoMessage.m
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "StatusInfoMessage.h"

@implementation StatusInfoMessage

-(instancetype) initWithStatus:(StatusInfo*)statusInfo{
    self = [super init];
    if (self) {
        _statusInfo = statusInfo;
    }
    return self;
}

@end
