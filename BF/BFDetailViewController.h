//
//  BFDetailViewController.h
//  BF
//
//  Created by Romain DONON on 21/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
