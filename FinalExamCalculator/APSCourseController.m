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



@interface APSCourseController ()

@property (nonatomic, strong) NSMutableArray *internalCourses;

@end

@implementation APSCourseController

-(instancetype)init
{
    self = [super init];
    if (self){
        _internalCourses = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)courses
{
    return _internalCourses;
}

#pragma mark Course
-(void)addNewCourse:(Course *)course
{
    [_internalCourses addObject:course];
    [APSPersistenceController saveToPersistedStore];
    
}

-(void)deleteCourse:(Course *)course
{
    [_internalCourses removeObject:course];
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
