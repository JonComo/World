//
//  MJCharacter.m
//  MazeJump
//
//  Created by Jon Como on 9/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOCharacter.h"

@implementation WOCharacter

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
    intensity *= 800;
    
//    float degrees = direction * 180/M_PI;
//    
//    float sectioned = round(degrees / 45) * 45;
//    
//    direction = sectioned * M_PI/180;
    
    CGVector force = CGVectorMake(cosf(direction) * intensity, sinf(direction) * intensity);
    
    //self.position = CGPointMake(self.position.x + force.dx, self.position.y + force.dy);
    
    self.physicsBody.velocity = CGVectorMake(force.dx, force.dy);
    
    self.xScale = force.dx > 0 ? 1 : -1;
}

-(void)jump
{
    [self.physicsBody applyImpulse:CGVectorMake(0, 2)];
}

@end