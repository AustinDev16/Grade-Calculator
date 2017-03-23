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


@interface APSScoreController ()

@property (nonatomic, strong) Course *innerCourse;

@end

@implementation APSScoreController

-(instancetype)initWithCourse:(Course *)course
{
    self = [super init];
    if (self){
        _innerCourse = course;
    }
    return self;
}

-(Course *)course{
    return _innerCourse;
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




@end
