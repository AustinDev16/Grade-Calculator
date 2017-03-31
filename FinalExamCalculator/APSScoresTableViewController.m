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

@interface APSScoresTableViewController () <NSFetchedResultsControllerDelegate, UIToolbarDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation APSScoresTableViewController

@synthesize fetchedResultsController;
@synthesize toolBar;



- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleString = [NSString stringWithFormat:@"%@ - Scores", self.course.name];
    [self setTitle: titleString];

    [self setupToolBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEditing:false animated:true];
    [self.tableView reloadData];
}

-(void)initializeFetchedResultsController
{
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    NSFetchRequest *request = [Score fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:true];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.course.name == %@", _course.name ];
    [request setSortDescriptors:@[sort]];
    [request setPredicate:predicate];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"category.name" cacheName:nil];
    
    [self setFetchedResultsController:controller];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    [[self fetchedResultsController] performFetch:&error];
    
    if (error){
        NSLog(@"Error fetching: %@", error.localizedDescription);
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
}

-(void)setCourse:(Course *)course
{
    _course = course;
    
    [self initializeFetchedResultsController];
    
}


-(void)setupToolBar
{

    UIBarButtonItem *adjustCats = [[UIBarButtonItem alloc] initWithTitle:@"Adjust Weights" style:UIBarButtonItemStylePlain target:self action:@selector(adjustWeightsTapped)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *newScore = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addScoreTapped)];
    
    self.navigationController.toolbarHidden = false;
    [self setToolbarItems:@[adjustCats, spacer, newScore]];
}

-(void)adjustWeightsTapped
{
    
}

-(void)addScoreTapped
{
    APSEditScoreTableViewController *tvc = [[APSEditScoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [tvc setCourse:_course];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [nc setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:nc animated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ScoreCell"];
    }

    Score *score = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = score.name;
    [cell.detailTextLabel setText:[score stringLabel]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        Score *selectedScore = [self.fetchedResultsController objectAtIndexPath:indexPath];
        APSEditScoreTableViewController *tvc = [[APSEditScoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [tvc setCourse:self.course];
        [tvc updateWithScore:selectedScore];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
        
        [self presentViewController:nc animated:true completion:nil];
        
    }];
    
    //[edit setBackgroundColor:[UIColor blueColor]];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        Score *scoreToBeDeleted = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
        [moc deleteObject:scoreToBeDeleted];
        [APSPersistenceController saveToPersistedStore];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreUpdated" object:nil];
    }];
    
    return @[delete, edit];
}


@end
