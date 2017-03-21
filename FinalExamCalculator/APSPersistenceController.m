//
//  APSPersistenceController.m
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import "APSPersistenceController.h"
#import "APSCoreDataStack.h"
@import CoreData;

@implementation APSPersistenceController

+(void)saveToPersistedStore
{
    NSManagedObjectContext *mainMOC = [[APSCoreDataStack shared] mainQueueMOC];
    NSManagedObjectContext *privateMOC = [[APSCoreDataStack shared] privateQueueMOC];
    
    [mainMOC performBlockAndWait:^{
        if ([mainMOC hasChanges]){
            NSError *error = nil;
            [mainMOC save:(&error)];
            
            if (error != nil){
                NSLog(@"Error saving child to parent.");
            } else {
                NSLog(@"Child saved to parent.");
            }
            
        }
    }];
    
    [privateMOC performBlock:^{
        if ([privateMOC hasChanges]) {
            NSError *error = nil;
            [privateMOC save:(&error)];
            
            if (error != nil){
                NSLog(@"Error saving parent to persisted store.");
            } else {
                NSLog(@"Saved to persisted store.");
            }
        }
    }];
    
}

@end
