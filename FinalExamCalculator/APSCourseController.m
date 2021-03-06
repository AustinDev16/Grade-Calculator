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
#import "Category+CoreDataClass.h"
#import "APSCategoryType.h"


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
    return [internalCourses copy];
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
-(Course *)addNewCourseWithName:(NSString *)name
{
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    Course *newCourse = [[Course alloc] initWithContext:moc];
    [newCourse setName:name];
    
    
    Category *final = [[Category alloc] initWithContext:moc];
    [final setName:@"Final Exam"];
    [final setWeight:0.10];
    [self addCategory:final toCourse:newCourse];
    [final setType:[APSCategoryType numberFromTypeString:@"Final"]];
    
    [APSPersistenceController saveToPersistedStore];
    return newCourse;
}

-(void)deleteCourse:(Course *)course
{
    
    NSManagedObjectContext *moc = [course managedObjectContext];
    [moc deleteObject:course];
    [APSPersistenceController saveToPersistedStore];
    
}

-(Course *)findCourseWithName:(NSString *)name
{
    //NSString *lowerCased = [name lowercaseString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains [c] %@", name];
    NSArray *results = [[self courses] filteredArrayUsingPredicate:predicate];
    
    return [results firstObject];
    
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
