//
//  APSWeightsViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/1/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSWeightsViewController.h"
#import "Course+CoreDataClass.h"
#import "APSCategoryStepperTableViewCell.h"
#import "Category+CoreDataClass.h"
#import "Course+CourseCategory.h"
#import "APSPersistenceController.h"
#import "APSAppDataController.h"
#import "APSCourseController.h"
#import "APSCoreDataStack.h"
#import "APSScoreController.h"
#import "APSReassignScoresViewController.h"
#import "APSCategoryType.h"
#import "APSAppearanceController.h"


#pragma mark HALFSIZEPresentation Controller
@interface HalfSizePresentationController : UIPresentationController

@end

@implementation HalfSizePresentationController

-(CGRect)frameOfPresentedViewInContainerView
{
    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIView *rootView = [root view];
    CGFloat y = CGRectGetMidY(rootView.frame);
    return CGRectMake(0, y, self.containerView.bounds.size.width, self.containerView.bounds.size.height/2.0);
}

@end

#pragma mark APSWeightsViewController
@interface APSWeightsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) UITextField *addNewCategoryField;
@property (nonatomic, strong) UIButton *addNewCategoryButton;
@property (nonatomic, strong) UILabel *toolBarLabel;
@property (nonatomic, strong) UIViewController *scoreReassignmentViewController;


@property (nonatomic, strong) UITableView *tableView;


@end

@implementation APSWeightsViewController

@synthesize course;
@synthesize tableView;
@synthesize toolBarLabel;
@synthesize scoreReassignmentViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self configureViews];
    [self setupToolBar];
    [self textFieldChangedValue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weightsUpdated) name:@"CategoryWeightUpdated" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCategoryFromNotification:) name:@"ReassignDeleteRowComplete" object:nil];
    
    UIViewController *vc = [[UIViewController alloc] init];
    [self setScoreReassignmentViewController:vc];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self weightsUpdated];
    [self textFieldChangedValue];
    
}

-(void)setupNavigationBar
{
    [self setTitle:@"Categories"];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    
    [self.navigationItem setRightBarButtonItem:done];
}

-(void)setupToolBar
{
    [self.navigationController setToolbarHidden:false];
    
    UIBarButtonItem *resetWeights = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetWeightsTapped)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolBarLabel:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)]];
    [self.toolBarLabel setText:@""];
    [self.toolBarLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
    [self.toolBarLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *labelButton = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarLabel];
    
    [self setToolbarItems:@[resetWeights, spacer, labelButton, spacer]];
    
    [self.toolBarLabel setTextColor:[UIColor redColor]];
}


-(void)configureViews
{
    [self configureAddCategory];
    [self configureTableView];
}

-(void)configureAddCategory
{
    UITextField *textField = [UITextField new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Text field
    [textField setPlaceholder:@"New category"];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setDelegate:self];
    [textField addTarget:self action:@selector(textFieldChangedValue) forControlEvents:UIControlEventEditingChanged];
    
//    [textField.layer setCornerRadius:5];
//    [textField.layer setBorderColor:[UIColor grayColor].CGColor];
//    [textField.layer setBorderWidth:1];
    
    [button setTitleColor:[APSAppearanceController.shared blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNewCategoryTapped) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)configureTableView
{
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) style:UITableViewStylePlain];

    
    tv.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:tv];
    
    NSLayoutConstraint *tvTop = [NSLayoutConstraint
                                 constraintWithItem:tv
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:_addNewCategoryField
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0
                                 constant:8];
    NSLayoutConstraint *tvWidth = [NSLayoutConstraint
                                   constraintWithItem:tv
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeWidth
                                   multiplier:1.0
                                   constant:0];
    NSLayoutConstraint *tvBottom = [NSLayoutConstraint
                                    constraintWithItem:tv
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.bottomLayoutGuide
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                    constant:0];
    [self.view addConstraints:@[tvTop, tvWidth, tvBottom]];
    
    [tv setDelegate:self];
    [tv setDataSource:self];
    
    [tv registerClass:[APSCategoryStepperTableViewCell class] forCellReuseIdentifier:@"StepperCell"];
    
    [self setTableView:tv];
}

#pragma mark Actions and helper methods


-(void)updateWithCourse:(Course *)selectedCourse
{
    [self setCourse:selectedCourse];
}

-(void)weightsUpdated
{
    if ([self.course categoryWeightsValid]){
        [[self.navigationItem rightBarButtonItem] setEnabled:true];
        [self.toolBarLabel setText:@""];
        
    } else {
        [[self.navigationItem rightBarButtonItem] setEnabled:false];
        
        [[self toolBarLabel] setText:@"Adjust Weights"];
        [self.toolBarLabel setTextColor:[UIColor redColor]];
    }
}

