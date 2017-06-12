//
//  APSAppDataController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/21/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSAppDataController.h"
#import "APSCourseController.h"

@interface APSAppDataController ()

@property (strong) APSCourseController *internalCourseController;

@end

@implementation APSAppDataController
@synthesize internalCourseController;

+(instancetype)shared
{
    static APSAppDataController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        APSCourseController *courseController = [[APSCourseController alloc] init];
        [shared setInternalCourseController:courseController];
    });
    return shared;
}

-(APSCourseController *)courseController{
    return internalCourseController;
}

@end
