//
//  APSOnboardingCustomViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 5/11/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSOnboardingCustomViewController.h"
#import "APSAppearanceController.h"

@interface APSOnboardingCustomViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) NSString *instructionText;



@end

@implementation APSOnboardingCustomViewController

@synthesize image;
@synthesize imageView;
@synthesize instructionLabel;
@synthesize instructionText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateWithText:(NSString *)text andImage:(UIImage *)imageForView
{
    //[self.instructionLabel setText:text];
    [self setInstructionText:text];
    
    [self setImage:imageForView];
    //[imageView setImage:testImage];
}

-(void)configureView
{
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    // Initialize view elements.
    [self setImageView:[[UIImageView alloc] init]];
    [self setInstructionLabel:[[UILabel alloc] init]];
    
    [instructionLabel setNumberOfLines:0];
    [instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [instructionLabel setTextColor:[[APSAppearanceController shared] blueColor]];
    [instructionLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [instructionLabel setText:self.instructionText];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit ];
    [imageView setImage:self.image];
   
    imageView.layer.masksToBounds = NO;
    imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    imageView.layer.shadowOffset = CGSizeZero;
    imageView.layer.shadowRadius = 10.0f;
    
    imageView.layer.shadowOpacity = 1.0f;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:instructionLabel];
    
    // Add constraints
    [instructionLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    
//    NSLayoutConstraint *labelTop = [NSLayoutConstraint
//                                    constraintWithItem:instructionLabel
//                                    attribute:NSLayoutAttributeTop
//                                    relatedBy:NSLayoutRelationEqual
//                                    toItem:self.view
//                                    attribute:NSLayoutAttributeTopMargin
//                                    multiplier:1.0
//                                    constant:45];
    NSLayoutConstraint *labelCenterX = [NSLayoutConstraint
                                        constraintWithItem:instructionLabel
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                        attribute:NSLayoutAttributeCenterX
                                        multiplier:1.0
                                        constant:0];
    NSLayoutConstraint *labelWidth = [NSLayoutConstraint
                                      constraintWithItem:instructionLabel
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeWidth
                                      multiplier:0.8
                                      constant:0];
    [self.view addConstraints:@[labelWidth, labelCenterX]];
    
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    NSLayoutConstraint *imageViewCenterX = [NSLayoutConstraint
                                           constraintWithItem:imageView
                                           attribute:NSLayoutAttributeCenterX
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                           attribute:NSLayoutAttributeCenterX
                                           multiplier:1.0
                                           constant:0];
    NSLayoutConstraint *imageViewWidth = [NSLayoutConstraint
                                          constraintWithItem:imageView
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeWidth
                                          multiplier:0.8
                                          constant:0];
    NSLayoutConstraint *imageViewBottom = [NSLayoutConstraint
                                        constraintWithItem:imageView
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                        constant:0];
    NSLayoutConstraint *imageViewHeight = [NSLayoutConstraint
                                           constraintWithItem:imageView
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                           attribute:NSLayoutAttributeHeight
                                           multiplier:0.75
                                           constant:0];
    [self.view addConstraints:@[imageViewCenterX, imageViewWidth, imageViewBottom, imageViewHeight]];
    
    NSLayoutConstraint *labelCenterY = [NSLayoutConstraint
                                        constraintWithItem:instructionLabel
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:imageView
                                        attribute:NSLayoutAttributeTop
                                        multiplier:0.5 constant:0];
    [self.view addConstraint:labelCenterY];
}


@end
