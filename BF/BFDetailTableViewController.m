//
//  BFDetailTableViewController.m
//  BF
//
//  Created by Romain DONON on 26/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import "BFDetailTableViewController.h"
#import <iAd/iAd.h>

@interface BFDetailTableViewController ()

@end

@implementation BFDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.canDisplayBannerAds = YES;

  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
  image.frame = self.view.window.frame;
  self.tableView.backgroundView =  image;



  /*------- CoreData -------*/
  id qDelegate              = [[UIApplication sharedApplication] delegate];
  self.managedObjectContext = [qDelegate managedObjectContext];

  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(NSMutableArray *)pInfo withContact:(Contacts *)pContact
{
  contact = pContact;
  _info = pInfo;
  self.title = [NSString stringWithFormat:@"%@ %@",pContact.firstName , pContact.lastName];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_info count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  Trade *qTrade = [_info objectAtIndex:indexPath.row];
  if ([qTrade.type intValue] == 0) {
    [cell.imageView setImage:[UIImage imageNamed:@"Arrow-back-48.png"]];
    if ([qTrade.way intValue] == 0) {
      [cell.imageView setImage:[UIImage imageNamed:@"Arrow-back-red-48.png"]];
      cell.textLabel.text = [NSString stringWithFormat:@" -%@ €", [qTrade valueForKey:COREDATA_ENTITY_TRADE_VALUE]];
    } else cell.textLabel.text = [NSString stringWithFormat:@" %@ €",[qTrade valueForKey:COREDATA_ENTITY_TRADE_VALUE]];
  } else {
    if ([qTrade.way intValue] == 0) {
      [cell.imageView setImage:[UIImage imageNamed:@"Arrow-back-red-48.png"]];
    } else [cell.imageView setImage:[UIImage imageNamed:@"Arrow-back-48.png"]];
    cell.textLabel.text = [qTrade valueForKey:COREDATA_ENTITY_TRADE_VALUE];
  }
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  NSString *string = [dateFormatter stringFromDate:qTrade.date];
  cell.detailTextLabel.text = string;
  
    
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
      Trade *qTrade = [_info objectAtIndex:indexPath.row];
      [self.managedObjectContext deleteObject:qTrade];
      [_info removeObjectAtIndex:indexPath.row];
      if ([_info count] == 0) {
        [self.managedObjectContext deleteObject:contact];
      }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      /*
       * save core data
       */
      NSError *error = nil;
      [self.managedObjectContext save:&error];

    }
  
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
