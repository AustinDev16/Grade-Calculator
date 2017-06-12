//
//  Course+CoreDataClass.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Score;

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Course+CoreDataProperties.h"
