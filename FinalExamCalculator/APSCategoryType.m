//
//  APSCategoryType.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/24/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSCategoryType.h"

@implementation APSCategoryType

+(NSString *)stringFromNumber:(int16_t)number
{
    switch (number) {
        case 0:
            return @"Other";
        case 1:
            return @"Final";
        default:
            return nil;
    }
}

+(int16_t)numberFromTypeString:(NSString *)type
{
    if ([type isEqualToString:@"Other"]){
        return 0;
    } else if ([type isEqualToString:@"Final"]){
        return 1;
    } else {
        return NAN;
    }
}


@end
