//
//  APSReassignScoresViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/10/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSReassignScoresViewController.h"
#import "Course+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "APSCategoryType.h"
#import "APSScoreController.h"

@interface APSReassignScoresViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) Category *categoryToDelete;
@property (nonatomic, strong) NSArray<Category *> *otherCategories;
@property  NSInteger *selectedRow;

@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation APSReassignScoresViewController
@synthesize course;
@synthesize categoryToDelete;
@synthesize pickerView;
@synthesize otherCategories;
@synthesize selectedRow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViews];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    UIBarButtonItem *reassign = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector(moveScoresTapped)];
    
    [self.navigationItem setLeftBarButtonItem:cancel];
    [self.navigationItem setRightBarButtonItem:reassign];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

-(void)updateWithCourse:(Course *)selectedCourse andCategory:(Category *)category andRow:(NSInteger)row
{
    [self setCourse:selectedCourse];
    [self setCategoryToDelete:category];
    NSMutableArray *allCategories = [NSMutableArray new];
    for (Category *cat in self.course.categories) {
        if (cat.type != [APSCategoryType numberFromTypeString:@"Final"])
        {
            if (cat != categoryToDelete)
            {
                [allCategories addObject:cat];
            }
        }
    }
    
    [self setOtherCategories:[NSArray arrayWithArray:allCategories]];
    [self setTitle:@"Pick a category:"];
    [self setSelectedRow:&row];
}

-(void)configureViews
{
    [self setPickerView:[UIPickerView new]];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    pickerView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:pickerView];
    
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:pickerView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.topLayoutGuide
                               attribute:NSLayoutAttributeBottom
                               multiplier:1.0
                               constant:4];
    NSLayoutConstraint *width = [NSLayoutConstraint
                                 constraintWithItem:pickerView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:pickerView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                  constant:0.0];
    [self.view addConstraints:@[top, width, bottom]];
}

#pragma mark Picker methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.otherCategories count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Category *category = [self.otherCategories objectAtIndex:row];
    return category.name;
}

-(void)cancelButtonTapped
{
    [self dismissViewControllerAnimated:true completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReassignDeleteRowComplete" object:nil];
    }];
}

-(void)moveScoresTapped
{
    APSScoreController *scoreController = [[APSScoreController alloc] initWithCourse:self.course];
    
    Category *categorySelectedForReassignment = [self.otherCategories objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    
    [scoreController reassignScoresFromCategory:categoryToDelete toNewCategory:categorySelectedForReassignment];
    
    
    [self dismissViewControllerAnimated:true completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReassignDeleteRowComplete" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:*(self.selectedRow)] forKey:@"IndexPathRow"]];
    }];
}

@end
