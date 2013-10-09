//
//  MJCharacter.m
//  MazeJump
//
//  Created by Jon Como on 9/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOCharacter.h"

#import "WONoiseTemperature.h"

@implementation WOCharacter
{
    float footstepTimer;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    }
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx * 0.8, self.physicsBody.velocity.dy * 0.8);
}

-(void)runInDirection:(float)direction intensity:(float)intensity
{
    CGVector force = CGVectorMake(cosf(direction) * intensity * 200, sinf(direction) * intensity * 200);
    
    self.xScale = force.dx > 0 ? 1 : -1;
    
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx + force.dx/6, self.physicsBody.velocity.dy + force.dy/6);
    
    footstepTimer += intensity;
    
    if (footstepTimer > 20){
        footstepTimer = 1;
        
        self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx + force.dx, self.physicsBody.velocity.dy + force.dy);
        
        NSString *substance = @"stone";
        
        if ([WONoiseTemperature perlinGlobalValueAtPoint:self.position] > 0) {
            substance = @"leaf";
        }
        
        SKAction *playSound = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@%i.caf", substance, arc4random()%4] waitForCompletion:NO];
        
        [self runAction:playSound];
        
        NSLog(@"PLAYING STEP");
    }
}

-(void)jump
{
    [self.physicsBody applyImpulse:CGVectorMake(0, 2)];
}

@end