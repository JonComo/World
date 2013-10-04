//
//  WOWall.m
//  World
//
//  Created by Jon Como on 10/4/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOWall.h"

#import "WOChunk.h"
#import "WONoiseTemperature.h"

@implementation WOWall

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        [self.physicsBody setDynamic:NO];
        
    }
    
    return self;
}

+(NSArray *)objectsInChunk:(WOChunk *)chunk
{
    NSMutableArray *objects = [NSMutableArray array];
    
    CGPoint chunkPositionOffset = CGPointMake(chunk.position.x - chunk.size.width/2, chunk.position.y - chunk.size.height/2);
    
    CGSize tileSize = objectSize;
    
    [chunk iterateWithTileSize:tileSize block:^(int x, int y) {
        CGPoint tilePosition = CGPointMake(chunkPositionOffset.x + tileSize.width * x + tileSize.width/2, chunkPositionOffset.y + tileSize.height * y + tileSize.height/2);
        
        float perlinValue = [WONoiseTemperature perlinGlobalValueAtPoint:tilePosition];
        
        if (perlinValue < - 0.01 && perlinValue > -0.018 && arc4random()%3 == 0)
        {
            WOWall *wall = [[WOWall alloc] initWithSize:tileSize];
            wall.position = tilePosition;
            
            
            wall.color = [UIColor colorWithRed:0.2 + perlinValue green:0.2 - perlinValue blue:0.3 + perlinValue * 2 alpha:1];
            
            [objects addObject:wall];
        }
    }];
    
    [chunk.managedObjects addObjectsFromArray:objects];
    
    return objects;
}

@end
