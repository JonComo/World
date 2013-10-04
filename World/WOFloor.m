//
//  WOFloor.m
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOFloor.h"

#import "WOWorld.h"
#import "WOChunk.h"

#import "WONoiseTemperature.h"

#import "JCMath.h"

@implementation WOFloor

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        
    }
    
    return self;
}

+(NSArray *)objectsInChunk:(WOChunk *)chunk
{
    NSMutableArray *objects = [NSMutableArray array];
    
    CGPoint chunkPositionOffset = CGPointMake(chunk.position.x - chunk.size.width/2, chunk.position.y - chunk.size.height/2);
    
    CGSize tileSize = objectSize;
    
    int numX = chunk.size.width / tileSize.width;
    int numY = chunk.size.height / tileSize.height;
    
    for (int x = 0; x<numX; x++) {
        for (int y = 0; y<numY; y++) {
            CGPoint tilePosition = CGPointMake(chunkPositionOffset.x + tileSize.width * x + tileSize.width/2, chunkPositionOffset.y + tileSize.height * y + tileSize.height/2);
            
            float perlinValue = [WONoiseTemperature perlinGlobalValueAtPoint:tilePosition];
            
            WOObject *floorTile = [[WOObject alloc] initWithSize:tileSize];
            floorTile.position = tilePosition;
            
            
            
            floorTile.color = [UIColor colorWithRed:0.5 + perlinValue * 3 green:0.5 + perlinValue * 2 blue:0.5 alpha:1];
            
            [objects addObject:floorTile];
        }
    }
    
    [chunk.managedObjects addObjectsFromArray:objects];
    
    return objects;
}

@end
