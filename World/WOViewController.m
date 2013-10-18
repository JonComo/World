//
//  WOViewController.m
//  World
//
//  Created by Jon Como on 10/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOViewController.h"
#import "WOWorldScene.h"

@implementation WOViewController
{
    __weak IBOutlet SKView *skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    WOWorldScene *scene = [WOWorldScene sceneWithSize:skView.bounds.size];
    scene.seed = self.seed;
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
