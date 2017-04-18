//
//  Category+CoreDataProperties.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/22/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Category+CoreDataClass.h"
#import "Score+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) double weight;
@property (nullable, nonatomic, retain) Course *course;
@property (nullable, nonatomic, retain) NSOrderedSet<Score *> *scores;
@property (nonatomic) int16_t type;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addScoresObject:(Score *)value;
- (void)removeScoresObject:(Score *)value;
- (void)addScores:(NSOrderedSet<Score *> *)values;
- (void)removeScores:(NSOrderedSet<Score *> *)values;


@end

NS_ASSUME_NONNULL_END
