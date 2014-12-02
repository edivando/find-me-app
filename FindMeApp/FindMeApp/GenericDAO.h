//
//  GenericDAO.h
//  FindMeApp
//
//  Created by bepid on 28/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenericDAO : NSObject

@property (readonly,nonatomic) NSString *entity;

- (instancetype)initEntity:(NSString*)e;

-(NSError*) save:(NSDictionary*)dictionary;

-(NSError*) update:(NSManagedObject*)managed;

-(NSArray*) fetch:(NSPredicate*)predicate;

-(NSError*) updateDictionary:(NSDictionary*)dictionary;

@end
