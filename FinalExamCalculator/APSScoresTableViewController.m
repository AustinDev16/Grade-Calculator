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

@interface APSScoresTableViewController ()

@property (nonatomic, strong) NSMutableArray<Score *> *scores;

@end

@implementation APSScoresTableViewController

@synthesize scores;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleString = [NSString stringWithFormat:@"%@ - Scores", self.course.name];
    [self setTitle: titleString];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ScoreCell"];
}

-(void)setCourse:(Course *)course
{
    _course = course;
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:true];
    NSArray *sortedArray = [_course.scores sortedArrayUsingDescriptors:@[dateSort]];
    
    [self setScores:[NSMutableArray arrayWithArray:sortedArray]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.course == nil){
        return 0;
    } else {
        return self.course.categories.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray <Category *> *categories = [self.course.categories array];
    return [categories objectAtIndex:section].name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell" forIndexPath:indexPath];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ScoreCell"];
    }
    
    Score *score = [self.scores objectAtIndex:indexPath.row];
    
    cell.textLabel.text = score.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f / %f",score.pointsEarned, score.pointsPossible];
    
    // Configure the cell...
    
    return cell;
}


@end
