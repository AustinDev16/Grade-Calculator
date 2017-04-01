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
@property (nonatomic, strong) UITextField *addNewCategoryField;
@property (nonatomic, strong) UIButton *addNewCategoryButton;

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation APSWeightsViewController

@synthesize course;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self configureViews];
}

-(void)setupNavigationBar
{
    [self setTitle:@"Categories"];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    
    [self.navigationItem setRightBarButtonItem:done];
}

-(void)updateWithCourse:(Course *)selectedCourse
{
    [self setCourse:selectedCourse];
}

-(void)doneButtonTapped
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)configureViews
{
    [self configureAddCategory];
}

-(void)configureAddCategory
{
    UITextField *textField = [UITextField new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Text field
    [textField setPlaceholder:@"New category"];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
//    [textField.layer setCornerRadius:5];
//    [textField.layer setBorderColor:[UIColor grayColor].CGColor];
//    [textField.layer setBorderWidth:1];
    
    
    [button setTintColor:[UIColor blueColor]];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    
    textField.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:textField];
    
    NSLayoutConstraint *tfLeading = [NSLayoutConstraint
                                     constraintWithItem:textField
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0
                                     constant:8];
    NSLayoutConstraint *tfTop = [NSLayoutConstraint
                                 constraintWithItem:textField
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.topLayoutGuide
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0
                                 constant:8];
    NSLayoutConstraint *tfHeight = [NSLayoutConstraint
                                    constraintWithItem:textField
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeHeight
                                    multiplier:0.0
                                    constant:40];
    NSLayoutConstraint *tfWidth = [NSLayoutConstraint
                                   constraintWithItem:textField
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeWidth
                                   multiplier:0.8
                                   constant:0];
    [self.view addConstraints:@[tfLeading, tfTop, tfWidth, tfHeight]];
    
    button.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:button];
    
    NSLayoutConstraint *bLeading = [NSLayoutConstraint
                                    constraintWithItem:button
                                    attribute:NSLayoutAttributeLeading
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:textField
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:4];
    NSLayoutConstraint *bTrailing = [NSLayoutConstraint
                                     constraintWithItem:button
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0
                                     constant:-8];
    NSLayoutConstraint *bCenterY = [NSLayoutConstraint
                                    constraintWithItem:button
                                    attribute:NSLayoutAttributeCenterY
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:textField
                                    attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                    constant:0];
    [self.view addConstraints:@[bLeading, bTrailing, bCenterY]];
    
    [self setAddNewCategoryField:textField];
    [self setAddNewCategoryButton:button];
}

@end
