//
//  PositionJson.h
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionJson : NSObject

@property (strong, nonatomic) NSString *user;
@property float latitude;
@property float longitude;

- (instancetype)initWithUser:(NSString*)user
                    latitude:(float)latitude
                   longitude:(float)longitude;

-(NSDictionary*) dictionary;

@end
