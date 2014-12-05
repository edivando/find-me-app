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

-(NSError*)updateUserInfo:(UserInfo*)u;

-(NSMutableArray*) convertToUsersInfo:(NSArray*) manageds;

-(UserInfo*)convertToUserInfo:(NSManagedObject*)m;

-(void) clearAllExceptDefault;

-(void) deleteManaged:(NSManagedObject*)m;

-(NSArray*) fetchWithPredicate:(NSPredicate*) predicate;
@end
