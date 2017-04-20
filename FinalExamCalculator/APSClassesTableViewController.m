//
//  APSClassesTableViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSClassesTableViewController.h"
#import "APSAppDataController.h"
#import "APSCourseController.h"
#import "Course+CoreDataProperties.h"
#import "APSDashboardTableViewController.h"
#import "APSWeightsViewController.h"
#import "APSPersistenceController.h"

@interface APSClassesTableViewController ()

@property (strong) APSCourseController *courseController;

@end

@implementation APSClassesTableViewController
@synthesize courseController;

-(void)CoreDataReadyNotified
{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setCourseController:[[APSAppDataController shared] courseController]];
    [self setUpNavigationBar];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"courseCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CoreDataReadyNotified) name:@"CoreDataStoreReady" object:nil];
}

-(void)setUpNavigationBar
{
    [self setTitle:@"Classes"];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCourseTapped)];
    [[self navigationItem] setRightBarButtonItem:add];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    
//   [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

-(void)addNewCourseTapped
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Course" message:@"Add weights on the next screen." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [textField setPlaceholder:@"Course name"];
    }];
    
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = [[alertController textFields] firstObject];
        NSString *newCourseName = textField.text;
        
        if (newCourseName == nil || [newCourseName length] == 0) {
            
        } else {
            
            Course *newCourse = [[self courseController] addNewCourseWithName:newCourseName];
            
            [[self tableView] reloadData];
            
            
            APSWeightsViewController *weights = [APSWeightsViewController new];
            [weights updateWithCourse:newCourse];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:weights];
            [nc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            
            [self presentViewController:nc animated:true completion:nil];
            
        }
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:add];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self courseController] courses] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell" forIndexPath:indexPath];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"courseCell"];
    }
    // Configure the cell...
    Course *selectedItem = [[[self courseController] courses] objectAtIndex:indexPath.row];
    
    
    [cell.textLabel setText:selectedItem.name];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        Course *courseToEdit = [[[self courseController] courses] objectAtIndex:indexPath.row];
        
        NSString *message = [NSString stringWithFormat:@"Choose a new name for %@", courseToEdit.name];
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField setPlaceholder:courseToEdit.name];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView setEditing:false animated:true];
        }];
        
        UIAlertAction *update = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *textField = [[alertController textFields] firstObject];
            if (textField && textField.text.length > 0){
                
                [self.tableView setEditing:false animated:true];
                [courseToEdit setName:textField.text];
                [APSPersistenceController saveToPersistedStore];
                [self.tableView reloadData];
                
            } else {
                [self.tableView setEditing:false animated:true];
            }
            
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:update];
        
        [self presentViewController:alertController animated:true completion:nil];
        
    }];
    
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Deleting this course will delete all its scores, and can not be undone." preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView setEditing:false animated:true];
        }];
        
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Class and Scores" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            Course *courseToDelete = [[[self courseController] courses] objectAtIndex:indexPath.row];
            [[self courseController] deleteCourse:courseToDelete];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:delete];
        [self presentViewController:alertController animated:true completion:nil];
        
    }];
    
    return @[delete, edit];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Course *selected = [self.courseController.courses objectAtIndex:indexPath.row];
    
    APSDashboardTableViewController *tvc = [[APSDashboardTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [tvc updateViewWithSelectedCourse:selected];
    
    [[self navigationController] pushViewController:tvc animated:YES];
    
}

@end
