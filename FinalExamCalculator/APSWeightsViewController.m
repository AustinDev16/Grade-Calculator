//
//  APSWeightsViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/1/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSWeightsViewController.h"
#import "Course+CoreDataClass.h"

@interface APSWeightsViewController ()

@property (nonatomic, strong) Course *course;

@end

@implementation APSWeightsViewController

@synthesize course;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
}

-(void)setupNavigationBar
{
    [self setTitle:@"Categories"];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    
    [self.navigationItem setRightBarButtonItem:done];
}

-(void)updateWithCourse:(Course *)course
{
    
}

-(void)doneButtonTapped
{
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
