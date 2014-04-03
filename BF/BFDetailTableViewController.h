//
//  BFDetailTableViewController.h
//  BF
//
//  Created by Romain DONON on 26/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Contacts.h"
#import "Trade.h"
@interface BFDetailTableViewController : UITableViewController {
  Contacts *contact;
}

@property (nonatomic, strong) NSMutableArray *info;

- (void)setInfo:(NSMutableArray *)info withContact:(Contacts *)pContact;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
