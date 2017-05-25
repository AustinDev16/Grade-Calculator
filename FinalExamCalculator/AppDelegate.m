//
//  AppDelegate.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "APSCoreDataStack.h"
#import "APSPersistenceController.h"
#import "APSClassesTableViewController.h"
#import "APSCourseController.h"
#import "APSMockDataController.h"
#import "APSAppDataController.h"
#import "APSAppearanceController.h"
#import "APSOnboardingCustomViewController.h"
#import "APSOnboardingPageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)CoreDataReadyNotified
{
    if ([[[[APSAppDataController shared] courseController] courses] count] == 0){
        [APSMockDataController createMockDataCourse];
        [APSMockDataController createMockDataCategories];
    }
}

-(void)launchMainViewAfterOnboarding
{
    UITableViewController *tvc = [[APSClassesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    

    [self.window setRootViewController:nc];
    
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CoreDataReadyNotified) name:@"CoreDataStoreReady" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchMainViewAfterOnboarding) name:@"OnboardingFinished" object:nil];
    
    [[APSCoreDataStack shared] initializeCoreData];
    

    
    
    
    UIWindow *window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    UITableViewController *tvc = [[APSClassesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    
    //For Testing onboarding
    NSDictionary * options = [NSDictionary dictionaryWithObject:
                              [NSNumber numberWithInt:UIPageViewControllerSpineLocationMax]
                                                         forKey:UIPageViewControllerOptionSpineLocationKey];
    
    APSOnboardingPageViewController *testPageController = [[APSOnboardingPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    [testPageController configurePageController];

    
    
    
    [window setRootViewController:testPageController];
    
    [window makeKeyAndVisible];
    
    [APSAppearanceController.shared appWideAppearanceSettings];
    
    [self setWindow:window];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [APSPersistenceController saveToPersistedStore];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [APSPersistenceController saveToPersistedStore];
}


@end
