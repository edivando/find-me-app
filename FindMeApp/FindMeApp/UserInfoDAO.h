//
//  UserInfoDAO.h
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericDAO.h"
#import "UserInfo.h"

@interface UserInfoDAO : NSObject

-(NSError*)save:(UserInfo*)user;

-(NSArray*) fetchWithKey:(NSString*)chave andValue:(NSString*)valor;

-(NSError*)update:(NSManagedObject*)managed;

-(NSMutableArray*) convertToUsersInfo:(NSArray*) manageds;

-(UserInfo*)convertToUserInfo:(NSManagedObject*)m;
@end
