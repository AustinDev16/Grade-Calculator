//
//  APSScoreController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/22/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Course;
@class Score;
@class Category;

@interface APSScoreController : NSObject

-(instancetype)initWithCourse:(Course *)course;

-(void)addScore:(Score *)score;
-(void)deleteScore:(Score *)score;

-(Course *)course;

-(double)predictedFinalScoreForFinalGrade:(double)finalGrade;
-(double)currentScore;

-(NSArray<Category *> *)categoriesWithFinal:(BOOL)withFinal;

@end
