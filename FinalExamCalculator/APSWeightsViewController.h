//
//  APSWeightsViewController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/1/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Course;

@interface APSWeightsViewController : UIViewController

-(void)updateWithCourse:(Course *)course;

@end
