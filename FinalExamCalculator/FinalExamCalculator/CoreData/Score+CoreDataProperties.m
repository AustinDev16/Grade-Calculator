//
//  Score+CoreDataProperties.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/22/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Score+CoreDataProperties.h"

@implementation Score (CoreDataProperties)

+ (NSFetchRequest<Score *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Score"];
}

@dynamic date;
@dynamic name;
@dynamic pointsEarned;
@dynamic pointsPossible;
@dynamic course;
@dynamic category;

@end
