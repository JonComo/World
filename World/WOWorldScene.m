//
//  WOWorldScene.m
//  World
//
//  Created by Jon Como on 10/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOWorldScene.h"

#import "JCControlPad.h"
#import "WOWorld.h"

@interface WOWorldScene () <JCControlPadDelegate>

@end

@implementation WOWorldScene
{
    WOWorld *world;
    
    JCControlPad *padMove;
    JCControlPad *padTurn;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        world = [[WOWorld alloc] initWithSize:size seed:0];
        world.position = CGPointMake(world.size.width/2, world.size.height/2);
        [self addChild:world];
        
        [self addControls];
    }
    
    return self;
}

-(void)addControls
{
    CGSize padSize = CGSizeMake(200, 200);
    
    padMove = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(padSize.width/2, padSize.height/2, padSize.width, padSize.height) delegate:self];
    [self addChild:padMove];
    
    padTurn = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(self.size.width - padSize.width/2, padSize.height/2, padSize.width, padSize.height) delegate:self];
    [self addChild:padTurn];
}

-(void)update:(NSTimeInterval)currentTime
{
    [padMove update:currentTime];
    [padTurn update:currentTime];
    [world update:currentTime];
}

-(void)didSimulatePhysics
{
    [world didSimulatePhysics];
}

-(void)controlPad:(JCControlPad *)pad changedInputWithDirection:(float)direction intensity:(float)intensity
{
    if (pad == padMove) {
        [world.player runInDirection:direction intensity:intensity];
    }
}

@end
