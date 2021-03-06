//
//  APSScoreController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/22/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSScoreController.h"
#import "Course+CoreDataProperties.h"
#import "APSPersistenceController.h"
#import "Score+CoreDataProperties.h"
#import "Category+CoreDataClass.h"
#import "APSCategoryType.h"

@interface APSScoreController ()

@property (nonatomic, strong) Course *innerCourse;
@property (nonatomic, strong) NSArray<Category *> *nonFinalCategories;
@property (nonatomic, strong) Category *finalCategory;


@end

@implementation APSScoreController

@synthesize nonFinalCategories;
@synthesize finalCategory;


-(instancetype)initWithCourse:(Course *)course
{
    self = [super init];
    if (self){
        _innerCourse = course;
        [self extractCategories];
    }
    return self;
}

-(Course *)course{
    return _innerCourse;
}

-(void)extractCategories
{
    NSArray<Category *> *array = [self.course.categories array];
    NSMutableArray<Category *> *other = [NSMutableArray new];
    
    for (int i = 0; i< [array count]; i++) {
        Category *cat = [array objectAtIndex:i];
        if ([cat type] == [APSCategoryType numberFromTypeString:@"Final"]){
            [self setFinalCategory:[array objectAtIndex:i]];
        } else {
            [other addObject:[array objectAtIndex:i]];
        }
    }
    
    [self setNonFinalCategories:other];
}

-(NSArray<Category *> *)categoriesWithFinal:(BOOL)withFinal
{
    if (withFinal){
        return self.course.categories.array;
    } else {
        return self.nonFinalCategories;
    }
}

-(NSArray *)scoresWithType:(NSString *)type
{
    NSMutableArray *tempArray = [NSMutableArray new];
    
    
    for (Score *score in self.course.scores.array) {
        if ([[APSCategoryType stringFromNumber:score.category.type] isEqualToString:type]){
            [tempArray addObject:score];
        }
    }
    
    return tempArray;
}

-(double)averageWeightedScoreForCategory:(Category *)category
{
    NSArray *allScores = [self scoresWithType:@"Other"];
    NSMutableArray *scoresInCategory = [NSMutableArray new];
    
    double sum = 0.0;
    for (Score *score in allScores) {
        if (score.category == category){
            [scoresInCategory addObject:score];
            sum += score.pointsEarned / score.pointsPossible;
        }
    }
    
    if ([scoresInCategory count] == 0){
        return 0;
    }
    
    double average = sum / (double)[scoresInCategory count];
    NSLog(@"%@, Sum: %f, Ave: %f", category.name, sum, average);
    return category.weight * average;
}

#pragma mark Score Methods
-(void)addScore:(Score *)score
{
    [_innerCourse addScoresObject:score];
    [APSPersistenceController saveToPersistedStore];
}

-(void)deleteScore:(Score *)score
{
    NSManagedObjectContext *moc = [score managedObjectContext];
    [moc deleteObject:score];
    [APSPersistenceController saveToPersistedStore];
}

/// This function deletes the scores and category.
-(void)deleteScoresAndCategory:(Category *)category
{
    NSManagedObjectContext *moc = [category managedObjectContext];
    for (Score *score in category.scores) {
        [moc deleteObject:score];
    }
    
    [moc deleteObject:category];
    
    [APSPersistenceController saveToPersistedStore];
}

/// This function reassigns scores to a new category and then deletes the old category.
-(void)reassignScoresFromCategory:(Category *)oldCategory toNewCategory:(Category *)newCategory
{
    NSArray *scoresToReassign = [oldCategory.scores array];
    for (Score *score in scoresToReassign){
        [score setCategory:newCategory];
    }
    
    NSManagedObjectContext *moc = [oldCategory managedObjectContext];
    [moc deleteObject:oldCategory];
    [APSPersistenceController saveToPersistedStore];
    
}

#pragma mark Calculations

-(double)currentScore
{
    double sum = 0.0;
    for (Category *category in self.nonFinalCategories) {
        sum += [self averageWeightedScoreForCategory:category];
    }
    double totalWeight = [self weightOfNonFinalCategories];
    return sum/totalWeight;
}

-(double)weightOfNonFinalCategories
{
    double sum = 0.0;
    for (Category *cat in self.nonFinalCategories){
        if ([cat.scores count] != 0){
            sum += cat.weight;
        }
    }
    return sum;
}

-(double)predictedFinalScoreForFinalGrade:(double)finalGrade
{
    double sum = 0.0;
    for (Category *category in self.nonFinalCategories) {
        
//        NSArray *scores = [self scoresWithType:@"Other"];
//        if (scores == nil || scores.count == 0){
//            continue;
//        }
        
        sum += [self averageWeightedScoreForCategory:category];
        
    }
    NSLog(@"Sum: %f", sum);
    double denominator = self.finalCategory.weight * sum;
    if (denominator == 0 || denominator == NAN || self.finalCategory.weight == 0) { return 0; }
    
    return finalGrade/self.finalCategory.weight - sum/self.finalCategory.weight;
}



@end
