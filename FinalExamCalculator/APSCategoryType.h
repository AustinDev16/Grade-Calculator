//
//  APSCategoryType.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/24/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APSCategoryType : NSObject

+(int16_t)numberFromTypeString:(NSString *)type;
+(NSString *)stringFromNumber:(int16_t)number;

@end
