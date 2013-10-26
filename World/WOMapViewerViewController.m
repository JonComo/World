//
//  WOMapViewerViewController.m
//  World
//
//  Created by Jon Como on 10/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOMapViewerViewController.h"

@interface WOMapViewerViewController ()

@end

@implementation WOMapViewerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    srandom(0);
    NSLog(@"Rand int: %i", rand()%10);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
