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

@interface APSEditScoreTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) Course *selectedCourse;
@property (nonatomic, strong) Score *scoreToBeEdited;
@property (nonatomic, strong) APSScoreController *scoreController;

@property (nonatomic, strong) UITableViewCell *nameCell;
@property (nonatomic, strong) UITableViewCell *scoreCell;
@property (nonatomic, strong) UITableViewCell *categoryCell;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *pointsEarnedField;
@property (nonatomic, strong) UILabel *dividerLabel;
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
@synthesize dividerLabel;
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
    [self buildNameCell];
    [self buildPointsCell];
    [self buildPickerCell];
    
}

-(void)buildNameCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UITextField *textField = [UITextField new];
    [textField setPlaceholder:@"Title"];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    //    [nameField setBorderStyle:UITextBorderStyleRoundedRect];
    //    [nameField.layer setBorderWidth:1.0];
    //    [nameField.layer setBorderColor:[UIColor grayColor].CGColor];
    //    [nameField.layer setCornerRadius:5.0];
    [textField setAdjustsFontSizeToFitWidth:true];
    textField.translatesAutoresizingMaskIntoConstraints = false;
    
    [cell.contentView addSubview:textField];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [cell.contentView addConstraints:@[top, leading, trailing, bottom]];
    
    [self setNameCell:cell];
    [self setNameTextField: textField];
}

-(void)buildPointsCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UITextField *pointsEarned = [UITextField new];
    [pointsEarned setPlaceholder:@"Points Earned"];
    [pointsEarned setBorderStyle:UITextBorderStyleRoundedRect];
    [pointsEarned.layer setBorderWidth:1.0];
    [pointsEarned.layer setBorderColor:[UIColor grayColor].CGColor];
    [pointsEarned.layer setCornerRadius:5.0];
    [pointsEarned setKeyboardType:UIKeyboardTypeDecimalPad];
    
    UILabel *label = [UILabel new];
    [label setText:@"/"];
    [label setFont:[UIFont boldSystemFontOfSize:24]];
    
    UITextField *pointsPossible = [UITextField new];
    [pointsPossible setPlaceholder:@"Points Possible"];
    [pointsPossible.layer setBorderWidth:1.0];
    [pointsPossible.layer setBorderColor:[UIColor grayColor].CGColor];
    [pointsPossible.layer setCornerRadius:5.0];
    [pointsPossible setKeyboardType:UIKeyboardTypeDecimalPad];
    
    // Divider
    [cell.contentView addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterXWithinMargins multiplier:1.0 constant:0];
    NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0];
    [cell.contentView addConstraints:@[labelCenterX, labelCenterY]];
    
    // Points earned
    [cell.contentView addSubview:pointsEarned];
    pointsEarned.translatesAutoresizingMaskIntoConstraints = false;
    [pointsEarned setFrame:CGRectMake(0, 0, 60, 30)];
    
    NSLayoutConstraint *peCenterY = [NSLayoutConstraint constraintWithItem:pointsEarned attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0];
    NSLayoutConstraint *peTrailing = [NSLayoutConstraint constraintWithItem:pointsEarned attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8];
    [cell.contentView addConstraints:@[peCenterY, peTrailing]];
    
    //Points Possible
    [cell.contentView addSubview:pointsPossible];
    pointsPossible.translatesAutoresizingMaskIntoConstraints = false;
    [pointsPossible setFrame:CGRectMake(0, 0, 60, 30)];
    
    NSLayoutConstraint *ppCenterY = [NSLayoutConstraint constraintWithItem:pointsPossible attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0];
    NSLayoutConstraint *ppLeading = [NSLayoutConstraint constraintWithItem:pointsPossible attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8];
    [cell.contentView addConstraints:@[ppCenterY, ppLeading]];
    
    
    [self setScoreCell:cell];
    [self setPointsEarnedField:pointsEarned];
    [self setDividerLabel:label];
    [self setPointsPossibleField:pointsPossible];
    
}

-(void)buildPickerCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UIPickerView *picker = [[UIPickerView alloc] init];
    [picker setDelegate:self];
    
    [cell.contentView addSubview:picker];
    
    picker.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:picker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [cell.contentView addConstraints:@[top, leading, trailing, bottom]];
    
    [self setCategoryPicker:picker];
    [self setCategoryCell:cell];
}

#pragma mark UIPickerView Delegate and data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"TEst";
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
            return self.scoreCell;
        }
    } else {
        return self.categoryCell;
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
