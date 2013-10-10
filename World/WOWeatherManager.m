//
//  WOWeatherManager.m
//  World
//
//  Created by Jon Como on 10/10/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOWeatherManager.h"

#import "WOObject.h"

@implementation WOWeatherManager

-(id)initWithSize:(CGSize)size target:(WOObject *)target
{
    if (self = [super init]) {
        //init
        _target = target;
        
        _emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"particleSnow" ofType:@"sks"]];
        [self addChild:_emitter];
        
        _wind.dx = 10;
        _wind.dy = -6;
        
        _emitter.xAcceleration = _wind.dx;
        _emitter.yAcceleration = _wind.dy;
    }
    
    return self;
}

-(void)setWind:(CGVector)wind
{
    self.emitter.xAcceleration = _wind.dx;
    self.emitter.yAcceleration = _wind.dy;
}

-(void)setTempurature:(float)tempurature
{
    if (tempurature < 0)
    {
        if (self.emitter.particleBirthRate != 6)
            self.emitter.particleBirthRate = 6;
    }else{
        if (self.emitter.particleBirthRate != 0)
            self.emitter.particleBirthRate = 0;
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    self.emitter.particlePosition = CGPointMake(self.target.position.x, self.target.position.y);
}

@end
