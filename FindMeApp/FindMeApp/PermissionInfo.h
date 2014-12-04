//
//  PermissionInfo.h
//  FindMeApp
//
//  Created by Yuri Anfrisio Reis on 12/3/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "UserInfo.h"

@interface PermissionInfo : JSONModel

@property (nonatomic) UserInfo *from;
@property (nonatomic) UserInfo *to;
@property (nonatomic) NSString *status;

-(instancetype) initPermissionWithUserFrom:(UserInfo*)from
                                    userTo:(UserInfo*)to
                                    status:(NSString*)status;

@end
