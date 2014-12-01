//
//  ConnectionInfoMessage.h
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionInfo.h"
#import <JSONModel.h>

@interface ConnectionInfoMessage : JSONModel

@property (nonatomic) ConnectionInfo *connectionInfo;

-(instancetype) initWithConnectionInfo:(ConnectionInfo*)connectionInfo;

@end
