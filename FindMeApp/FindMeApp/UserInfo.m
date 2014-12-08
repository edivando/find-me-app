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
                    deviceId:(NSString*)deviceId
                connectionId:(NSString*)connectionId
{
    self = [super init];
    if (self) {
        _user = user;
        _latitude = latitude;
        _longitude = longitude;
        _telefone = telefone;
        _email = email;
        _deviceId = deviceId;
        _connectionId = connectionId;
        _status = @"DISCONNECTED";
        _permission = @"NO";
        _cor = @"";
        
        _deviceId = deviceId;
        _connectionId = connectionId;
    }
    return self;
}

-(GMSMarker*) marker{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(_latitude, _longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    //marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed:@"map-marker"];
    marker.icon = [GMSMarker markerImageWithColor:[self color]];
    marker.title = _user;
    return marker;
    
}
-(BOOL)isEqualUser:(UserInfo*)user{
    //provisorio
    if([_telefone isEqual:@""] || [user.telefone isEqual:@""])
        return NO;
    if (_telefone.length <8 || user.telefone.length<8) {
        return  NO;
    }
    _telefone = [[_telefone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    _telefone = [_telefone substringFromIndex: [_telefone length] - 8];
    
    user.telefone = [[user.telefone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    user.telefone = [user.telefone substringFromIndex: [user.telefone length] - 8];
    
    return [_telefone isEqual:user.telefone];
}

-(UIColor*) color{
    NSArray *aux = [_cor componentsSeparatedByString:@"|"];
    return [UIColor colorWithRed:[aux[0] floatValue]/255.0 green:[aux[1] floatValue]/255.0 blue:[aux[2] floatValue]/255.0 alpha:1.0];
}

@end
