//
//  WOWorld.h
//  World
//
//  Created by Jon Como on 10/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOObject.h"

#import "WOPlayer.h"

typedef enum
{
    Z_DEPTH_FLOOR,
    Z_DEPTH_OBJECT,
    Z_DEPTH_PLAYER,
    Z_DEPTH_WEATHER,
    Z_DEPTH_CONTROL
} Z_DEPTH;

@interface WOWorld : WOObject

@property (nonatomic, strong) WOPlayer *player;

//noises
@property (nonatomic, strong) WONoise *noiseTemperature;
@property (nonatomic, strong) WONoise *noisePlant;

+(WOWorld *)sharedWorld;
+(int)seed;

-(id)initWithSize:(CGSize)size seed:(int)globalSeed;

@end