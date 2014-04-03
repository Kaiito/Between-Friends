//
//  BFMasterViewController.m
//  BF
//
//  Created by Romain DONON on 21/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import "BFMasterViewController.h"

#import "BFDetailTableViewController.h"

#import <iAd/iAd.h>

@interface BFMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BFMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.canDisplayBannerAds = YES;
  _contactArray = [[NSMutableArray alloc] init];
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
  image.frame = self.view.window.frame;
  self.tableView.backgroundView =  image;
  
  /*------- CoreData -------*/
  id qDelegate              = [[UIApplication sharedApplication] delegate];
  self.managedObjectContext = [qDelegate managedObjectContext];

}

- (void)viewWillAppear:(BOOL)animated
{

  [self updateContactArray];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)insertNewObject:(id)sender
//{
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//    
//    // If appropriate, configure the new managed object.
//    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
//    
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//         // Replace this implementation with code to handle the error appropriately.
//         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//  return [sectionInfo numberOfObjects];
  NSLog(@" contact array count : %lu", (unsigned long)[_contactArray count]);
  return [_contactArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
  
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      NSMutableDictionary *qDico = [_contactArray objectAtIndex:indexPath.row];
      Contacts *qContact = [qDico valueForKey:CONTACTDICO_CONTACT];
      for (Trade *qTrade in qContact.trades) {
        [_managedObjectContext deleteObject:qTrade];
      }
      [_managedObjectContext deleteObject:qContact];
      [_contactArray removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
      
      /*
       * save core data
       */
      NSError *error = nil;
      [self.managedObjectContext save:&error];

      
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      NSMutableDictionary *qDico = [_contactArray objectAtIndex:indexPath.row];
      Contacts *object = [qDico valueForKey:CONTACTDICO_CONTACT];
      NSMutableArray *qArray = [NSMutableArray array];
      for (Trade *qTrade in object.trades) {
        [qArray addObject:qTrade];
      }
      [[segue destinationViewController] setInfo:qArray withContact:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  NSMutableDictionary *qDico = [_contactArray objectAtIndex:indexPath.row];
  Contacts *qContact = [qDico valueForKey:CONTACTDICO_CONTACT];
  cell.textLabel.text = [NSString stringWithFormat:@" %@ %@", qContact.firstName, qContact.lastName];
  cell.detailTextLabel.numberOfLines = 2;
  cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
  cell.detailTextLabel.text = [NSString stringWithFormat:@" %d €\n%d Objets", [[qDico valueForKey:CONTACTDICO_MONEY] intValue],[[qDico valueForKey:CONTACTDICO_OBJECT] intValue]];
}

#pragma mark - Uptade methode

- (void)updateContactArray
{
  NSError *qError;
  NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
  NSEntityDescription *contactEntity = [NSEntityDescription entityForName:COREDATA_ENTITY_CONTACTS
                                                   inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:contactEntity];
  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&qError];
  NSLog(@"NOMBRE DE CONTACT DANS COREDATA %lu", (unsigned long)[fetchedObjects count]);
  
  [_contactArray removeAllObjects];
  for (Contacts *qContact in fetchedObjects) {
    NSMutableDictionary *qDico = [NSMutableDictionary dictionary];
    [qDico setObject:qContact forKey:CONTACTDICO_CONTACT];
    int numberOfObject = 0;
    int total = 0;
    for (Trade *qTrade in qContact.trades) {
      if ([qTrade.type  intValue] == 0) {
        if ([qTrade.way intValue] == 0) {
          total -= [qTrade.value intValue];
        } else total += [qTrade.value intValue];
      } else numberOfObject += 1;
    }
    [qDico setObject:[NSNumber numberWithInt:total] forKey:CONTACTDICO_MONEY];
    [qDico setObject:[NSNumber numberWithInt:numberOfObject] forKey:CONTACTDICO_OBJECT];
    [_contactArray addObject:qDico];
    
  }
  [self.tableView reloadData];
  [self.tableView reloadInputViews];
}

@end
