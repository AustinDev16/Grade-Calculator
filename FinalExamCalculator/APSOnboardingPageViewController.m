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
    [classes updateWithText:@"Get a bird's eye view of all the courses you've saved. Add, edit, and delete whole courses from here. Tap a course for more detail." andImage:[UIImage imageNamed:@"Classes"]];
    
    APSOnboardingCustomViewController *addNewCourse = [[APSOnboardingCustomViewController alloc] init];
    [addNewCourse updateWithText:@"Get a bird's eye view of all the courses you've saved. Add, edit, and delete whole courses from here. Tap a course for more detail." andImage:[UIImage imageNamed:@"AddNewCourse"]];
    
    APSOnboardingCustomViewController *addAScore = [[APSOnboardingCustomViewController alloc] init];
    [addAScore updateWithText:@"asdf" andImage:[UIImage imageNamed:@"AddAScore"]];
    
    APSOnboardingCustomViewController *dashboardView = [[APSOnboardingCustomViewController alloc] init];
    [dashboardView updateWithText:@"asdf" andImage:[UIImage imageNamed:@"DashboardView"]];
    
    APSOnboardingCustomViewController *scoresSummary = [[APSOnboardingCustomViewController alloc] init];
    [scoresSummary updateWithText:@"asdf" andImage:[UIImage imageNamed:@"ScoresSummary"]];
    
    APSOnboardingCustomViewController *setCategories = [[APSOnboardingCustomViewController alloc] init];
    [setCategories updateWithText:@"asldfj" andImage:[UIImage imageNamed:@"SetCategories"]];


    NSArray *array = [NSArray arrayWithObjects:classes, addNewCourse, dashboardView, setCategories, addAScore, scoresSummary, nil];
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
