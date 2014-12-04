//
//  UserInfoDAO.m
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "UserInfoDAO.h"


@implementation UserInfoDAO{
    GenericDAO *dao;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dao = [[GenericDAO alloc] initEntity:@"Usuario"];
    }
    return self;
}

-(NSError*)save:(UserInfo*)user{
    NSDictionary *dict;
    if ([[self fetchWithKey:@"defaultuser" andValue:@"YES"] count] == 0) {
        dict = @{@"nome": user.user,
                 @"telefone" : user.telefone,
                 @"email" : user.email,
                 @"connectionId" : user.connectionId,
                 @"latitude" : @(user.latitude),
                 @"longitude" : @(user.longitude),
                 @"defaultuser" : @"YES"};
    } else {
        dict = @{@"nome": user.user,
                 @"telefone" : user.telefone,
                 @"email" : user.email,
                 @"connectionId" : user.connectionId,
                 @"latitude" : @(user.latitude),
                 @"longitude" : @(user.longitude),
                 @"defaultuser" : @"NO"};
    }
    return [dao save:dict];
}

-(NSError*)update:(NSManagedObject*)managed{
    return [dao update:managed];
}

-(NSError*)updateUserInfo:(UserInfo*)u{
    return [dao updateDictionary:@{@"nome": u.user,
                         @"telefone" : u.telefone,
                         @"email" : u.email,
                         @"connectionId" : u.connectionId,
                         @"latitude" : @(u.latitude),
                         @"longitude" : @(u.longitude),
                         @"defaultuser" : @"NO"}
            ];
}


-(void) clearAllExceptDefault{
    NSArray *nonDefault = [self fetchWithKey:@"defaultuser" andValue:@"NO"];
    for (NSManagedObject *m in nonDefault) {
        [dao delete:m];
    }
}

-(void) deleteManaged:(NSManagedObject*)m{
    [dao delete:m];
}

-(NSArray*) fetchWithKey:(NSString*)chave andValue:(NSString*)valor{
    NSPredicate *pred = [[NSPredicate alloc] init];
    if ([chave isEqual:@"nome"])
        pred = [NSPredicate predicateWithFormat:@"(nome = %@)",valor];
    else if ([chave isEqual:@"defaultuser"])
        pred = [NSPredicate predicateWithFormat:@"(defaultuser = %@)",valor];
    else if ([chave isEqual:@"telefone"])
        pred = [NSPredicate predicateWithFormat:@"(telefone = %@)",valor];
    else if ([chave isEqual:@"email"])
        pred = [NSPredicate predicateWithFormat:@"(email = %@)",valor];
    else if ([chave isEqual:@"connectionId"])
        pred = [NSPredicate predicateWithFormat:@"(connectionId = %@)",valor];
    return [dao fetch:pred];
}

-(NSMutableArray*) convertToUsersInfo:(NSArray*) manageds{
    NSMutableArray *users = [NSMutableArray new];
    for (NSManagedObject *m in manageds) {
        [users addObject:[self convertToUserInfo:m]];
    }
    return users;
}

-(UserInfo*)convertToUserInfo:(NSManagedObject*)m{
    UserInfo *user = [[UserInfo alloc] initWithUser:[m valueForKey:@"nome"]
                                           latitude:[[m valueForKey:@"latitude"] floatValue]
                                          longitude:[[m valueForKey:@"longitude"] floatValue]
                                              email:[m valueForKey:@"email"]
                                           telefone:[m valueForKey:@"telefone"]
                                           deviceId:[m valueForKey:@"deviceId"]
                                       connectionId:[m valueForKey:@"connectionId"]];
    return user;
}

@end
