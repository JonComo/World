//
//  WONoise.h
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "PerlinNoise.h"

#define perlinStep CGSizeMake(10,10)

@interface WONoise : PerlinNoise

-(id)initWithSeed:(int)seed frequency:(float)frequency;

-(float)perlinValueAtPoint:(CGPoint)point;

@end