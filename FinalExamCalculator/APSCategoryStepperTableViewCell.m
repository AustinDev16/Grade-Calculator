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
    [self prepareViewElements];
    [self configureViews];
    
    
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
    // Initialize all view elements
    // Stack View
    [self.contentView addSubview:_stackView];
    _stackView.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView setAxis:UILayoutConstraintAxisHorizontal];
    [_stackView setDistribution:UIStackViewDistributionFill];
    [_stackView setSpacing:8];
    
    NSLayoutConstraint *svLeading = [NSLayoutConstraint
                                     constraintWithItem:_stackView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeLeading
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
                                      attribute:NSLayoutAttributeTrailing
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
    [self.categoryNameLabel setText:[NSString stringWithFormat:@"%@", self.category.name]];
    self.categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView addArrangedSubview:_categoryNameLabel];
    
    // Weight Label
    [self.categoryWeightLabel setText:[NSString stringWithFormat:@"%.0f %@", self.category.weight * 100.0, @"%"]];
    self.categoryWeightLabel.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView addArrangedSubview:_categoryWeightLabel];
    // Stepper
    
    [self.stepper setTranslatesAutoresizingMaskIntoConstraints:false];
    [_stackView addArrangedSubview:_stepper];
    
    
    
}

@end
