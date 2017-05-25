//
//  APSOnboardingPageViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 5/2/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSOnboardingPageViewController.h"
#import "APSOnboardingCustomViewController.h"
#import "APSAppearanceController.h"
#import "APSWelcomeScreenViewController.h"

@interface APSOnboardingPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray<UIViewController *> *viewControllerArray;
@property (nonatomic, strong) UIButton *bottomButton;


@end

@implementation APSOnboardingPageViewController

@synthesize viewControllerArray;
@synthesize bottomButton;

-(void)configurePageController
{
    [self fillViewControllerArray];
        [self setViewControllers:@[[self.viewControllerArray firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    [self setDelegate:self];
    [self setDataSource:self];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor lightGrayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [[APSAppearanceController shared] blueColor]];
    [[UIPageControl appearance] setTintColor: [UIColor blackColor]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self addBottomButton];

}

-(void)fillViewControllerArray
{
    APSWelcomeScreenViewController *welcome = [[APSWelcomeScreenViewController alloc] init];
    
    APSOnboardingCustomViewController *classes = [[APSOnboardingCustomViewController alloc] init];
    [classes updateWithText:@"Manage all the courses you're taking. Add, edit, delete, or tap a course for more detail." andImage:[UIImage imageNamed:@"Classes"]];
    
    APSOnboardingCustomViewController *addNewCourse = [[APSOnboardingCustomViewController alloc] init];
    [addNewCourse updateWithText:@"Adding a new course is simple: just tap the + button and give it a name." andImage:[UIImage imageNamed:@"AddNewCourse"]];
    
    APSOnboardingCustomViewController *addAScore = [[APSOnboardingCustomViewController alloc] init];
    [addAScore updateWithText:@"Now, enter your scores for that class. Do it all at once, or as the semester progresses." andImage:[UIImage imageNamed:@"AddAScore"]];
    
    APSOnboardingCustomViewController *dashboardView = [[APSOnboardingCustomViewController alloc] init];
    [dashboardView updateWithText:@"Finally, select your desired grade to see how well you'll have to do on your final to get it." andImage:[UIImage imageNamed:@"DashboardView"]];
    
    APSOnboardingCustomViewController *scoresSummary = [[APSOnboardingCustomViewController alloc] init];
    [scoresSummary updateWithText:@"Your scores are saved on your iPhone, so you can see all your assignments, anytime." andImage:[UIImage imageNamed:@"ScoresSummary"]];
    
    APSOnboardingCustomViewController *setCategories = [[APSOnboardingCustomViewController alloc] init];
    [setCategories updateWithText:@"Next, add categories and set their weights. Make sure the weights add up to 100%." andImage:[UIImage imageNamed:@"SetCategories"]];


    NSArray *array = [NSArray arrayWithObjects:welcome, classes, addNewCourse, setCategories, addAScore, scoresSummary, dashboardView, nil];
    [self setViewControllerArray:array];
}

-(void) addBottomButton
{
    if (!self.bottomButton) {
        [self setBottomButton:[UIButton buttonWithType:UIButtonTypeRoundedRect]];
    }
    
    [self.bottomButton setTitle:@"Skip Intro" forState:UIControlStateNormal];
    [self.bottomButton setTintColor:[UIColor redColor]];
    
    [self.view addSubview:bottomButton];
    [bottomButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    NSLayoutConstraint *trailingBB = [NSLayoutConstraint
                                    constraintWithItem:bottomButton
                                    attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0 constant:-8];
    NSLayoutConstraint *bottomBB = [NSLayoutConstraint
                                    constraintWithItem:bottomButton
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1.0 constant:-4];
    NSLayoutConstraint *heightBB = [NSLayoutConstraint
                                    constraintWithItem:bottomButton
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeHeight
                                    multiplier:0 constant:30];
    NSLayoutConstraint *widthBB = [NSLayoutConstraint
                                   constraintWithItem:bottomButton
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeWidth
                                   multiplier:0.0 constant:80];
    [self.view addConstraints:@[trailingBB, bottomBB, heightBB, widthBB]];
    
    [bottomButton addTarget:self action:@selector(skipButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

-(void)skipButtonTapped
{
    NSLog(@"skip tapped");
    
    [UIView animateWithDuration:2.0 animations:^{
        [self.view setBackgroundColor:[UIColor blackColor]];
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OnboardingFinished" object:nil];
    }];
    
    
}

-(void)updateButtonTextFromNotification:(NSNotification *)notif
{
    [bottomButton setEnabled:false];
}

#pragma mark Delegate

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.viewControllerArray count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    APSOnboardingCustomViewController *vc = [[pageViewController viewControllers] firstObject];
    return [self.viewControllerArray indexOfObject:vc];
}
#pragma mark Data source

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    if (index != 0){
        return [self.viewControllerArray objectAtIndex:index - 1];
    } else {
        return nil;
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    if (index != [self.viewControllerArray count] - 1){
        return [self.viewControllerArray objectAtIndex:index + 1];
    } else {
        return nil;
    }
}


@end
