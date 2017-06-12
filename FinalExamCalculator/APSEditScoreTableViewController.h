//
//  APSEditScoreTableViewController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/28/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Course;
@class Score;

@interface APSEditScoreTableViewController : UITableViewController

-(void)setCourse:(Course *)course;
-(void)updateWithScore:(Score *)score;

@end
