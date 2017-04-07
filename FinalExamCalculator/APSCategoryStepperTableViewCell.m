//
//  APSCategoryStepperTableViewCell.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/3/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSCategoryStepperTableViewCell.h"
#import "Category+CoreDataClass.h"


@interface APSCategoryStepperTableViewCell ()

@property (nonatomic, strong) Category *category;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UILabel *categoryNameLabel;
@property (nonatomic, strong) UILabel *categoryWeightLabel;

@end

@implementation APSCategoryStepperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateWithCategory:(Category *)category
{
    [self setCategory:category];
    
    [self.categoryNameLabel setText:[NSString stringWithFormat:@"%@", self.category.name]];
    [self.stepper setValue:self.category.weight];
    [self.categoryWeightLabel setText:[NSString stringWithFormat:@"%.0f %@", self.category.weight * 100.0, @"%"]];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)prepareViewElements
{
    [self setCategoryNameLabel:[UILabel new]];
    [self setCategoryWeightLabel:[UILabel new]];
    [self setStepper:[UIStepper new]];
    [self setStackView:[UIStackView new]];
     
}

-(void)configureViews
{
    if (self.stackView && self.stepper && self.categoryNameLabel && self.categoryWeightLabel){
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryWeightReset) name:@"CategoryWeightsUpdated" object:nil];

    // Initialize all view elements
    // Stack View
    [self prepareViewElements];
    [self.contentView addSubview:_stackView];
    _stackView.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView setAxis:UILayoutConstraintAxisHorizontal];
    [_stackView setDistribution:UIStackViewDistributionFill];
    [_stackView setSpacing:8];
    [_stackView setAlignment:UIStackViewAlignmentCenter];
    
    NSLayoutConstraint *svLeading = [NSLayoutConstraint
                                     constraintWithItem:_stackView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeLeadingMargin
                                     multiplier:1.0
                                     constant:0];
    NSLayoutConstraint *svTop = [NSLayoutConstraint
                                 constraintWithItem:_stackView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *svTrailing = [NSLayoutConstraint
                                      constraintWithItem:_stackView
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeTrailingMargin
                                      multiplier:1.0
                                      constant:0];
    NSLayoutConstraint *svBottom = [NSLayoutConstraint
                                    constraintWithItem:_stackView
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                    constant:0];
    [self.contentView addConstraints:@[svLeading, svTop, svTrailing, svBottom]];
    
    // Category label
        self.categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView addArrangedSubview:_categoryNameLabel];
    
    // Weight Label
    
    self.categoryWeightLabel.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView addArrangedSubview:_categoryWeightLabel];
    // Stepper
    
    [self.stepper setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.stepper setMaximumValue:0.99];
    [self.stepper setMinimumValue:0.01];
    [self.stepper setStepValue:0.01];
    [self.stepper addTarget:self action:@selector(stepperUpdated) forControlEvents:UIControlEventValueChanged];
    [_stackView addArrangedSubview:_stepper];
    
    
    
}

-(void)stepperUpdated
{
    double value = [self.stepper value];
    [self.categoryWeightLabel setText:[NSString stringWithFormat:@"%.0f %@", value * 100.0, @"%"]];
    
    [self.category setWeight:value];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryWeightUpdated" object:nil];

}

-(void)categoryWeightReset
{
    [self.categoryWeightLabel setText:[NSString stringWithFormat:@"%.0f %@", self.category.weight * 100.0, @"%"]];
    [self.stepper setValue:self.category.weight];
}

@end
