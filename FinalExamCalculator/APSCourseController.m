//
//  APSCourseController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSCourseController.h"
#import "Course+CoreDataProperties.h"



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

-(void)addNewCourse:(Course *)course
{
    [_internalCourses addObject:course];
}

-(void)deleteCourse:(Course *)course
{
    [_internalCourses removeObject:course];
    NSManagedObjectContext *moc = [course managedObjectContext];
    [moc deleteObject:course];
    
}

-(void)addCategory:(Category *)category toCourse:(Course *)course{
    [course addCategoriesObject:category];
}

-(void)removeCategory:(Category *)category fromCourse:(Course *)course
{
    
}


@end
