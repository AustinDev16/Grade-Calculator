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

@interface APSScoresTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation APSScoresTableViewController

@synthesize fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleString = [NSString stringWithFormat:@"%@ - Scores", self.course.name];
    [self setTitle: titleString];

    
}

-(void)initializeFetchedResultsController
{
    NSManagedObjectContext *moc = [[APSCoreDataStack shared] mainQueueMOC];
    NSFetchRequest *request = [Score fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:true];
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


@end
