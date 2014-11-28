//
//  PositionJson.m
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "PositionJson.h"

@implementation PositionJson

- (instancetype)initWithUser:(NSString*)user
                    latitude:(float)latitude
                   longitude:(float)longitude
                       email:(NSString*)email
                    telefone:(NSString*)telefone
{
    self = [super init];
    if (self) {
        _user = user;
        _latitude = latitude;
        _longitude = longitude;
        _telefone = telefone;
        _email = email;
    }
    return self;
}

@end
