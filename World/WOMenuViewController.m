//
//  WOMenuViewController.m
//  World
//
//  Created by Jon Como on 10/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOMenuViewController.h"

#import "WOViewController.h"

#import "Macros.h"

@implementation WOMenuViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self clearFilesAtPath:DOCUMENTS];
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
    [self playWithSeed:0];
}

- (IBAction)playRandomSeed:(id)sender
{
    [self playWithSeed:arc4random()];
}

-(void)playWithSeed:(int)seed
{
    WOViewController *gameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"gameVC"];
    gameVC.seed = seed;
    [self presentViewController:gameVC animated:YES completion:nil];
}

@end
