//
//  WOMenuViewController.m
//  World
//
//  Created by Jon Como on 10/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOMenuViewController.h"

#import "WOViewController.h"

#import "WONoise.h"

#import "Macros.h"

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
    
    [self clearFilesAtPath:DOCUMENTS];
    
    if (autoShow)
        [self play];
    
    autoShow = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearFilesAtPath:(NSString *)path
{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filename in files){
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", path, filename] error:nil];
    }
}

- (IBAction)playSeed0:(id)sender
{
    [WONoise setSeed:0];
    [self play];
}

- (IBAction)playRandomSeed:(id)sender
{
    [WONoise setSeed:arc4random()];
    [self play];
}

-(void)play
{
    WOViewController *gameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"gameVC"];
    [self presentViewController:gameVC animated:YES completion:nil];
}

@end
