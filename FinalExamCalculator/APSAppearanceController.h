//
//  APSAppearanceController.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/28/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIViewController;

@interface APSAppearanceController : NSObject

@property (nonatomic, strong) UIColor *blueColor;
@property (nonatomic, strong) UIColor *greenColor;


+(instancetype)shared;
-(void)configureAppearanceForViewController:(UIViewController *)viewController;
-(void)appWideAppearanceSettings;

@end
