//
//  APSCoreDataStack.h
//  FinalExamCalculator
//
//  Created by Austin Blaser on 3/20/17.
//  Copyright © 2017 Aptian Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface APSCoreDataStack : NSObject

+(instancetype)shared;
-(NSManagedObjectContext *)mainQueueMOC;
-(NSManagedObjectContext *)privateQueueMOC;
-(void)initializeCoreData;

@end
