//
//  Category+CoreDataProperties.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Category+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) double weight;
@property (nullable, nonatomic, retain) Course *course;

@end

NS_ASSUME_NONNULL_END
