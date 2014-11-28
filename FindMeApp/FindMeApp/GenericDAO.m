//
//  GenericDAO.m
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "GenericDAO.h"
#import "AppDelegate.h"

@implementation GenericDAO{
    NSString *entity;
}

- (instancetype)initEntity:(NSString*)e
{
    self = [super init];
    if (self) {
        entity = e;
    }
    return self;
}

-(NSManagedObjectContext*) context{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectContext];
}

-(NSError*) save:(NSDictionary*)dictionary{
    NSError *error;
    NSManagedObject *managed = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:[self context]];
    [managed setValuesForKeysWithDictionary:dictionary];
    [[self context] save:&error];
    return error;
}




@end
