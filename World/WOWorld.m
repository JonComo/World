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

#import "Macros.h"

#import "WOWeatherManager.h"

#import "WONoiseTemperature.h"

static WOWorld *sharedWorld;

@implementation WOWorld
{
    NSMutableArray *chunks;
    
    SKSpriteNode *scene;
    
    WOWeatherManager *weatherManager;
    
    __block BOOL isFindingChunk;
    __block BOOL isCreatingChunk;
    NSMutableArray *distantChunks;
    NSArray *archivedChunkFileNames;
}

+(WOWorld *)sharedWorld
{
    return sharedWorld;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        isFindingChunk = NO;
        isCreatingChunk = NO;
        distantChunks = [NSMutableArray array];
        
        chunks = [NSMutableArray array];
        
        scene = [SKSpriteNode node];
        [self addChild:scene];
        
        _player = [[WOPlayer alloc] initWithSize:CGSizeMake(objectSize.width * 3/4, objectSize.height * 3/4)];
        _player.position = CGPointMake(0, 0);
        _player.zPosition = 0;
        [scene addChild:_player];
        
        weatherManager = [[WOWeatherManager alloc] initWithSize:self.size target:_player];
        [self addChild:weatherManager];
        weatherManager.zPosition = -100;
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
    
    //NSLog(@"PLAYER: %f %f", self.player.coordinates.x, self.player.coordinates.y);
    
    [weatherManager update:currentTime];
}

-(void)didSimulatePhysics
{
    CGPoint targetPoint = CGPointMake(- self.player.position.x + self.size.width/2, - self.player.position.y + self.size.height/2);
    self.position = CGPointMake((int) (self.position.x - (self.position.x - targetPoint.x)/3), (int)(self.position.y - (self.position.y - targetPoint.y)/3));
}

-(void)updateChunks:(NSTimeInterval)currentTime
{
    CGPoint playerCoordinates = [self.player coordinates];
    
    for (int x = -3; x<3; x++) {
        for (int y = -3; y<3; y++) {
            
            archivedChunkFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS error:nil];
            
            CGPoint testCoords = CGPointMake(x + playerCoordinates.x, y + playerCoordinates.y);
            
            WOChunk *chunk = [self chunkAtCoordinates:testCoords];
            
            if (!chunk){
                NSLog(@"NO CHUNK AT %.0f %.0f", testCoords.x, testCoords.y);
                [self createChunkAtCoordinates:testCoords];
            }
        }
    }
    
    //remove far chunks
    for (WOChunk *chunk in chunks){
        if (ABS(playerCoordinates.x - chunk.coordinates.x) > 4 || ABS(playerCoordinates.y - chunk.coordinates.y) > 4){
            [distantChunks addObject:chunk];
        }
    }
    
    int chunksToRemove = distantChunks.count;
    
    if (chunksToRemove > 0){
        
        for (int i = distantChunks.count-1; i>=0; i--) {
            WOChunk *chunk = distantChunks[i];
            
            [self archiveChunk:chunk];
        }
    }
    
    [distantChunks removeAllObjects];
}

-(WOChunk *)chunkAtCoordinates:(CGPoint)coordinates
{
    for (WOChunk *chunk in chunks){
        if (CGPointEqualToPoint(chunk.coordinates, coordinates)){
            return chunk;
        }
    }
    
    //search archived
    for (NSString *chunkFileName in archivedChunkFileNames){
        
        NSString *filename = [NSString stringWithFormat:@"chunkX%iY%i", (int)coordinates.x, (int)coordinates.y];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", DOCUMENTS, filename];
        BOOL foundFile = [[NSFileManager defaultManager] fileExistsAtPath:path];
        
        if (foundFile){
            NSLog(@"Returning archived chunk");
            WOChunk *chunk = [self unarchiveChunkWithFilePath:path coordinates:coordinates];
            
            return chunk;
        }
    }
    
    return nil;
}

-(WOChunk *)unarchiveChunkWithFilePath:(NSString *)path coordinates:(CGPoint)coordinates
{
    NSLog(@"UNARCHIVING %.0f %.0f", coordinates.x, coordinates.y);

    NSArray *objects = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    WOChunk *chunk = [[WOChunk alloc] initWithSize:chunkSize];
    
    chunk.position = CGPointMake(coordinates.x * chunkSize.width + chunkSize.width/2, coordinates.y * chunkSize.height + chunkSize.height/2);
    
    [chunks addObject:chunk];
    
    for (WOObject *object in objects){
        [scene addChild:object];
    }
    
    return chunk;
}

-(WOChunk *)createChunkAtCoordinates:(CGPoint)coordinates
{
    NSLog(@"CREATING");

    WOChunk *chunk = [[WOChunk alloc] initWithSize:chunkSize];
        
    chunk.position = CGPointMake(coordinates.x * chunkSize.width + chunkSize.width/2, coordinates.y * chunkSize.height + chunkSize.height/2);
    
    [chunks addObject:chunk];

    //Add floor tiles
    NSArray *tiles = [WOFloor objectsInChunk:chunk];
    
    
    NSArray *walls = [WOWall objectsInChunk:chunk];
    
    
    NSArray *plants = [WOPlant objectsInChunk:chunk];
    
    
    NSArray *scroungers = [WOScrounger objectsInChunk:chunk];
    
            
    for (WOObject *tile in tiles)
        [scene addChild:tile];

    for (WOObject *scrounger in scroungers)
        [scene addChild:scrounger];
    
    for (WOObject *plant in plants)
        [scene addChild:plant];
    
    for (WOObject *wall in walls)
        [scene addChild:wall];
    
    return chunk;
}

-(void)archiveChunk:(WOChunk *)chunk
{
    NSMutableArray *objectsInChunk = [NSMutableArray array];
    
    for (WOObject *object in scene.children){
        if (CGPointEqualToPoint([object coordinates], chunk.coordinates)){
            [objectsInChunk addObject:object];
        }
    }
    
    NSData *chunkData = [NSKeyedArchiver archivedDataWithRootObject:objectsInChunk];
    
    NSString *filename = [NSString stringWithFormat:@"chunkX%iY%i", (int)chunk.coordinates.x, (int)chunk.coordinates.y];
    
    NSLog(@"ARCHIVING TO FILE %@", filename);
    
    [chunkData writeToFile:[NSString stringWithFormat:@"%@/%@", DOCUMENTS, filename] atomically:YES];
    
    [chunk remove]; //removes all managed objects as well
    [chunks removeObject:chunk];
    
    for (int i = objectsInChunk.count - 1; i>=0; i--){
        WOObject *object = objectsInChunk[i];
        [object remove];
    }
}

@end
