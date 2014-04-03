//
//  BFTradeViewController.h
//  BF
//
//  Created by Romain DONON on 26/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "Contacts.h"
#import "Trade.h"
#import "UIView+ReFrame.h"

@interface BFTradeViewController : UIViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate ,UIScrollViewDelegate, AVAudioPlayerDelegate>
{
  
  IBOutlet UIButton *_contactButton;
  IBOutlet UIButton *_saveButton;
  IBOutlet UILabel *_contactLabel;
  IBOutlet UILabel *_firstNameLabel;
  IBOutlet UILabel *_lastNameLabel;
  IBOutlet UISegmentedControl *_waySegment;
  IBOutlet UISegmentedControl *_typeSegment;
  IBOutlet UITextField *_dataTextField;
  IBOutlet UILabel *_typeLabel;
  IBOutlet UIScrollView *_scrollView;
  IBOutlet UILabel *_saveLabel;
  IBOutlet UILabel *_moneyLabel;
  
  NSMutableDictionary           *_contactDico;
  AVAudioPlayer                 *qPlayer;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


//Button Action
- (IBAction)didSelectContactButton:(id)sender;
- (IBAction)didSelectAddButton:(id)sender;
- (IBAction)checkSegmentedControlState:(id)sender;


@end
