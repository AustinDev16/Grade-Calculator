//
//  APSCalculatedFinalTableViewCell.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/21/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSCalculatedFinalTableViewCell.h"
#import "APSScoreController.h"

@interface APSCalculatedFinalTableViewCell ()

@property (nonatomic, strong) UILabel *finalScoreLabel;
@property (nonatomic, strong) UILabel *scoreHeader;
@property (nonatomic, strong) UILabel *scoreFooter;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *pickerLabel;
@property (nonatomic, strong) NSArray *gradeArray;
@property (nonatomic, strong) APSScoreController *scoreController;

@end

@implementation APSCalculatedFinalTableViewCell

@synthesize finalScoreLabel;
@synthesize scoreHeader;
@synthesize scoreFooter;
@synthesize pickerView;
@synthesize pickerLabel;
@synthesize gradeArray;
@synthesize scoreController;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

}

-(void)updateScore
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSNumber *selectedScore = [self.gradeArray objectAtIndex:row];
    [self updateFinalScoreForDesiredScore:[selectedScore doubleValue]/100.0];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)configureViews
{
    // Set up notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore) name:@"ScoreUpdated" object:nil];
    // Initialize array of numbers
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 50; i<101; i++) {
//        [array addObject:[NSNumber numberWithInteger:i]];
        [array insertObject:[NSNumber numberWithInteger:i] atIndex:0];
    }
    
    [self setGradeArray:array];
    
    
    
    UIStackView *outerView = [UIStackView new];
    [[self contentView] addSubview:outerView];
    [outerView setDistribution:UIStackViewDistributionFillProportionally];
    
    // OuterStack View
    [outerView setAxis:UILayoutConstraintAxisHorizontal];
    [outerView setSpacing:0.0];
    outerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *ovLeading = [NSLayoutConstraint
                                     constraintWithItem:outerView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0
                                     constant:8];
    NSLayoutConstraint *ovTop = [NSLayoutConstraint
                                 constraintWithItem:outerView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *ovTrailing = [NSLayoutConstraint
                                      constraintWithItem:outerView
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0
                                      constant:0];
    NSLayoutConstraint *ovBottom = [NSLayoutConstraint
                                    constraintWithItem:outerView
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                    constant:0];
    [self.contentView addConstraints:@[ovLeading, ovTop, ovTrailing, ovBottom]];
    
    // Left and Right Stack Views
    UIStackView *leftView = [UIStackView new];
    [leftView setAxis:UILayoutConstraintAxisVertical];
    [leftView setSpacing:8];
    [leftView setDistribution:UIStackViewDistributionFillProportionally];
    
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *lvWidth = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeWidth multiplier:0.66 constant:0];
    
    
    
    UIStackView *rightView = [UIStackView new];
    [rightView setAxis:UILayoutConstraintAxisVertical];
    [rightView setSpacing:0];
    [rightView setDistribution:UIStackViewDistributionFillProportionally];
    [rightView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [outerView addArrangedSubview:leftView];
    [outerView addArrangedSubview:rightView];
    [outerView addConstraint:lvWidth];
    
    
    // Add labels to left View
    [self setScoreHeader:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)]];
    [[self scoreHeader] setText:@"You need at a least a:"];
    [[self scoreHeader] setTextAlignment:NSTextAlignmentCenter];
    [leftView addArrangedSubview:scoreHeader];
    
    
    [self setFinalScoreLabel:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)]];
    [[self finalScoreLabel] setText:@"--- %"];
    [[self finalScoreLabel] setFont:[UIFont boldSystemFontOfSize:24]];
    [[self finalScoreLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self finalScoreLabel] setTextColor:[UIColor redColor]];
    [leftView addArrangedSubview:finalScoreLabel];
    
    [self setScoreFooter:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)]];
    [[self scoreFooter] setText:@"on your final."];
    [[self scoreFooter] setTextAlignment:NSTextAlignmentCenter];
    [leftView addArrangedSubview:scoreFooter];
    
    
    // Add label and picker to right view
    UILabel *spacerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 8)];
    [spacerLabel setText:@"Spacer"];
    [spacerLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [spacerLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    spacerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [rightView addArrangedSubview:spacerLabel];
    
    
    [self setPickerLabel:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)]];
    self.pickerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[self pickerLabel] setText:@"Desired Grade:"];
    [[self pickerLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self pickerLabel] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.pickerLabel.adjustsFontSizeToFitWidth = true;
    
    [rightView addArrangedSubview:pickerLabel];
    
    [self setPickerView:[UIPickerView new]];
    [[self pickerView] setFrame:CGRectMake(0, 0, 70, 50)];
    [[self pickerView] setDelegate:self];
    [[self pickerView] setDataSource:self];
    [rightView addArrangedSubview:pickerView];
    [[self pickerView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
    
}

-(void)updateWithCourse:(Course *)course
{
    APSScoreController *controller = [[APSScoreController alloc] initWithCourse:course];
    
    [self setScoreController:controller];
}

-(void)updateFinalScoreForDesiredScore:(double)score
{
    double neededScore = [self.scoreController predictedFinalScoreForFinalGrade:score];
    // Evaluate if score is reasonable
    NSString *updatedLabel = [NSString stringWithFormat:@"%.1f %@",neededScore*100.0, @"%"];
    
    [self.finalScoreLabel setText:updatedLabel];
    
    
    
}

#pragma mark PickerView Methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.gradeArray count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [NSString stringWithFormat:@"%@", [self.gradeArray objectAtIndex:row]];
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSNumber *selectedScore = [self.gradeArray objectAtIndex:row];
    
    [self updateFinalScoreForDesiredScore:[selectedScore doubleValue]/100.0];
}



@end
