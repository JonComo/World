//
//  WONoise.h
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PerlinNoise.h"

#define perlinStep CGSizeMake(10,10)

static PerlinNoise *noise;

@interface WONoise : NSObject

+(int)seed;
+(PerlinNoise *)noise;

+(float)perlinGlobalValueAtPoint:(CGPoint)point;
+(float)perlinValueAtPoint:(CGPoint)point inNoise:(PerlinNoise *)inputNoise;

@end