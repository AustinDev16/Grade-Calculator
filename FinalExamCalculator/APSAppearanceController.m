//
//  APSAppearanceController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/28/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSAppearanceController.h"
#import <UIKit/UIKit.h>

@interface APSAppearanceController ()



@end

@implementation APSAppearanceController
@synthesize blueColor;
@synthesize greenColor;


+(instancetype)shared{
    static APSAppearanceController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        [shared setupColors];
    });
    return shared;
}

-(void)setupColors
{
    //UIColor *blue = [UIColor colorWithRed:0 green:166/255.0 blue:251/255.0 alpha:1];
    UIColor *darkerBlue = [UIColor colorWithRed:5/255.0 green:130/255.0 blue:202/255.0 alpha:1];
    UIColor *green = [UIColor colorWithRed:58/255.0 green:125/255.0 blue:68/255.0 alpha:1];
    
    [self setBlueColor: darkerBlue];
    [self setGreenColor:green];
}

-(void)configureAppearanceForViewController:(UIViewController *)viewController
{
    //NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:self.greenColor forKey:NSForegroundColorAttributeName];
    //[viewController.navigationController.navigationBar setTitleTextAttributes:titleAttributes];
    
    [self appWideAppearanceSettings];
}

-(void)appWideAppearanceSettings
{
    [UIBarButtonItem.appearance setTintColor:self.blueColor];
    [UINavigationBar.appearance setTintColor:self.blueColor];
    [UIToolbar.appearance setTintColor:self.blueColor];
}

@end
