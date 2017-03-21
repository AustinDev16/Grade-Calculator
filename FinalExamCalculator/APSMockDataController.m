//
//  APSMockDataController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/21/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSMockDataController.h"
#import "APSCourseController.h"
#import "Course+CoreDataProperties.h"
#import "Category+CoreDataProperties.h"
#import "APSAppDataController.h"
#import "APSCoreDataStack.h"

@implementation APSMockDataController

+(void)createMockDataCourse
{
    
    // Courses
    [[[APSAppDataController shared] courseController] addNewCourseWithName:@"Algebra"];
    [[[APSAppDataController shared] courseController] addNewCourseWithName:@"English"];
    
    
    
    
}

+(void)createMockDataCategories {
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    // Categories
    Category *homework1 = [[Category alloc] initWithContext:moc];
    [homework1 setName:@"Homework"];
    [homework1 setWeight:0.5];
    
    Category *exams1 = [[Category alloc] initWithContext:moc];
    [exams1 setName:@"Exams"];
    [exams1 setWeight:0.5];
    
    Category *homework2 = [[Category alloc] initWithContext:moc];
    [homework2 setName:@"Homework"];
    [homework2 setWeight:0.5];
    
    Category *exams2 = [[Category alloc] initWithContext:moc];
    [exams2 setName:@"Exams"];
    [exams2 setWeight:0.5];
    
    //Add Categories to courses
    Course *algebra = [[[APSAppDataController shared] courseController] findCourseWithName:@"Algebra"];
    [[[APSAppDataController shared] courseController] addCategory:homework1 toCourse:algebra];
    [[[APSAppDataController shared] courseController] addCategory:exams1 toCourse:algebra];
    
    
    Course *english = [[[APSAppDataController shared] courseController]  findCourseWithName:@"English"];
    [[[APSAppDataController shared] courseController] addCategory:homework2 toCourse:english];
    [[[APSAppDataController shared] courseController] addCategory:exams2 toCourse:english];
    

}

@end