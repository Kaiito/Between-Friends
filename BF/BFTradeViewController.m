//
//  BFTradeViewController.m
//  BF
//
//  Created by Romain DONON on 26/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import "BFTradeViewController.h"

@interface BFTradeViewController ()

@end

@implementation BFTradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  /*------- CoreData -------*/
  id qDelegate              = [[UIApplication sharedApplication] delegate];
  self.managedObjectContext = [qDelegate managedObjectContext];
  
  _contactDico = [[NSMutableDictionary alloc] init];

  [self checkSegmentedControlState:_typeSegment];
  NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"button-29" ofType:@"mp3"];
  NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
  qPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
  qPlayer.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear: animated];
  [_dataTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Adresse Book
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
  //remove view
  [self dismissViewControllerAnimated:YES completion:NULL];
  
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
  //call methode to add firstName and lastName to our label
  [self displayPerson:person];
  
  //remove view
  [self dismissViewControllerAnimated:YES completion:NULL];
  
  return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
  return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
  //get firstName from contact
  NSString *qFirstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                        kABPersonFirstNameProperty);
  //set firstName to our label
  if (qFirstName != nil) {
    _firstNameLabel.text = qFirstName;
    [_contactDico setObject:qFirstName forKey:CONTACTDICO_FIRSTNAME];
  } else {
    [_contactDico setObject:@"" forKey:CONTACTDICO_FIRSTNAME];
    _firstNameLabel.text = @"";
  }
  
  //get lastName from contact
  NSString *qLastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
  
  //set lastName to our label
  if (qLastName != nil) {
    [_contactDico setObject:qLastName forKey:CONTACTDICO_LASTNAME];
    _lastNameLabel.text = [NSString stringWithFormat:@"%@",qLastName];
  } else {
    [_contactDico setObject:@"" forKey:CONTACTDICO_LASTNAME];
    _lastNameLabel.text = @"";
  }
  
  //get recordId
  NSNumber *qRecordId = [NSNumber numberWithInteger:ABRecordGetRecordID(person)];
  
  //add info to contact dico
  [_contactDico setObject:qRecordId forKey:CONTACTDICO_RECORDID];
  
  NSLog(@"contactDico firstName: %@", [_contactDico valueForKey:CONTACTDICO_FIRSTNAME]);
  NSLog(@"contactDico lastName: %@", [_contactDico valueForKey:CONTACTDICO_LASTNAME]);
  NSLog(@"contactDico recordId: %@", [_contactDico valueForKey:CONTACTDICO_RECORDID]);
  
  /*
   //get phone number
   NSString *qPhone = nil;
   ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
   kABPersonPhoneProperty);
   if (ABMultiValueGetCount(phoneNumbers) > 0) {
   qPhone = (__bridge_transfer NSString*)
   ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
   [_contactDico setObject:qPhone forKey:CONTACTDICO_PHONENUMBER];
   } else {
   qPhone = @"[None]";
   }
   
   NSString *qEmail = nil;
   ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
   qEmail = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(email, 0);
   
   if ([self NSStringIsValidEmail:qEmail]) {
   [_contactDico setObject:qEmail forKey:CONTACTDICO_EMAIL];
   NSLog(@"contactDico phoneNumber: %@", [_contactDico valueForKey:CONTACTDICO_PHONENUMBER]);
   }
   
   
   
   NSLog(@"contactDico email: %@", [_contactDico valueForKey:CONTACTDICO_EMAIL]);
   */
}

#pragma mark - Button Action
- (IBAction)didSelectContactButton:(id)sender
{
  ABPeoplePickerNavigationController *picker =
  [[ABPeoplePickerNavigationController alloc] init];
  picker.peoplePickerDelegate = self;
  [self presentViewController:picker animated:YES completion: NULL];
}

