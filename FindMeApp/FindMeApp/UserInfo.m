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
        _status = @"DISCONNECTED";
        _permission = @"NO";
        
        _idServer = idServer;
        _connectionId = connectionId;
    }
    return self;
}

-(GMSMarker*) marker{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(_latitude, _longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    //marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed:@"flag_icon"];
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    marker.title = _user;
    return marker;
}
-(BOOL)isEqualUser:(UserInfo*)user{
    //provisorio
    if([_telefone isEqual:@""] || [user.telefone isEqual:@""])
        return NO;
    _telefone = [_telefone stringByReplacingOccurrencesOfString:@" " withString:@""];
    _telefone = [_telefone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    _telefone = [_telefone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    _telefone = [_telefone stringByReplacingOccurrencesOfString:@")" withString:@""];
    _telefone = [_telefone substringFromIndex: [_telefone length] - 8];
    //_telefone = [_telefone substringWithRange:NSMakeRange(_telefone.length-8,_telefone.length)];
    
    user.telefone = [user.telefone stringByReplacingOccurrencesOfString:@" " withString:@""];
    user.telefone = [user.telefone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    user.telefone = [user.telefone substringFromIndex: [user.telefone length] - 8];
    //user.telefone = [user.telefone substringWithRange:NSMakeRange(user.telefone.length-8,user.telefone.length)];
    
    return [_telefone isEqual:user.telefone];
}


@end
