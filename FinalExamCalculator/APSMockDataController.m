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
#import "Score+CoreDataProperties.h"
#import "APSScoreController.h"
#import "APSCategoryType.h"

@implementation APSMockDataController

+(void)createMockDataCourse
{
    
    // Courses
    [[[APSAppDataController shared] courseController] addNewCourseWithName:@"Math - SAMPLE COURSE"];
    //[[[APSAppDataController shared] courseController] addNewCourseWithName:@"English"];
    
    
    
    
}

+(void)createMockDataCategories {
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    // Categories
    Category *homework1 = [[Category alloc] initWithContext:moc];
    [homework1 setName:@"Homework"];
    [homework1 setWeight:0.7];
    [homework1 setType:[APSCategoryType numberFromTypeString:@"Other"]];
    
    Category *quizzes = [[Category alloc] initWithContext:moc];
    [quizzes setName:@"Quizzes"];
    [quizzes setWeight:0.2];
    [quizzes setType:[APSCategoryType numberFromTypeString:@"Other"]];
    
    //Add Categories to courses
    Course *algebra = [[[APSAppDataController shared] courseController] findCourseWithName:@"Math - SAMPLE COURSE"];
    [[[APSAppDataController shared] courseController] addCategory:homework1 toCourse:algebra];
    [[[APSAppDataController shared] courseController] addCategory:quizzes toCourse:algebra];
    
    
    // Add scores
    Score *score1 = [[Score alloc] initWithContext:moc];
    [score1 setName:@"Assignment 1"];
    [score1 setPointsPossible:10.0];
    [score1 setPointsEarned:8.3];
    [score1 setDate:[NSDate new]];
    [score1 setCategory:homework1];
    
    Score *score2 = [[Score alloc] initWithContext:moc];
    [score2 setName:@"Assignment 2"];
    [score2 setPointsPossible:80];
    [score2 setPointsEarned:67];
    [score2 setDate:[NSDate new]];
    [score2 setCategory:homework1];
    
    Score *score3 =  [[Score alloc] initWithContext:moc];
    [score3 setName:@"Quiz 1"];
    [score3 setPointsPossible:10];
    [score3 setPointsEarned:9.5];
    [score3 setDate:[NSDate new]];
    [score3 setCategory:quizzes];
    
    APSScoreController *sc1 = [[APSScoreController alloc] initWithCourse:algebra];
    [sc1 addScore:score1];
    [sc1 addScore:score2];
    [sc1 addScore:score3];
}

@end
