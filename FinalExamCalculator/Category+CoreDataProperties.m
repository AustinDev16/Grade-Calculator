//
//  Category+CoreDataProperties.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/22/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Category+CoreDataProperties.h"

@implementation Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Category"];
}

@dynamic name;
@dynamic weight;
@dynamic course;
@dynamic scores;
@dynamic type;

@end
