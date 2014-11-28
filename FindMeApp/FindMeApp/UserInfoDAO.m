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
    NSDictionary *dict = @{@"nome": user.user,
                           @"telefone" : user.telefone,
                           @"email" : user.email};
    
    return [dao save:dict];
}

-(NSArray*) fetch:(NSString*)chave :(NSString*)valor{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%@ = %@)",chave ,valor];
    return [dao fetch:pred];
}

@end
