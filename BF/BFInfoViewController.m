//
//  BFInfoViewController.m
//  BF
//
//  Created by Romain DONON on 27/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import "BFInfoViewController.h"

@interface BFInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bg;

@end

@implementation BFInfoViewController

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
	// Do any additional setup after loading the view.
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default.png"]];
  image.frame = self.view.frame;
  [self.view addSubview:image];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
