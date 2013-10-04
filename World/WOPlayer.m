//
//  MJPlayer.m
//  MazeJump
//
//  Created by Jon Como on 9/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOPlayer.h"

@implementation WOPlayer

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.color = [UIColor whiteColor];
        [self.physicsBody setAllowsRotation:NO];
    }
    
    return self;
}

-(void)runInDirection:(float)direction speed:(float)speed
{
    [super runInDirection:direction intensity:speed];
}

-(void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
}

@end
