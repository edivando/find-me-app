//
//  PermissionInfoMessage.h
//  FindMeApp
//
//  Created by Yuri Anfrisio Reis on 12/3/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "PermissionInfo.h"

@interface PermissionInfoMessage : JSONModel

@property (nonatomic) PermissionInfo *permissionInfo;

-(instancetype) initWithPermission:(PermissionInfo*) permissionInfo;

@end
