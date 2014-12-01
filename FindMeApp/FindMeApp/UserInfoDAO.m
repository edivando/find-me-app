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
    NSArray *objects = [self fetchWithKey:@"defaultuser" andValue:@"YES"];
    if ([objects count] == 0) {
        dict = @{@"nome": user.user,
                 @"telefone" : user.telefone,
                 @"email" : user.email,
                 @"defaultuser" : @"YES"};
    } else {
        dict = @{@"nome": user.user,
                 @"telefone" : user.telefone,
                 @"email" : user.email,
                 @"defaultuser" : @"NO"};
    }
    return [dao save:dict];
}

-(NSMutableArray*) fetchWithKey:(NSString*)chave andValue:(NSString*)valor{
    NSPredicate *pred = [[NSPredicate alloc] init];
    if ([chave isEqual:@"nome"])
        pred = [NSPredicate predicateWithFormat:@"(nome = %@)",valor];
    else if ([chave isEqual:@"defaultuser"])
        pred = [NSPredicate predicateWithFormat:@"(defaultuser = %@)",valor];
    else if ([chave isEqual:@"telefone"])
        pred = [NSPredicate predicateWithFormat:@"(telefone = %@)",valor];
    else if ([chave isEqual:@"email"])
        pred = [NSPredicate predicateWithFormat:@"(email = %@)",valor];
    return [self convertToUsersInfo:[dao fetch:pred]];
}


-(NSMutableArray*) convertToUsersInfo:(NSArray*) managers{
    NSMutableArray *users = [NSMutableArray new];
    for (NSManagedObject *m in managers) {
        UserInfo *user = [[UserInfo alloc] initWithUser:[m valueForKey:@"nome"]
                                                      latitude:[[m valueForKey:@"latitude"] floatValue]
                                                     longitude:[[m valueForKey:@"longitude"] floatValue]
                                                         email:[m valueForKey:@"email"]
                                                      telefone:[m valueForKey:@"telefone"]
                                                      idServer:[[m valueForKey:@"idServer"] integerValue]
                                                  connectionId:[m valueForKey:@"connectionId"]];
        [users addObject:user];
    }
    return users;
}

@end
