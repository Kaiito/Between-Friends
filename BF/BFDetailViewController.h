//
//  BFDetailViewController.h
//  BF
//
//  Created by Romain DONON on 21/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts.h"
#import "Trade.h"

@interface BFDetailViewController : UIViewController

@property (strong, nonatomic) Contacts *contact;

- (void)setDetailItem:(Contacts *)pContact;

@end
