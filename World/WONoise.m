//
//  WONoise.m
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WONoise.h"

@implementation WONoise

+(PerlinNoise *)noise
{
    return nil;
}

+(float)perlinGlobalValueAtPoint:(CGPoint)point
{
    return [[[self class] noise] perlin2DValueForPointX:point.x y:point.y];
}

+(float)perlinValueAtPoint:(CGPoint)point inNoise:(PerlinNoise *)inputNoise
{
    //Utility method
    return [inputNoise perlin2DValueForPointX:point.x / perlinStep.width + 10000000 y:point.y / perlinStep.height + 10000000];
}

@end