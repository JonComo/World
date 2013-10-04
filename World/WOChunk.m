//
//  WOChunk.m
//  World
//
//  Created by Jon Como on 10/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOChunk.h"

#import "WOWorld.h"

@implementation WOChunk
{
    CGPoint worldCoordinates;
}

-(id)initWithSize:(CGSize)size coordinates:(CGPoint)coordinates
{
    if (self = [super initWithSize:size]) {
        //init
        worldCoordinates = coordinates;
    }
    
    return self;
}

-(CGPoint)coordinates
{
    return worldCoordinates;
}

-(void)iterateWithTileSize:(CGSize)size block:(void (^)(int x, int y))block
{
    int numX = self.size.width / size.width;
    int numY = self.size.height / size.height;
    
    for (int x = 0; x<numX; x++) {
        for (int y = 0; y<numY; y++) {
            if (block) block(x, y);
        }
    }
}

@end