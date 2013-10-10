//
//  WOWeatherManager.h
//  World
//
//  Created by Jon Como on 10/10/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class WOObject;

@interface WOWeatherManager : SKSpriteNode

@property (nonatomic, strong) SKEmitterNode *emitter;
@property (nonatomic, assign) float tempurature;
@property (nonatomic, assign) CGVector wind;

@property (nonatomic, weak) WOObject *target;

-(id)initWithSize:(CGSize)size target:(WOObject *)targetObject;

-(void)update:(NSTimeInterval)currentTime;

@end