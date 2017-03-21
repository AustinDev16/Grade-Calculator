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

@interface APSClassesTableViewController ()

@property (strong) APSCourseController *courseController;
@end

@implementation APSClassesTableViewController
@synthesize courseController;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setCourseController:[[APSAppDataController shared] courseController]];
    [self setUpNavigationBar];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"courseCell"];
}

-(void)setUpNavigationBar
{
    [self setTitle:@"Classes"];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCourseTapped)];
    [[self navigationItem] setRightBarButtonItem:add];
    
    
}

-(void)addNewCourseTapped
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Course" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [textField setPlaceholder:@"Course name"];
    }];
    
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = [[alertController textFields] firstObject];
        NSString *newCourseName = textField.text;
        
        if (newCourseName == nil || [newCourseName length] == 0) {
            
        } else {
            
            [[self courseController] addNewCourseWithName:newCourseName];
            
            [[self tableView] reloadData];
            
            
            
            
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
