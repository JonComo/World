//
//  WOWorld.m
//  World
//
//  Created by Jon Como on 10/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOWorld.h"

#import "WOChunk.h"

#import "WOFloor.h"
#import "WOPlant.h"
#import "WOWall.h"
#import "WOScrounger.h"

#import "WOWeatherManager.h"

#import "WONoiseTemperature.h"

static WOWorld *sharedWorld;

@implementation WOWorld
{
    NSMutableArray *chunks;
    
    SKSpriteNode *floorTiles;
    SKSpriteNode *scene;
    
    WOWeatherManager *weatherManager;
}

+(WOWorld *)sharedWorld
{
    return sharedWorld;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.color = [UIColor grayColor];
        
        chunks = [NSMutableArray array];
        
        floorTiles = [[SKSpriteNode alloc] init];
        [self addChild:floorTiles];
        
        scene = [SKSpriteNode node];
        [self addChild:scene];
        
        _player = [[WOPlayer alloc] initWithSize:CGSizeMake(objectSize.width * 3/4, objectSize.height * 3/4)];
        _player.position = CGPointMake(0, 0);
        [scene addChild:_player];
        
        weatherManager = [[WOWeatherManager alloc] initWithSize:self.size target:_player];
        [self addChild:weatherManager];
    }
    
    sharedWorld = self;
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    for (WOObject *object in scene.children){
        if ([object isKindOfClass:[WOObject class]]) [object update:currentTime];
    }
    
    float playerTemp = [WONoiseTemperature perlinGlobalValueAtPoint:self.player.position];
    weatherManager.tempurature = playerTemp;
    
    [self updateChunks:currentTime];
    
    [weatherManager update:currentTime];
}

-(void)didSimulatePhysics
{
    CGPoint targetPoint = CGPointMake(- self.player.position.x + self.size.width/2, - self.player.position.y + self.size.height/2);
    self.position = CGPointMake(self.position.x - (self.position.x - targetPoint.x)/3, self.position.y - (self.position.y - targetPoint.y)/3);
}

-(void)updateChunks:(NSTimeInterval)currentTime
{
    CGPoint playerCoordinates = [self.player coordinates];
    
    for (int x = -3; x<4; x++) {
        for (int y = -2; y<4; y++) {
            CGPoint testCoords = CGPointMake(x + playerCoordinates.x, y + playerCoordinates.y);
            
            WOChunk *chunk = [self chunkAtCoordinates:testCoords];
            
            if (!chunk){
                [self createChunkAtCoordinates:testCoords];
            }
        }
    }
    
    //remove far chunks
    NSMutableArray *distantChunks = [NSMutableArray array];
    for (WOChunk *chunk in chunks)
    {
        if ([self.player distanceFromObject:chunk] > chunkSize.width * 8){
            //remove chunk
            [distantChunks addObject:chunk];
        }
    }
    
    int chunksToRemove = distantChunks.count;
    
    if (chunksToRemove > 0){
        
        for (int i = distantChunks.count-1; i>=0; i--) {
            WOChunk *chunk = distantChunks[i];
            
            [chunk remove]; //removes all managed objects as well
            [chunks removeObject:chunk];
        }
    }
}

-(WOChunk *)chunkAtCoordinates:(CGPoint)coordinates
{
    for (WOChunk *chunk in chunks){
        if (CGPointEqualToPoint(chunk.coordinates, coordinates)) return chunk;
    }
    
    return nil;
}

-(void)createChunkAtCoordinates:(CGPoint)coordinates
{
    WOChunk *chunk = [[WOChunk alloc] initWithSize:chunkSize coordinates:coordinates];
    [chunks addObject:chunk];
    
    chunk.position = CGPointMake(chunk.coordinates.x * chunkSize.width, chunk.coordinates.y * chunkSize.height);
        
    //Add floor tiles
    NSArray *tiles = [WOFloor objectsInChunk:chunk];
    for (WOObject *tile in tiles)
        [floorTiles addChild:tile];
    
    NSArray *walls = [WOWall objectsInChunk:chunk];
    for (WOObject *wall in walls)
        [scene addChild:wall];
    
    NSArray *plants = [WOPlant objectsInChunk:chunk];
    for (WOObject *plant in plants)
        [scene addChild:plant];
    
    NSArray *scroungers = [WOScrounger objectsInChunk:chunk];
    for (WOObject *scrounger in scroungers)
        [scene addChild:scrounger];
    
    [scene insertChild:self.player atIndex:0];
}

@end
