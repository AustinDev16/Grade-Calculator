//
//  Course+CoreDataProperties.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/22/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Course+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<Category *> *categories;
@property (nullable, nonatomic, retain) NSOrderedSet<Score *> *scores;

@end

@interface Course (CoreDataGeneratedAccessors)

- (void)insertObject:(Category *)value inCategoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCategoriesAtIndex:(NSUInteger)idx;
- (void)insertCategories:(NSArray<Category *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCategoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCategoriesAtIndex:(NSUInteger)idx withObject:(Category *)value;
- (void)replaceCategoriesAtIndexes:(NSIndexSet *)indexes withCategories:(NSArray<Category *> *)values;
- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSOrderedSet<Category *> *)values;
- (void)removeCategories:(NSOrderedSet<Category *> *)values;

- (void)insertObject:(Score *)value inScoresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScoresAtIndex:(NSUInteger)idx;
- (void)insertScores:(NSArray<Score *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeScoresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInScoresAtIndex:(NSUInteger)idx withObject:(Score *)value;
- (void)replaceScoresAtIndexes:(NSIndexSet *)indexes withScores:(NSArray<Score *> *)values;
- (void)addScoresObject:(Score *)value;
- (void)removeScoresObject:(Score *)value;
- (void)addScores:(NSOrderedSet<Score *> *)values;
- (void)removeScores:(NSOrderedSet<Score *> *)values;

@end

NS_ASSUME_NONNULL_END
