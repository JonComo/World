//
//  WOWorld.h
//  World
//
//  Created by Jon Como on 10/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOObject.h"

#import "WOPlayer.h"

#import "PerlinNoise.h"

@interface WOWorld : WOObject

@property (nonatomic, strong) WOPlayer *player;

+(WOWorld *)sharedWorld;
+(int)seed;

-(id)initWithSize:(CGSize)size seed:(int)globalSeed;

@end