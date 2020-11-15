//
//  Score+ScoreCategory.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/23/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "Score+ScoreCategory.h"
#import "Score+CoreDataClass.h"

@implementation Score (ScoreCategory)

-(NSString *)stringLabel
{
    NSString *label = [NSString stringWithFormat:@"%.1f/%.1f",self.pointsEarned, self.pointsPossible];
    if (label)
        return label;
    else
        return @"No score.";
}



@end
