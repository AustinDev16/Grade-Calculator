//
//  APSOnboardingPageViewController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 5/2/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSOnboardingPageViewController.h"
#import "APSOnboardingCustomViewController.h"

@interface APSOnboardingPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray<UIViewController *> *viewControllerArray;

@end

@implementation APSOnboardingPageViewController

@synthesize viewControllerArray;

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


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillViewControllerArray
{
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


    NSArray *array = [NSArray arrayWithObjects:classes, addNewCourse, setCategories, addAScore, scoresSummary, dashboardView, nil];
    [self setViewControllerArray:array];
}
#pragma mark Delegate


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

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.viewControllerArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 1;
}



@end
