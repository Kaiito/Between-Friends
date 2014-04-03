//
//  BFMasterViewController.h
//  BF
//
//  Created by Romain DONON on 21/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "Constants.h"
#import "Contacts.h"
#import "Trade.h"

@interface BFMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
  NSMutableArray *_contactArray;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
