//
//  GenericDAO.m
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "GenericDAO.h"
#import "AppDelegate.h"

@implementation GenericDAO

- (instancetype)initEntity:(NSString*)e
{
    self = [super init];
    if (self) {
        _entity = e;
    }
    return self;
}

-(NSManagedObjectContext*) context{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectContext];
}

-(NSError*) save:(NSDictionary*)dictionary{
    NSError *error;
    NSManagedObject *managed = [NSEntityDescription insertNewObjectForEntityForName:_entity inManagedObjectContext:[self context]];
    [managed setValuesForKeysWithDictionary:dictionary];
    [[self context] save:&error];
    return error;
}

-(NSError*) updateDictionary:(NSDictionary*)dictionary{
    NSError *error;
    NSEntityDescription *description = [NSEntityDescription entityForName:_entity inManagedObjectContext:[self context]];
    [description setValuesForKeysWithDictionary:dictionary];
    [[self context] save:&error];
    return error;
}

-(NSError*) update:(NSManagedObject*)managed{
    NSError *error;
    [[self context] save:&error];
    return error;
}

-(NSArray*) fetch:(NSPredicate*)predicate{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:_entity inManagedObjectContext: [self context]];
    [request setEntity:entityDesc];
    
    if(predicate != nil){
        [request setPredicate:predicate];
    }
    NSError *error;
    return [[self context] executeFetchRequest:request error:&error];
 
}

-(void) delete:(NSDictionary*)dictionary{
    NSManagedObject *managed = [NSEntityDescription insertNewObjectForEntityForName:_entity inManagedObjectContext:[self context]];
    [managed setValuesForKeysWithDictionary:dictionary];
    [[self context] deleteObject:managed];
    //**Talvez precise salvar o context depois, não sei
}




@end
