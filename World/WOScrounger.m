//
//  WOScrounger.m
//  World
//
//  Created by Jon Como on 10/9/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOScrounger.h"

#import "WOChunk.h"

#import "WONoiseTemperature.h"

@implementation WOScrounger
{
    BOOL isWalking;
    float direction;
    float intensity;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        isWalking = NO;
    }
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    if (arc4random()%50 == 0 && !isWalking)
    {
        isWalking = YES;
        direction = (arc4random()%360) * M_PI/180;
        intensity = (float)(arc4random()%10)/20.0f;
    }
    
    if (isWalking){
        [super runInDirection:direction intensity:intensity];
        
        if (arc4random()%50 == 0)
        {
            isWalking = NO;
        }
    }
    
    [super update:currentTime];
}

+(NSArray *)objectsInChunk:(WOChunk *)chunk
{
    NSMutableArray *objects = [NSMutableArray array];
    
    CGPoint chunkPositionOffset = CGPointMake(chunk.position.x - chunk.size.width/2, chunk.position.y - chunk.size.height/2);
    
    CGSize tileSize = CGSizeMake(objectSize.width, objectSize.height);
    
    [chunk iterateWithTileSize:tileSize block:^(int x, int y) {
        
        CGPoint position = CGPointMake(chunkPositionOffset.x + x * tileSize.width, chunkPositionOffset.y + y * tileSize.height);
        
        float tempLevel = [WONoiseTemperature perlinGlobalValueAtPoint:position];
        
        if (tempLevel < -0.1 && arc4random()%20 == 0){
            WOScrounger *scrounger = [[WOScrounger alloc] initWithSize:CGSizeMake(objectSize.width/2, objectSize.height/2)];
            
            scrounger.position = position;
            
            scrounger.color = [UIColor colorWithRed:0.7 green:0.1 blue:0.4 alpha:1];
            
            [objects addObject:scrounger];
        }
    }];
    
    [chunk.managedObjects addObjectsFromArray:objects];
    
    return objects;
}

@end
