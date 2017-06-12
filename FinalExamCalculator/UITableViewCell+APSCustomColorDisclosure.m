//
//  UITableViewCell+APSCustomColorDisclosure.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 4/28/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "UITableViewCell+APSCustomColorDisclosure.h"


@implementation UITableViewCell (APSCustomColorDisclosure)

/// This function assigns a custom tint to the disclosure indicator on a UITableViewCell.
-(void)prepareDisclosureIndicatorWithTint:(UIColor *)tintColor
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *) view;
            UIImage *image = [[button backgroundImageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTintColor:tintColor];
        }
    }
}

@end
