//
//  MJObject.h
//  MazeJump
//
//  Created by Jon Como on 9/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "WONoise.h"

#define objectSize CGSizeMake(50,50)

static PerlinNoise *classNoise;

@class WOChunk;

@interface WOObject : SKSpriteNode

@property (nonatomic, strong) NSMutableArray *managedObjects;

-(id)initWithSize:(CGSize)size;
-(void)renderTexture;
-(void)update:(NSTimeInterval)currentTime;
-(void)didSimulatePhysics;

-(CGPoint)coordinates;
-(float)distanceFromObject:(WOObject *)object;
+(NSArray *)objectsInChunk:(WOChunk *)chunk;

-(void)remove;

+(PerlinNoise *)classNoise;

@end