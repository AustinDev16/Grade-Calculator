//
//  APSDashboardTableViewController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/21/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Course;

@interface APSDashboardTableViewController : UITableViewController

-(void)updateViewWithSelectedCourse:(Course *)course;


@end
