//
//  WONoise.m
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WONoise.h"

static int seed;

@implementation WONoise

+(void)initialize
{
    seed = 0;
}

+(int)seed
{
    return seed;
}

+(PerlinNoise *)noise
{
    if (!noise)
    {
        noise = [[PerlinNoise alloc] initWithSeed:[WONoise seed]];
        noise.octaves = 1;
        noise.frequency = 0.01;
    }
    
    return noise;
}

+(float)perlinGlobalValueAtPoint:(CGPoint)point
{
    PerlinNoise *classNoise = [[self class] noise];
    
    return [WONoise perlinValueAtPoint:point inNoise:classNoise];
}

+(float)perlinValueAtPoint:(CGPoint)point inNoise:(PerlinNoise *)inputNoise
{
    return [inputNoise perlin2DValueForPointX:point.x / perlinStep.width + 10000000 y:point.y / perlinStep.height + 10000000];
}

@end