-(void)doneButtonTapped
{
    if ([self.course categoryWeightsValid]){
        [APSPersistenceController saveToPersistedStore];
        [[self addNewCategoryField] resignFirstResponder];
        [self dismissViewControllerAnimated:true completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreUpdated" object:nil];
    }
}

-(void)resetWeightsTapped
{
    NSArray<NSNumber *> *weightsArray = [course resetWeightsArray];
    int j = 0;
    for (Category *category in self.course.categories) {
        [category setWeight:[[weightsArray objectAtIndex:j] doubleValue]];
        j++;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryWeightsUpdated" object:nil];
    [self weightsUpdated];
}

-(void)addNewCategoryTapped
{
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    Category *newCategory = [[Category alloc] initWithContext:moc];
    [newCategory setName:[self.addNewCategoryField text]];
    [newCategory setWeight:0.1];
    [newCategory setCourse:self.course];
    
    [[[APSAppDataController shared] courseController] addCategory:newCategory toCourse:self.course];
    
    [self.addNewCategoryField resignFirstResponder];
    [self.addNewCategoryField setText:@""];
    [self.tableView reloadData];
    [self weightsUpdated];
    [self textFieldChangedValue];
}

-(void)deleteCategoryFromNotification:(NSNotification *)notif
{
    NSDictionary *userInfo = notif.userInfo;
    
    NSNumber *rowToDelete = [userInfo valueForKey:@"IndexPathRow"];
    
    if (rowToDelete){
        [self.tableView setEditing:false animated:false];
        [self.tableView reloadData];
        [self weightsUpdated];
    } else {
        [self.tableView setEditing:false animated:true];
    }
    
}

#pragma mark TextField delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addNewCategoryField resignFirstResponder];
    return true;
}

-(void)textFieldChangedValue
{
    if (self.addNewCategoryField.text.length == 0){
        [self.addNewCategoryButton setEnabled:false];
    } else {
        [self.addNewCategoryButton setEnabled:true];
    }
}

#pragma mark UIViewTransitioningDelegate

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[HalfSizePresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}



#pragma mark Tableview Delegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.course categories] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APSCategoryStepperTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StepperCell"];
    if (!cell){
        cell = [[APSCategoryStepperTableViewCell alloc] init];
        
    }
    Category *selectedCategory = [[self.course categories] objectAtIndex:indexPath.row];
    [cell configureViews];
    [cell updateWithCategory:selectedCategory];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 > self.course.categories.count){
        return false;
    } else {
        Category *selectedCategory = [self.course.categories objectAtIndex:indexPath.row];
        return ([selectedCategory type] != [APSCategoryType numberFromTypeString:@"Final"]);
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Category *selectedCategory = [self.course.categories objectAtIndex:indexPath.row];
    
    
    // EDIT Category name
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit Name" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSString *messageString = [NSString stringWithFormat:@"Enter a new name for %@.",selectedCategory.name];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageString preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [textField setPlaceholder:selectedCategory.name];
        }];
        
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *textField = [[alertController textFields] firstObject];
            
            if (textField && textField.text.length > 0){ // if valid new name
                [selectedCategory setName:textField.text];
                [APSPersistenceController saveToPersistedStore];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryWeightsUpdated" object:nil];
                [self.tableView setEditing:false animated:true];
            } else { //Text field empty
                [self.tableView setEditing:false animated:true];
            }
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView setEditing:false animated:true];
        }];
        
        [alertController addAction:save];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:true completion:^{
            
        }];
        
        
        
    }];
    
    [edit setBackgroundColor:[APSAppearanceController.shared blueColor]];
    
    
    //DELETE category action
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        APSScoreController *scoreController = [[APSScoreController alloc] initWithCourse:self.course];
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Do you want to permanently delete the scores in this category or reassign them to a different category?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView setEditing:false animated:true];
        }];
        
        UIAlertAction *deleteScores = [UIAlertAction actionWithTitle:@"Delete Scores" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [scoreController deleteScoresAndCategory:selectedCategory];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self weightsUpdated];
        }];
        
        UIAlertAction *reassignScores = [UIAlertAction actionWithTitle:@"Reassign Scores" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            APSReassignScoresViewController *vc = [APSReassignScoresViewController new];
            
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            [nc setModalPresentationStyle:UIModalPresentationCustom];
            [nc setTransitioningDelegate:self];
            
            
            
            [self presentViewController:nc animated:true completion:nil];
            [vc updateWithCourse:self.course andCategory:selectedCategory andRow: indexPath.row];
            
        }];
        
        
        
        [alertController addAction:cancel];
        [alertController addAction:deleteScores];
        if ([self.course.categories count] <= 2){
            [alertController setMessage:@"Are you sure you want to delete all scores in this category?"];
        } else {
            [alertController addAction:reassignScores];
        }
        
        [self presentViewController:alertController animated:true completion:nil];
        
    }];
    
    if ([selectedCategory type] == [APSCategoryType numberFromTypeString:@"Final"]){
        return nil;
    } else {
        return @[delete, edit];
    }
}

@end