- (IBAction)didSelectAddButton:(id)sender
{
  /*
   *check if a contact is selected
   */
  
  if ([_contactDico count] == 0) {
    UIAlertView *qAlert = [[UIAlertView alloc] initWithTitle:@"Saisie incomplète" message:@"Vous devez saisir un contact" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [qAlert show];
    return;
  }
  
  /*
   * check if the textField is not empty
   */
  if (_dataTextField.text == nil || [_dataTextField.text isEqualToString:@""]) {
    UIAlertView *qAlert = [[UIAlertView alloc] initWithTitle:@"Saisie incomplète" message:@"Vous devez saisir un montant ou un objet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [qAlert show];
    return;
  }
  
  /*
   * check if contact already existe
   */
  
  NSNumber *qRecordID = [_contactDico valueForKey:CONTACTDICO_RECORDID];
  NSError *qError;
  NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
  NSEntityDescription *solutionEntity = [NSEntityDescription entityForName:COREDATA_ENTITY_CONTACTS
                                                    inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:solutionEntity];
  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&qError];
  Contacts *contact = nil;
  for (Contacts *qContact in fetchedObjects) {
    if ([qContact.recordid intValue] == [qRecordID intValue]) {
      contact = qContact;
      break;
    }
  }
  
  /*
   * create a new object in coreData if it doesn't existe
   */
  if (contact == nil) {
    contact = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITY_CONTACTS inManagedObjectContext:self.managedObjectContext];
    [contact setFirstName:[_contactDico valueForKey:CONTACTDICO_FIRSTNAME]];
    [contact setLastName:[_contactDico valueForKey:CONTACTDICO_LASTNAME]];
    [contact setRecordid:[_contactDico valueForKey:CONTACTDICO_RECORDID]];
  }
  
  /*
   * check type segmentedControl
   */
  
  Trade *qTrade = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITY_TRADE inManagedObjectContext:self.managedObjectContext];
  qTrade.date = [NSDate date];
  qTrade.value = _dataTextField.text;
  
  //set type to trade
  //0 = montant
  //1 = objet
  
  if (_typeSegment.selectedSegmentIndex == 0) {
    qTrade.type = [NSNumber numberWithInt:0];
  } else {
    qTrade.type = [NSNumber numberWithInt:1];
  }
  
  // sense de l'echange
  // 0 == je lui prête
  // 1 == il me prête
  if (_waySegment.selectedSegmentIndex == 0) {
    qTrade.way = [NSNumber numberWithInt:0];
  } else qTrade.way = [NSNumber numberWithInt:1];
  
  [contact addTradesObject:qTrade];
  /*
   * save core data
   */
  NSError *error = nil;
  [self.managedObjectContext save:&error];
  
  
  /*
   * add sound effect
   */
  [qPlayer play];
  
  /*
   * show an alerteView to informe user that the element a successfully been added
   */
  UIAlertView *qAlert = [[UIAlertView alloc] initWithTitle:@"   " message:@"Ajout réussi" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
  [qAlert show];
  [qAlert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:1];
  
  [self checkCoreDataContent];
}


- (void)checkCoreDataContent
{
  NSError *qError;
  NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
  NSEntityDescription *contactEntity = [NSEntityDescription entityForName:COREDATA_ENTITY_CONTACTS
                                                   inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:contactEntity];
  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&qError];
  
  NSLog(@"Nombre de Contacts dans CD : %lu", (unsigned long)[fetchedObjects count]);
  
  for (Contacts *qContact in fetchedObjects) {
    NSLog(@"contact name : %@ %@",qContact.firstName, qContact.lastName);
    if ([qContact.trades count] > 0) {
      for (Trade *qTrade in qContact.trades) {
        NSLog(@"echange :::: %@ %@ %@ %@ ",qTrade.date, qTrade.way , qTrade.type , qTrade.value);
      }
    }
  }
  
}
#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [_scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 200) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if (textField == _dataTextField && _typeSegment.selectedSegmentIndex == 0) {
    NSCharacterSet *cs;
    NSString *filtered;
    // Check for period
    if (![textField.text isEqualToString:@""]) {
      if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:TEXTFIELD_NUMBERSPERIOD] invertedSet];
        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
      }
    }
    // Period is in use
    cs = [[NSCharacterSet characterSetWithCharactersInString:TEXTFIELD_NUMBERS] invertedSet];
    filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
  }
  return YES;
}
#pragma mark - segmented Control

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
  
}
- (IBAction)checkSegmentedControlState:(id)sender
{
  if (sender == _typeSegment) {
    switch (_typeSegment.selectedSegmentIndex) {
      case 0:
        _dataTextField.text = nil;
        _dataTextField.placeholder = @"Entrer le montant";
        _dataTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [self setDataTextFieldWidth:162. withLabelPosition:284 withLabelHiden:NO withLabelText:@"Montant :"];
        break;
      case 1:
        _dataTextField.text = nil;
        _dataTextField.placeholder = @"Saisir l'objet";
        _dataTextField.keyboardType = UIKeyboardTypeDefault;
        [self setDataTextFieldWidth:200. withLabelPosition:308 withLabelHiden:YES withLabelText:@"Objet :"];
        break;
      default:
        break;
    }
    
  }
}

- (void)setDataTextFieldWidth:(CGFloat)pFloat withLabelPosition:(CGFloat)pPosition withLabelHiden:(BOOL)pHidden withLabelText:(NSString*)pText
{
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options: UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     [_typeLabel setWidth:0.];
                     _typeLabel.text = pText;
                     [_typeLabel setWidth:93];
                     [_dataTextField setWidth:pFloat];
                     if (pHidden == NO) _moneyLabel.hidden = pHidden;
                     [_moneyLabel setX:pPosition];
                   }
                   completion:^(BOOL finished){
                     if (pHidden == YES) _moneyLabel.hidden = pHidden;
                   }];
}

@end
