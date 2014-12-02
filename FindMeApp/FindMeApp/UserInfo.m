//
//  PositionJson.m
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (instancetype)initWithUser:(NSString*)user
                    latitude:(float)latitude
                   longitude:(float)longitude
                       email:(NSString*)email
                    telefone:(NSString*)telefone
                    idServer:(NSInteger)idServer
                connectionId:(NSString*)connectionId
{
    self = [super init];
    if (self) {
        _user = user;
        _latitude = latitude;
        _longitude = longitude;
        _telefone = telefone;
        _email = email;
        _idServer = idServer;
        _connectionId = connectionId;

        
        _idServer = idServer;
        _connectionId = connectionId;
    }
    return self;
}

-(GMSMarker*) marker{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(_latitude, _longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed:@"flag_icon"];
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    marker.title = _user;
    return marker;
}

@end
