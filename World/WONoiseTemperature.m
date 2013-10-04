//
//  WONoiseTemperature.m
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WONoiseTemperature.h"

@implementation WONoiseTemperature

+(PerlinNoise *)noise
{
    if (!noise)
    {
        noise = [[PerlinNoise alloc] initWithSeed:[WONoise seed]];
        noise.octaves = 2;
        noise.frequency = 0.05;
    }
    
    return noise;
}

@end