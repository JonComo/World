//
//  WOMenuViewController.m
//  World
//
//  Created by Jon Como on 10/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOMenuViewController.h"

@interface WOMenuViewController ()
{
    BOOL autoShow;
}

@end

@implementation WOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    autoShow = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (autoShow)
        [self performSegueWithIdentifier:@"play" sender:self];
    
    autoShow = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender
{
    
}

@end
