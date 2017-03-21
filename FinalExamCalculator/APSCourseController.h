//
//  APSCourseController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Course;
@class Category;


@interface APSCourseController : NSObject

-(instancetype)init;
-(NSArray *)courses;

-(void)addNewCourseWithName:(NSString *)name;
-(void)deleteCourse:(Course *)course;


-(void)addCategory:(Category *)category toCourse:(Course *)course;
-(void)removeCategory:(Category *)category fromCourse:(Course *)course;

-(Course *)findCourseWithName:(NSString *)name;

@end
