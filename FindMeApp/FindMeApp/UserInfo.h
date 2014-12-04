//
//  PositionJson.h
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "GoogleMaps/GoogleMaps.h"

@protocol UserInfo
@end

@interface UserInfo : JSONModel

FOUNDATION_EXTERN NSArray *const listaCores;

@property (nonatomic) NSString *deviceId;
@property (nonatomic) NSString *connectionId;
@property (nonatomic) NSString *user;
@property (nonatomic) NSString <Optional> *email;
@property (nonatomic) NSString *telefone;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString <Optional> *permission;
@property (nonatomic) NSString <Optional> *status;

//@property (nonatomic) GMSMarker<> *marker;

- (instancetype)initWithUser:(NSString*)user
                    latitude:(float)latitude
                   longitude:(float)longitude
                       email:(NSString*)email
                    telefone:(NSString*)telefone
                          deviceId:(NSString*)deviceId
                connectionId:(NSString*)connectionId;

-(GMSMarker*) marker;

-(BOOL)isEqualUser:(UserInfo*)user;


@end
