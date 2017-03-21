//
//  Score+CoreDataProperties.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Score+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Score (CoreDataProperties)

+ (NSFetchRequest<Score *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) double pointsEarned;
@property (nonatomic) double pointsPossible;
@property (nullable, nonatomic, retain) Course *course;

@end

NS_ASSUME_NONNULL_END
