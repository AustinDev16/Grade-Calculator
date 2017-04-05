//
//  APSCategoryStepperTableViewCell.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/3/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Category;

@interface APSCategoryStepperTableViewCell : UITableViewCell

-(void)updateWithCategory:(Category *)category;

@end
