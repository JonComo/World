//
//  WOPlant.m
//  World
//
//  Created by Jon Como on 10/3/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOPlant.h"

#import "WOChunk.h"
#import "WOWorld.h"

#import "WONoiseTemperature.h"

static PerlinNoise *plantNoise;

@implementation WOPlant

+(void)initialize
{
    plantNoise = [[PerlinNoise alloc] initWithSeed:[WONoise seed]];
    noise.octaves = 2;
    noise.frequency = 0.4;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    }
    
    return self;
}

+(NSArray *)objectsInChunk:(WOChunk *)chunk
{
    NSMutableArray *objects = [NSMutableArray array];
    
    CGPoint chunkPositionOffset = CGPointMake(chunk.position.x - chunk.size.width/2, chunk.position.y - chunk.size.height/2);

    CGSize plantTileSize = CGSizeMake(objectSize.width/4, objectSize.height/4);
    
    [chunk iterateWithTileSize:plantTileSize block:^(int x, int y) {
            
        CGPoint plantPosition = CGPointMake(chunkPositionOffset.x + x * plantTileSize.width, chunkPositionOffset.y + y * plantTileSize.height);
        
        float plantValue = [WONoise perlinValueAtPoint:plantPosition inNoise:plantNoise];
        float tempLevel = [WONoiseTemperature perlinGlobalValueAtPoint:plantPosition];
        
        if (plantValue < - 0.1 && tempLevel < -0.1){
            WOPlant *plant = [[WOPlant alloc] initWithSize:CGSizeMake(10 + MAX(0, 10 * -plantValue), 10 + MAX(0, 10 * -plantValue))];
            plant.position = plantPosition;
            plant.color = [UIColor orangeColor];
            [objects addObject:plant];
        }
    }];
    
    [chunk.managedObjects addObjectsFromArray:objects];
    
    return objects;
}

@end
