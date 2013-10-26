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
{
    NSString *currentEmitterName;
    BOOL isTransitioning;
}

-(id)initWithSize:(CGSize)size target:(WOObject *)target
{
    if (self = [super init]) {
        //init
        _target = target;
        
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
    if (tempurature < 0){
        [self transitionToEmitterNamed:@"particleSnow"];
    }else{
        [self transitionToEmitterNamed:@"particleLeaf"];
    }
}

-(void)transitionToEmitterNamed:(NSString *)name
{
    if ([currentEmitterName isEqualToString:name] || isTransitioning) return;
    
    NSLog(@"Transition: %@", name);
    
    currentEmitterName = name;
    isTransitioning = YES;
    self.emitter.particleBirthRate = 0;
    
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Started: %@", name);
        
        [self.emitter removeFromParent];
        self.emitter = nil;
        
        self.emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
        [self addChild:self.emitter];
        
        self.emitter.particleBirthRate = 6;
        
        isTransitioning = NO;
    });
}

-(void)update:(NSTimeInterval)currentTime
{
    self.emitter.particlePosition = CGPointMake(self.target.position.x, self.target.position.y);
}

@end
