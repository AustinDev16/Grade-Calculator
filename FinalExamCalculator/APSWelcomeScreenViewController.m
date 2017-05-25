//
//  APSWelcomeScreenViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 5/25/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSWelcomeScreenViewController.h"

@interface APSWelcomeScreenViewController ()

@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation APSWelcomeScreenViewController
@synthesize welcomeLabel;
@synthesize descriptionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
        [UIView animateWithDuration:1.0 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGRect finalWelcome = CGRectMake(self.view.frame.origin.x + 8, self.view.frame.size.height/7.0, self.view.frame.size.width - 16, 60);
            
            [welcomeLabel setFrame:finalWelcome];
            
            
        } completion:^(BOOL finished) {

            [self addDescription];
            
            [UIView animateWithDuration:1.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                [descriptionLabel setAlpha:1.0];
                
            } completion:nil];

        }];
        
        
    
}


-(void)configureView
{
    if (!welcomeLabel){
        [self setWelcomeLabel:[[UILabel alloc] init]];
    }
    
    [welcomeLabel setText:@"Welcome to Final Exam"];
    [welcomeLabel setTextColor:[UIColor blackColor]];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setFont:[UIFont boldSystemFontOfSize:36]];
    [welcomeLabel setAdjustsFontSizeToFitWidth:true];
    
    [self.view addSubview:welcomeLabel];
    
 
    CGRect initialFrame = CGRectMake(self.view.frame.origin.x + 8, self.view.center.y - 40, self.view.frame.size.width - 16, 60);
    [welcomeLabel setFrame:initialFrame];
    
}

-(void)addDescription
{
    if (!descriptionLabel){
        [self setDescriptionLabel:[[UILabel alloc] init]];
    }
    
    [descriptionLabel setText:@"asdlfj asdkfj ajjs asjfdsj ajskfj ajskjdf jaksj ajiwjej jieji jijdkj fjie"];
    [descriptionLabel setTextColor:[UIColor blackColor]];
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setAlpha:0.0];
    
    [self.view addSubview:descriptionLabel];
    
    [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint
                                   constraintWithItem:descriptionLabel
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeCenterX
                                   multiplier:1.0 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:descriptionLabel
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.0 constant:0];
    NSLayoutConstraint *widthDL = [NSLayoutConstraint
                                   constraintWithItem:descriptionLabel
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeWidth
                                   multiplier:1.0 constant:-16];
    [self.view addConstraints:@[centerX, centerY, widthDL]];
}

@end
