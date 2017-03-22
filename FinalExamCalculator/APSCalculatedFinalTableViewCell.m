//
//  APSCalculatedFinalTableViewCell.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/21/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSCalculatedFinalTableViewCell.h"
@interface APSCalculatedFinalTableViewCell ()

@property (nonatomic, strong) UILabel *finalScoreLabel;
@property (nonatomic, strong) UILabel *scoreHeader;
@property (nonatomic, strong) UILabel *scoreFooter;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *pickerLabel;

@end

@implementation APSCalculatedFinalTableViewCell

@synthesize finalScoreLabel;
@synthesize scoreHeader;
@synthesize scoreFooter;
@synthesize pickerView;
@synthesize pickerLabel;



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configureViews
{
    UIStackView *outerView = [UIStackView new];
    [[self contentView] addSubview:outerView];
    
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
    
    
    UIStackView *rightView = [UIStackView new];
    
    [outerView addArrangedSubview:leftView];
    [outerView addArrangedSubview:rightView];
    
    
    // Add labels to left View
    [self setScoreHeader:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)]];
    [[self scoreHeader] setText:@"You need at a least a:"];
    [[self scoreHeader] setTextAlignment:NSTextAlignmentCenter];
    [leftView addArrangedSubview:scoreHeader];
    
    
    [self setFinalScoreLabel:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)]];
    [[self finalScoreLabel] setText:@"--- %"];
    [[self finalScoreLabel] setFont:[UIFont boldSystemFontOfSize:24]];
    [[self finalScoreLabel] setTextAlignment:NSTextAlignmentCenter];
    [leftView addArrangedSubview:finalScoreLabel];
    
    
}



@end
