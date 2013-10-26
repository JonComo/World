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

static WOWorld *sharedWorld;
static int seed;

@implementation WOWorld
{
    NSMutableArray *chunks;
    
    SKSpriteNode *scene;
    
    WOWeatherManager *weatherManager;
    
    BOOL isCreatingChunk;
    NSMutableArray *distantChunks;
    NSArray *archivedChunkFileNames;
}

+(WOWorld *)sharedWorld
{
    return sharedWorld;
}

+(int)seed
{
    return seed;
}

-(id)initWithSize:(CGSize)size seed:(int)globalSeed
{
    if (self = [super initWithSize:size]) {
        //init
        srandom(globalSeed);
        
        _noiseTemperature = [[WONoise alloc] initWithSeed:globalSeed frequency:0.01];
        _noisePlant = [[WONoise alloc] initWithSeed:globalSeed frequency:0.08];
        
        distantChunks = [NSMutableArray array];
        
        chunks = [NSMutableArray array];
        
        scene = [SKSpriteNode node];
        [self addChild:scene];
        
        _player = [[WOPlayer alloc] initWithSize:CGSizeMake(objectSize.width * 3/4, objectSize.height * 3/4)];
        _player.position = CGPointMake(0, 0);
        _player.zPosition = Z_DEPTH_PLAYER;
        [scene addChild:_player];
        
        weatherManager = [[WOWeatherManager alloc] initWithSize:self.size target:_player];
        [self addChild:weatherManager];
        weatherManager.zPosition = Z_DEPTH_WEATHER;
        
        NSTimer *timerChunks;
        timerChunks = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateChunks) userInfo:nil repeats:YES];
    }
    
    sharedWorld = self;
    
    return self;
}

-(void)update:(NSTimeInterval)currentTime
{
    for (WOObject *object in scene.children){
        if ([object isKindOfClass:[WOObject class]]) [object update:currentTime];
    }
    
    float playerTemp = [[WOWorld sharedWorld].noiseTemperature perlinValueAtPoint:self.player.position];
    weatherManager.tempurature = playerTemp;
    
    [weatherManager update:currentTime];
}

-(void)didSimulatePhysics
{
    CGPoint targetPoint = CGPointMake(- self.player.position.x + self.size.width/2, - self.player.position.y + self.size.height/2);
    self.position = CGPointMake((int) (self.position.x - (self.position.x - targetPoint.x)/3), (int)(self.position.y - (self.position.y - targetPoint.y)/3));
}

-(void)updateChunks
{
    CGPoint playerCoordinates = [self.player coordinates];
    
    for (int x = -2; x<2; x++) {
        for (int y = -2; y<2; y++) {
            if (isCreatingChunk) continue;
            
            archivedChunkFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS error:nil];
            
            CGPoint offsetCoordinates = CGPointMake(x + playerCoordinates.x, y + playerCoordinates.y);
            
            isCreatingChunk = YES;
            [self chunkAtCoordinates:offsetCoordinates completion:^(WOChunk *chunk) {
                isCreatingChunk = NO;
            }];
        }
    }
    
    //remove far chunks
    for (WOChunk *chunk in chunks){
        if (ABS(playerCoordinates.x - chunk.coordinates.x) > 3 || ABS(playerCoordinates.y - chunk.coordinates.y) > 3){
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

-(void)chunkAtCoordinates:(CGPoint)coordinates completion:(void(^)(WOChunk *chunk))block
{
    //Check live memory first
    
    for (WOChunk *chunk in chunks){
        if (CGPointEqualToPoint(chunk.coordinates, coordinates)){
            if (block) block(chunk);
            return;
        }
    }
    
    //check if archived exists already
    
    NSString *archivePath = [self pathOfChunkAtCoordinates:coordinates];
    
    if (archivePath){
        [self unarchiveChunkWithFilePath:archivePath coordinates:coordinates completion:block];
        return;
    }
    
    //Otherwise, create new:
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        WOChunk *chunk = [[WOChunk alloc] initWithSize:chunkSize];
        
        chunk.position = CGPointMake(coordinates.x * chunkSize.width + chunkSize.width/2, coordinates.y * chunkSize.height + chunkSize.height/2);
        
        //Add floor tiles
        NSArray *tiles = [WOFloor objectsInChunk:chunk];
        
        NSArray *walls = [WOWall objectsInChunk:chunk];
        
        NSArray *plants = [WOPlant objectsInChunk:chunk];
        
        NSArray *scroungers = [WOScrounger objectsInChunk:chunk];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (WOObject *tile in tiles)
                [scene addChild:tile];
//
//            for (WOObject *scrounger in scroungers)
//                [scene addChild:scrounger];
//            
            for (WOObject *plant in plants)
                [scene addChild:plant];
            
            for (WOObject *wall in walls)
                [scene addChild:wall];
            
            [chunks addObject:chunk];
            
            if (block) block(chunk);
        });
    });
}

-(void)archiveChunk:(WOChunk *)chunk
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [chunk remove]; //removes all managed objects as well
            [chunks removeObject:chunk];
            
            for (int i = objectsInChunk.count - 1; i>=0; i--){
                WOObject *object = objectsInChunk[i];
                [object remove];
            }
        });
    });
}

-(void)unarchiveChunkWithFilePath:(NSString *)path coordinates:(CGPoint)coordinates completion:(void(^)(WOChunk *))block
{
    NSLog(@"UNARCHIVING %.0f %.0f", coordinates.x, coordinates.y);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *objects = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        WOChunk *chunk = [[WOChunk alloc] initWithSize:chunkSize];
        
        chunk.position = CGPointMake(coordinates.x * chunkSize.width + chunkSize.width/2, coordinates.y * chunkSize.height + chunkSize.height/2);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [chunks addObject:chunk];
            
            for (WOObject *object in objects){
                [scene addChild:object];
            }
            
            if (block) block(chunk);
        });
    });
}

-(NSString *)pathOfChunkAtCoordinates:(CGPoint)coordinates
{
    for (NSString *chunkFileName in archivedChunkFileNames){
        
        NSString *filename = [NSString stringWithFormat:@"chunkX%iY%i", (int)coordinates.x, (int)coordinates.y];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", DOCUMENTS, filename];
        BOOL foundFile = [[NSFileManager defaultManager] fileExistsAtPath:path];
        
        if (foundFile){
            return path;
        }
    }
    
    return nil;
}

@end
