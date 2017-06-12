//
//  APSAppDataController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/21/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class APSCourseController;

@interface APSAppDataController : NSObject

+(instancetype)shared;

-(APSCourseController *)courseController;


@end
