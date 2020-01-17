//
//  APSScoresTableViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSScoresTableViewController.h"
#import "Course+CoreDataProperties.h"
#import "Category+CoreDataProperties.h"
#import "Score+CoreDataProperties.h"
#import "APSCoreDataStack.h"
#import "Score+ScoreCategory.h"
#import "APSEditScoreTableViewController.h"
#import "APSPersistenceController.h"
#import "APSWeightsViewController.h"
#import "APSAppearanceController.h"

@interface APSScoresTableViewController () <NSFetchedResultsControllerDelegate, UIToolbarDelegate>

@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation APSScoresTableViewController

@synthesize toolBar;



- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleString = [NSString stringWithFormat:@"%@ - Scores", self.course.name];
    [self setTitle: titleString];
    [self.tableView setDelegate: self];
    [self.tableView setDataSource:self];

    [self setupToolBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setEditing:false animated:true];
    [self.tableView reloadData];
}




-(void)setCourse:(Course *)course
{
    _course = course;
}


-(void)setupToolBar
{

    UIBarButtonItem *adjustCats = [[UIBarButtonItem alloc] initWithTitle:@"Categories" style:UIBarButtonItemStylePlain target:self action:@selector(adjustWeightsTapped)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *newScore = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addScoreTapped)];
    
    self.navigationController.toolbarHidden = false;
    [self setToolbarItems:@[adjustCats, spacer, newScore]];
}

-(void)adjustWeightsTapped
{
    APSWeightsViewController *wvc = [[APSWeightsViewController alloc] init];
    [wvc updateWithCourse:self.course];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wvc];
    [nc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:nc animated:true completion:nil];
    
}

-(void)addScoreTapped
{
    APSEditScoreTableViewController *tvc = [[APSEditScoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [tvc setCourse:_course];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [nc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:nc animated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 //return [[self.fetchedResultsController sections] count];
   
    return [self.course.categories count];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    Category *cat = [self.course.categories objectAtIndex:section];
    return [cat.scores count];
    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [NSString stringWithFormat:@"%@: %.0f %@",
                       [[self.course.categories objectAtIndex:section] name],
                       [self.course.categories objectAtIndex:section].weight * 100,
                       @"%"];
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ScoreCell"];
    }
    
    Category *cat = [self.course.categories objectAtIndex:indexPath.section];
    Score *score = [cat.scores objectAtIndex:indexPath.row];
    cell.textLabel.text = score.name;
    [cell.detailTextLabel setText:[score stringLabel]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Category *cat = [self.course.categories objectAtIndex:indexPath.section];
    
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        Score *selectedScore = [cat.scores objectAtIndex:indexPath.row];
        APSEditScoreTableViewController *tvc = [[APSEditScoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [tvc setCourse:self.course];
        [tvc updateWithScore:selectedScore];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
        
        [self presentViewController:nc animated:true completion:nil];
        
        
    }];
    
    [edit setBackgroundColor:[APSAppearanceController.shared blueColor]];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        Score *scoreToBeDeleted = [cat.scores objectAtIndex:indexPath.row];
        NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
        [moc deleteObject:scoreToBeDeleted];
        [APSPersistenceController saveToPersistedStore];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreUpdated" object:nil];
    }];
    
    return @[delete, edit];
}


@end
