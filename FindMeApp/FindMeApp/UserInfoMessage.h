//
//  UserInfoMessage.h
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import <JSONModel.h>

@interface UserInfoMessage : JSONModel

@property (nonatomic) UserInfo *userInfo;

-(instancetype) initWithUser:(UserInfo*) userInfo;

@end
