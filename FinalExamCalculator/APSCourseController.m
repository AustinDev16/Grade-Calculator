//
//  APSCourseController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSCourseController.h"
#import "Course+CoreDataProperties.h"
#import "APSPersistenceController.h"
#import "APSCoreDataStack.h"



@interface APSCourseController ()

@property (nonatomic, strong) NSMutableArray *internalCourses;

@end

@implementation APSCourseController

@synthesize internalCourses;

-(instancetype)init
{
    self = [super init];
    if (self){
        internalCourses = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)courses
{
    [self fetchCourses];
    return internalCourses;
}

-(void)fetchCourses
{
    NSFetchRequest *fetchRequest = [Course fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    if (!results){
        NSLog(@"Error fetching course objects");
    } else {
        [self setInternalCourses:[[NSMutableArray alloc] initWithArray:results]];
    }
 
}


#pragma mark Course
-(void)addNewCourseWithName:(NSString *)name
{
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    Course *newCourse = [[Course alloc] initWithContext:moc];
    [newCourse setName:name];
    [APSPersistenceController saveToPersistedStore];
    
}

-(void)deleteCourse:(Course *)course
{
    
    NSManagedObjectContext *moc = [course managedObjectContext];
    [moc deleteObject:course];
    [APSPersistenceController saveToPersistedStore];
    
}

#pragma mark Category
-(void)addCategory:(Category *)category toCourse:(Course *)course{
    [course addCategoriesObject:category];
    [APSPersistenceController saveToPersistedStore];
}

-(void)removeCategory:(Category *)category fromCourse:(Course *)course
{
    [course removeCategoriesObject:category];
    [APSPersistenceController saveToPersistedStore];
}


@end
