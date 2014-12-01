//
//  StatusInfo.h
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import <JSONModel.h>

@interface StatusInfo : JSONModel

@property (nonatomic) UserInfo *userInfo;
@property (nonatomic) NSString *status;

-(instancetype) initStatusWithUser:(UserInfo*)user
                            status:(NSString*)status;

@end
