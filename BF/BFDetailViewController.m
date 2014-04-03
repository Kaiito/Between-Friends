//
//  BFDetailViewController.m
//  BF
//
//  Created by Romain DONON on 21/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import "BFDetailViewController.h"

@interface BFDetailViewController ()
- (void)configureView;
@end

@implementation BFDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Contacts *)pContact
{
    if (_contact != pContact) {
        _contact = pContact;
      NSLog(@"user name %@", _contact.firstName);
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.contact) {
    int count = 0;
    for (Trade *qTrade in _contact.trades) {
      if ([qTrade.type intValue] == 0) {
        UILabel *qLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60 + count, self.view.frame.size.width, 30)];
        qLabel.backgroundColor = [UIColor blueColor];
        qLabel.text = [NSString stringWithFormat:@" type :%@ way :%@ value :%@ ",qTrade.way , qTrade.type, qTrade.value];
        [self.view addSubview:qLabel];
        count += 30;
      }
    }
  }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
