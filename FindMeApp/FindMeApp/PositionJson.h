//
//  PositionJson.h
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface PositionJson : JSONModel

@property (nonatomic) NSString *user;
@property (nonatomic) NSString <Optional> *email;
@property (nonatomic) NSString *telefone;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

- (instancetype)initWithUser:(NSString*)user
                    latitude:(float)latitude
                   longitude:(float)longitude
                       email:(NSString*)email
                    telefone:(NSString*)telefone;

@end
