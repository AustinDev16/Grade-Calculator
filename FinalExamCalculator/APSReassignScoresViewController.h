//
//  APSReassignScoresViewController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/10/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Course;
@class Category;

@interface APSReassignScoresViewController : UIViewController
-(void)updateWithCourse:(Course *)selectedCourse andCategory:(Category *)category andRow:(NSInteger)row;
@end
