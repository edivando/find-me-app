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


@interface UserInfo : JSONModel

@property (nonatomic) NSInteger idServer;
@property (nonatomic) NSString *connectionId;
@property (nonatomic) NSString *user;
@property (nonatomic) NSString <Optional> *email;
@property (nonatomic) NSString *telefone;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) GMSMarker<Optional> *marker;

- (instancetype)initWithUser:(NSString*)user
                    latitude:(float)latitude
                   longitude:(float)longitude
                       email:(NSString*)email
                    telefone:(NSString*)telefone
                          idServer:(NSInteger)idServer
                connectionId:(NSString*)connectionId;





@end
