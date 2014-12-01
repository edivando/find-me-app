//
//  StatusInfoMessage.h
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusInfo.h"
#import <JSONModel.h>

@interface StatusInfoMessage : JSONModel

@property (nonatomic) StatusInfo *statusInfo;

-(instancetype) initWithStatus:(StatusInfo*)statusInfo;

@end
