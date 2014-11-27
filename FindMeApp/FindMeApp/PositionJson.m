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
{
    self = [super init];
    if (self) {
        _user = user;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

-(NSDictionary*) dictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.user,@"user",@(self.latitude),@"latitude",@(self.longitude), @"longitude", nil];
    
//    
//    NSDictionary * itens = @{@"longitude" : @(self.longitude),
//                             @"latitude" : @(self.latitude),
//                             @"user" : self.user};
//    
//    NSDictionary *dict = @{@"positionInfo":itens};
//    return dict;
}

@end
