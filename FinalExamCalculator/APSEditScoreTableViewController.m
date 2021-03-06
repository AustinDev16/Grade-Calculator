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
#import "APSCoreDataStack.h"
#import "APSPersistenceController.h"
#import "APSAppearanceController.h"

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

#pragma mark View and Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
    [self.navigationItem setRightBarButtonItem:save];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nameTextField becomeFirstResponder];
}

-(void)saveButtonTapped
{
    [self.nameTextField resignFirstResponder];
    [self.pointsEarnedField resignFirstResponder];
    [self.pointsPossibleField resignFirstResponder];

    // Verify
    if (self.nameTextField.text.length == 0 || self.pointsPossibleField.text.length == 0 || self.pointsEarnedField.text.length == 0 ){
        // display error
        return;
    }
    
    double pointsEarned = [self.pointsEarnedField.text doubleValue];
    double pointsPossible = [self.pointsPossibleField.text doubleValue];
    Category *selectedCategory = [[self.scoreController categoriesWithFinal:false] objectAtIndex:[self.categoryPicker selectedRowInComponent:0]];
    if (!pointsEarned || !pointsPossible || !selectedCategory){
        // display error
        return;
    }
    
    if (!scoreToBeEdited){
        NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
        Score *newScore = [[Score alloc] initWithContext:moc];
        [newScore setName:self.nameTextField.text];
        [newScore setPointsEarned:pointsEarned];
        [newScore setPointsPossible:pointsPossible];
        [newScore setCategory:selectedCategory];
        [newScore setDate:[NSDate new]];
        
        [self.scoreController addScore:newScore];
        
    } else {
        [scoreToBeEdited setName:self.nameTextField.text];
        [scoreToBeEdited setPointsEarned:pointsEarned];
        [scoreToBeEdited setPointsPossible:pointsPossible];
        [scoreToBeEdited setCategory:selectedCategory];
        [APSPersistenceController saveToPersistedStore];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreUpdated" object:nil];
}

-(void)cancelButtonTapped
{
    [self.nameTextField resignFirstResponder];
    [self.pointsEarnedField resignFirstResponder];
    [self.pointsPossibleField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)updateWithScore:(Score *)score
{
    [self setScoreToBeEdited:score];
    [self updateTitle];
    [nameTextField setText:scoreToBeEdited.name];
    [pointsEarnedField setText:[NSString stringWithFormat:@"%.1f", scoreToBeEdited.pointsEarned]];
    [pointsPossibleField setText:[NSString stringWithFormat:@"%.1f", scoreToBeEdited.pointsPossible]];
    
    NSInteger categoryIndex = [[self.scoreController categoriesWithFinal:false] indexOfObject:scoreToBeEdited.category];
    
    if (categoryIndex) {
        [self.categoryPicker selectRow:categoryIndex inComponent:0 animated:false];
    }
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
    [pointsEarned.layer setBorderWidth:1.7];
    [pointsEarned.layer setBorderColor:[APSAppearanceController.shared blueColor].CGColor];
    [pointsEarned.layer setCornerRadius:5.0];
    [pointsEarned setKeyboardType:UIKeyboardTypeDecimalPad];
    [pointsEarned setTextAlignment:NSTextAlignmentCenter];
    
    // Toolbar
    UIToolbar *toolbarEarned = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"Back to Title" style:UIBarButtonItemStylePlain target:self action:@selector(titleButtonTapped)];
    UIBarButtonItem *spacerEarned = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Points Possible" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonTapped)];
    
    [toolbarEarned setItems:@[titleButton, spacerEarned, nextButton]];
    [pointsEarned setInputAccessoryView:toolbarEarned];
    
    UILabel *label = [UILabel new];
    [label setText:@"/"];
    [label setFont:[UIFont boldSystemFontOfSize:28]];
    
    UITextField *pointsPossible = [UITextField new];
    [pointsPossible setPlaceholder:@"Points Possible"];
    [pointsPossible.layer setBorderWidth:1.7];
    [pointsPossible.layer setBorderColor:[APSAppearanceController.shared blueColor].CGColor];
    [pointsPossible.layer setCornerRadius:5.0];
    [pointsPossible setKeyboardType:UIKeyboardTypeDecimalPad];
    [pointsPossible setTextAlignment:NSTextAlignmentCenter];
    
    //Toolbar
    UIToolbar *toolbarPossible = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    UIBarButtonItem *titleButtonPossible = [[UIBarButtonItem alloc] initWithTitle:@"Back to Title" style:UIBarButtonItemStylePlain target:self action:@selector(titleButtonTapped)];
    UIBarButtonItem *spacerPossible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Points Earned" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonTapped)];
    
    [toolbarPossible setItems:@[titleButtonPossible, spacerPossible, previousButton]];
    [pointsPossible setInputAccessoryView:toolbarPossible];
    
    // Divider
    [cell.contentView addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *labelCenterX = [NSLayoutConstraint
                                        constraintWithItem:label attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:cell.contentView
                                        attribute:NSLayoutAttributeCenterXWithinMargins
                                        multiplier:1.0
                                        constant:0];
    NSLayoutConstraint *labelCenterY = [NSLayoutConstraint
                                        constraintWithItem:label
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:cell.contentView
                                        attribute:NSLayoutAttributeCenterYWithinMargins
                                        multiplier:1.0
                                        constant:0];
    [cell.contentView addConstraints:@[labelCenterX, labelCenterY]];
    
    // Points earned
    [cell.contentView addSubview:pointsEarned];
    pointsEarned.translatesAutoresizingMaskIntoConstraints = false;
    [pointsEarned setFrame:CGRectMake(0, 0, 40, 60)];
    
    NSLayoutConstraint *peCenterY = [NSLayoutConstraint constraintWithItem:pointsEarned attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0];
    NSLayoutConstraint *peTrailing = [NSLayoutConstraint constraintWithItem:pointsEarned attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8];
    [cell.contentView addConstraints:@[peCenterY, peTrailing]];
    
    //Points Possible
    [cell.contentView addSubview:pointsPossible];
    pointsPossible.translatesAutoresizingMaskIntoConstraints = false;
    
    
    NSLayoutConstraint *ppCenterY = [NSLayoutConstraint constraintWithItem:pointsPossible attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0];
    NSLayoutConstraint *ppLeading = [NSLayoutConstraint constraintWithItem:pointsPossible attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8];
    NSLayoutConstraint *ppHeight = [NSLayoutConstraint
                                    constraintWithItem:pointsPossible
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:pointsEarned
                                    attribute:NSLayoutAttributeHeight
                                    multiplier:1.0
                                    constant:0];
    [cell.contentView addConstraints:@[ppCenterY, ppLeading, ppHeight]];
    //[pointsPossible setFrame:CGRectMake(0, 0, 60, 30)];
    
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

-(void)titleButtonTapped
{
    [nameTextField becomeFirstResponder];
}

-(void)nextButtonTapped
{
    [pointsEarnedField resignFirstResponder];
    [pointsPossibleField becomeFirstResponder];
}

-(void)previousButtonTapped
{
    [pointsPossibleField resignFirstResponder];
    [pointsEarnedField becomeFirstResponder];
}

#pragma mark UIPickerView Delegate and data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.scoreController categoriesWithFinal:false].count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Category *category = [[self.scoreController categoriesWithFinal:false] objectAtIndex:row];
    
    return category.name;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"Name and Score";
    } else {
        return @"Category";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            return 40; // Title
        } else {
            return 50; // Scores
        }
    } else {
        return 80; // Category picker
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 40;
    } else {
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

@end
