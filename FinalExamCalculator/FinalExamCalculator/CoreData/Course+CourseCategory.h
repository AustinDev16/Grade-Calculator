//
//  Course+CourseCategory.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/5/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Course+CoreDataClass.h"

@interface Course (CourseCategory)

-(BOOL)categoryWeightsValid;

-(NSArray<NSNumber *> *)resetWeightsArray;

@end
