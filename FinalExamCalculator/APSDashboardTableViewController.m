//
//  APSDashboardTableViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/21/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSDashboardTableViewController.h"
#import "Course+CoreDataProperties.h"
#import "APSCalculatedFinalTableViewCell.h"
#import "APSScoresTableViewController.h"
#import "APSScoreController.h"
#import "APSEditScoreTableViewController.h"
#import "APSWeightsViewController.h"
#import "UITableViewCell+APSCustomColorDisclosure.h"
#import "APSAppearanceController.h"

@interface APSDashboardTableViewController () <UIToolbarDelegate>
@property (nonatomic, strong) Course *selectedCourse;
@property (nonatomic, strong) UITableViewCell *currentScoreCell;
@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation APSDashboardTableViewController

@synthesize selectedCourse;
@synthesize currentScoreCell;
@synthesize toolBar;

-(void)updateViewWithSelectedCourse:(Course *)course
{
    [self setSelectedCourse:course];
    [self setupNavigationBar];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = NO;

    [self buildCurrentScoreCell];
    [self setupToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentScore) name:@"ScoreUpdated" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:true animated:false];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self adjustWeightsTapped];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupNavigationBar
{
    [self setTitle:self.selectedCourse.name];
}

-(void)setupToolBar
{
    UIToolbar *newToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *adjustCats = [[UIBarButtonItem alloc] initWithTitle:@"Adjust Weights" style:UIBarButtonItemStylePlain target:self action:@selector(adjustWeightsTapped)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *newScore = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addScoreTapped)];
    
  [newToolBar setItems:@[adjustCats, spacer, newScore]];
    [newToolBar setDelegate:self];
    
    CGRect toolBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - (44 + 64), [[UIScreen mainScreen] bounds].size.width, 44);
    [newToolBar setFrame:toolBarFrame];
    [newToolBar setBarStyle:UIBarStyleDefault];
    [self.view addSubview:newToolBar];
    
    [self setToolBar:newToolBar];
}

-(void)buildCurrentScoreCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = @"Current score:";
    cell.detailTextLabel.text = @"-- %";
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    [self setCurrentScoreCell:cell];
}

-(void)updateCurrentScore
{
    APSScoreController *controller = [[APSScoreController alloc] initWithCourse:self.selectedCourse];
    double score = [controller currentScore]*100.0;
    NSString *label = [NSString stringWithFormat:@"%.1f %@", score, @"%"];
    
    [self.currentScoreCell.detailTextLabel setText:label];
    
}

# pragma mark Toolbar items
-(void)addScoreTapped
{
    APSEditScoreTableViewController *tvc = [[APSEditScoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [tvc setCourse:selectedCourse];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [nc setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:nc animated:true completion:nil];
}

-(void)adjustWeightsTapped
{
    APSWeightsViewController *wvc = [[APSWeightsViewController alloc] init];
    [wvc updateWithCourse:self.selectedCourse];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wvc];
    [nc setModalPresentationStyle:UIModalPresentationPopover];
    
    [self presentViewController:nc animated:true completion:nil];
}

#pragma mark ToolBar Delegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionBottom;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        if (!self.currentScoreCell){
            [self buildCurrentScoreCell];
        }
        [self updateCurrentScore];
        return self.currentScoreCell;
        
    } else if (indexPath.section == 1) {
        APSCalculatedFinalTableViewCell *cell = [[APSCalculatedFinalTableViewCell alloc] init];
        [cell configureViews];
        [cell updateWithCourse:self.selectedCourse];
        return cell;
        
    } else if (indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"courseCell"];
        cell.textLabel.text = @"Scores";
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
        
    } else {
        return [UITableViewCell new];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2){
        [cell prepareDisclosureIndicatorWithTint:[APSAppearanceController.shared blueColor]];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        return 200;
    } else {
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2){
        
        APSScoresTableViewController *tvc = [[APSScoresTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [tvc setCourse:[self selectedCourse]];
        
        UIBarButtonItem *backButton = [UIBarButtonItem new];
        [backButton setTitle:@"Dashboard"];
        
        
        [[self navigationItem] setBackBarButtonItem:backButton];

        [[self navigationController] pushViewController:tvc animated:true];
        
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0){
        return @"Current score doesn't include the final exam.";
    } else if (section == 1){
        return @"This projection assumes a zero score for any categories with no scores.";
    } else {
        return nil;
    }
}

@end
