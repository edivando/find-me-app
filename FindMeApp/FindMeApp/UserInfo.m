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
{
    self = [super init];
    if (self) {
        _user = user;
        _latitude = latitude;
        _longitude = longitude;
        _telefone = telefone;
        _email = email;
        
        _marker = [[GMSMarker alloc] init];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(_latitude, _longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon = [UIImage imageNamed:@"flag_icon"];
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
        marker.title = _user;
        _marker = marker;
        
    }
    return self;
}

@end
