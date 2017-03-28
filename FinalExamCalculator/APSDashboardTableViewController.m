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
}

-(void)setupNavigationBar
{
    [self setTitle:self.selectedCourse.name];
}

-(void)setupToolBar
{
    UIToolbar *newToolBar = [UIToolbar new];
    UIBarButtonItem *adjustCats = [[UIBarButtonItem alloc] initWithTitle:@"Adjust Weights" style:UIBarButtonItemStylePlain target:self action:@selector(adjustWeightsTapped)];
    UIBarButtonItem *newScore = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addScoreTapped)];
    
 //   [newToolBar setItems:@[adjustCats, newScore]];
    [newToolBar setDelegate:self];
    
    [self setToolBar:newToolBar];
//    [self.view addSubview:self.toolBar];
    self.navigationController.toolbarHidden = false;
    [self.navigationController setToolbarHidden:false animated:true];
    [self.navigationController.toolbar setItems:@[adjustCats, newScore]];
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
    
}

-(void)adjustWeightsTapped
{
    
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
    } else {
        return nil;
    }
}

@end
