//
//  WONoise.m
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WONoise.h"

@implementation WONoise

-(id)initWithSeed:(int)seed frequency:(float)frequency
{
    if (self = [super initWithSeed:seed]) {
        //init
        self.frequency = frequency;
    }
    
    return self;
}

-(float)perlinValueAtPoint:(CGPoint)point
{
    //Utility method
    return [self perlin2DValueForPointX:point.x / perlinStep.width + 10000000 y:point.y / perlinStep.height + 10000000];
}

@end