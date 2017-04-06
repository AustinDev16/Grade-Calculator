//
//  Course+CourseCategory.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/5/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Course+CourseCategory.h"
#import "Category+CoreDataClass.h"
#import "Course+CoreDataClass.h"
#import <Accelerate/Accelerate.h>

@implementation Course (CourseCategory)

-(BOOL)categoryWeightsValid
{
    double sum = 0;
    for (Category *category in self.categories) {
        sum += category.weight;
    }
    
    return (sum == 1.0);
}

-(NSArray<NSNumber *> *)resetWeightsArray
{
    if ([self.categories count] == 1){
        return @[@0.99];
    }
    
    int roundedPartition = 100/[self.categories count];
    NSLog(@"%i", roundedPartition);
    
    // Add rounded number to
    double input[self.categories.count] __attribute__ ((aligned));
    
    for (int j = 0; j<self.categories.count; j++) {
        input[j] = (double) roundedPartition;
    }
    
    double sum = 0;

    // Sum the array.
    vDSP_sveD(input, 1, &sum, self.categories.count);
    
    NSLog(@"%f", sum);
    if ((int)sum != 100){
        // FIND difference
        int residual = (100 - sum) + roundedPartition;
        input[self.categories.count - 1] = (double) residual;
    }
    
    double factor = 100;
    // Divide array by a factor.
    vDSP_vsdivD(input, 1, &factor, input, 1, self.categories.count);
    for (int j = 0; j< self.categories.count; j++){
        NSLog(@"%f", input[j]);
    }
    
    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:self.categories.count];
    
    for (int j = 0; j < self.categories.count; j++) {
        [output addObject:[NSNumber numberWithDouble:input[j]]];
    }
   
    return output;
}

@end
