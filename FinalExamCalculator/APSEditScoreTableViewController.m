//
//  APSEditScoreTableViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/28/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSEditScoreTableViewController.h"
#import "Course+CoreDataClass.h"
#import "Score+CoreDataClass.h"
#import "APSScoreController.h"

@interface APSEditScoreTableViewController ()
@property (nonatomic, strong) Course *selectedCourse;
@property (nonatomic, strong) Score *scoreToBeEdited;
@property (nonatomic, strong) APSScoreController *scoreController;

@property (nonatomic, strong) UITableViewCell *nameCell;
@property (nonatomic, strong) UITableViewCell *scoreCell;
@property (nonatomic, strong) UITableViewCell *categoryCell;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *pointsEarnedField;
@property (nonatomic, strong) UITextField *pointsPossibleField;
@property (nonatomic, strong) UIPickerView *categoryPicker;
@end

@implementation APSEditScoreTableViewController

@synthesize selectedCourse;
@synthesize scoreToBeEdited;
@synthesize scoreController;
@synthesize nameCell;
@synthesize scoreCell;
@synthesize categoryCell;
@synthesize nameTextField;
@synthesize pointsEarnedField;
@synthesize pointsPossibleField;
@synthesize categoryPicker;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    [self.navigationItem setLeftBarButtonItem:cancel];
}

-(void)cancelButtonTapped
{
    [self dismissViewControllerAnimated:self completion:nil];
}

-(void)setCourse:(Course *)course
{
    [self setSelectedCourse:course];
    APSScoreController *controller = [[APSScoreController alloc] initWithCourse:course];
    [self setScoreController:controller];
    [self updateTitle];
    [self buildCells];
}

-(void)updateTitle
{
    if (!scoreToBeEdited) {
        [self setTitle:[NSString stringWithFormat:@"%@: %@",selectedCourse.name, @"New Score"]];
    } else {
        [self setTitle:[NSString stringWithFormat:@"%@: %@",selectedCourse.name, scoreToBeEdited.name]];
    }
}

-(void)setScoreToBeEdited:(Score *)score
{
    [self setScoreToBeEdited:score];
    [self updateTitle];
}

#pragma mark Build cells
-(void)buildCells
{
  // Build section one
    UITableViewCell *name = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UITextField *nameField = [UITextField new];
    [nameField setPlaceholder:@"Title"];
    [nameField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
//    [nameField setBorderStyle:UITextBorderStyleRoundedRect];
//    [nameField.layer setBorderWidth:1.0];
//    [nameField.layer setBorderColor:[UIColor grayColor].CGColor];
//    [nameField.layer setCornerRadius:5.0];
    [nameField setAdjustsFontSizeToFitWidth:true];
    nameField.translatesAutoresizingMaskIntoConstraints = false;
    
    [name.contentView addSubview:nameField];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:nameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:name.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:nameField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:name.contentView attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:nameField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:name.contentView attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:nameField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:name.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [name.contentView addConstraints:@[top, leading, trailing, bottom]];
    
    [self setNameCell:name];
    [self setNameTextField: nameField];
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 2; // name and score
    } else {
        return 1; // category
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            return self.nameCell;
        } else {
            return [UITableViewCell new];
        }
    } else {
        return [UITableViewCell new];
    }
    
    // Configure the cell...

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"Name and Score";
    } else {
        return @"Category";
    }
}

@end
