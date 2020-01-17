//
//  APSWelcomeScreenViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 5/25/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSWelcomeScreenViewController.h"
#import "APSAppearanceController.h"
#import <QuartzCore/QuartzCore.h>

@interface APSWelcomeScreenViewController ()

@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *iconContainingView;
@property BOOL hasDisplayedOnce;

@end

@implementation APSWelcomeScreenViewController
@synthesize welcomeLabel;
@synthesize descriptionLabel;
@synthesize hasDisplayedOnce;
@synthesize iconImageView;
@synthesize iconContainingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    [self setHasDisplayedOnce:false];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!hasDisplayedOnce){
        
        [UIView animateWithDuration:0.8 delay: 0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.welcomeLabel setAlpha:1.0];
            [self.iconContainingView setAlpha:1.0];
            
            
        } completion:^(BOOL finished) {
            [self animateWelcomeToDescriptionText];
        }];
        

        
    }
    
}

-(void)animateWelcomeToDescriptionText
{
    
    [UIView animateWithDuration:1.0 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect finalWelcome = CGRectMake(self.view.frame.origin.x + 8, self.view.frame.size.height/7.0, self.view.frame.size.width - 16, 60);
        
        [self.welcomeLabel setFrame:finalWelcome];
        
        
        CGFloat centerXOfView = self.view.center.x;
        
        CGRect iconImageFinalFrame = CGRectMake(centerXOfView - 40, self.view.frame.size.height - 160, 80, 80);
        
        [self.iconContainingView setFrame:iconImageFinalFrame];
    } completion:^(BOOL finished) {
        
        [self addDescription];
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.descriptionLabel setAlpha:1.0];
            
        } completion:^(BOOL finished){
            [self setHasDisplayedOnce:true];
        }];
        
    }];
}


-(void)configureView
{
    if (!welcomeLabel){
        [self setWelcomeLabel:[[UILabel alloc] init]];
    }
    
    [welcomeLabel setText:@"Welcome"];
    [welcomeLabel setTextColor:[[APSAppearanceController shared] blueColor]];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setFont:[UIFont boldSystemFontOfSize:36]];
    [welcomeLabel setAdjustsFontSizeToFitWidth:true];
    
    [self.view addSubview:welcomeLabel];
    
    
    CGRect initialFrame = CGRectMake(self.view.frame.origin.x + 8, self.view.center.y - 80, self.view.frame.size.width - 16, 60);
    [welcomeLabel setFrame:initialFrame];
    
    
    // [iconImageView setClipsToBounds:YES];
    
    [self.view addSubview:iconImageView];
    
    CGFloat centerXOfView = self.view.center.x;
    
    //self.view.frame.origin.x + 8
    
    CGRect iconImageFrame = CGRectMake(centerXOfView - 40, self.view.center.y + 10, 80, 80);
    
    UIView *containerView = [[UIView alloc] initWithFrame:iconImageFrame];
    [containerView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [containerView.layer setShadowRadius:5.0f];
    [containerView.layer setShadowOffset:CGSizeMake(3, 3)];
    [containerView.layer setShadowOpacity:0.5f];
    [self.view addSubview:containerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
    imageView.image = [UIImage imageNamed:@"WelcomeScreenIcon"];
    [imageView.layer setCornerRadius:20.0f];
    //[imageView.layer setBorderWidth:1];
    //[imageView.layer setBorderColor:[[UIColor colorWithRed:78.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1] CGColor] ];
    [imageView.layer setMasksToBounds:YES];
    [containerView addSubview:imageView];
    
    [self.view addSubview:containerView];
    
    
    [self setIconImageView:imageView];
    [self setIconContainingView:containerView];
    
    [iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    // Prime for animations
    
    [welcomeLabel setAlpha:0.0];
    [iconContainingView setAlpha:0.0];
}

-(void)addDescription
{
    if (!descriptionLabel){
        [self setDescriptionLabel:[[UILabel alloc] init]];
    }
    
    [descriptionLabel setText:@"Swipe through this introduction for a tour of some of the great features of Final Exam.\n\nOr tap 'Skip Intro' to get started right away."];
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
                                   multiplier:1.0 constant:-60];
    [self.view addConstraints:@[centerX, centerY, widthDL]];
}

@end
