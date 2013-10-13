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
    
    SKSpriteNode *floorTiles;
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
    self.position = CGPointMake((int) (self.position.x - (self.position.x - targetPoint.x)/3), (int)(self.position.y - (self.position.y - targetPoint.y)/3));
}

-(void)updateChunks:(NSTimeInterval)currentTime
{
    if (isFindingChunk || isCreatingChunk) return;
    
    archivedChunkFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS error:nil];
    
    CGPoint playerCoordinates = [self.player coordinates];
    
    for (int x = -1; x<1; x++) {
        for (int y = -1; y<1; y++) {
            
            if (isFindingChunk || isCreatingChunk) return;
            
            CGPoint testCoords = CGPointMake(x + playerCoordinates.x, y + playerCoordinates.y);
            
            isFindingChunk = YES;
            [self chunkAtCoordinates:testCoords completion:^(WOChunk *chunk) {
                isFindingChunk = NO;
                
                if (!chunk){
                    isCreatingChunk = YES;
                    [self createChunkAtCoordinates:testCoords completion:^{
                        isCreatingChunk = NO;
                    }];
                }
            }];
        }
    }
    
    //remove far chunks
    for (WOChunk *chunk in chunks){
        if (ABS(playerCoordinates.x - chunk.coordinates.x) > 2 && ABS(playerCoordinates.x - chunk.coordinates.x) > 2){
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
    for (WOChunk *chunk in chunks){
        if (CGPointEqualToPoint(chunk.coordinates, coordinates)){
            if (block) block(chunk);
            return;
        }
    }
    
    if (block) block(nil);
    return;
    
    /*
    if (archivedChunkFileNames.count == 0)
    {
        if (block) block(nil);
        return;
    }
    
    //search archived
    for (NSString *chunkFileName in archivedChunkFileNames){
        NSString *path = [NSString stringWithFormat:@"%@/%i%i", DOCUMENTS, (int)coordinates.x, (int)coordinates.y];
        BOOL foundFile = [[NSFileManager defaultManager] fileExistsAtPath:path];
        
        if (foundFile){
            [self unarchiveChunkWithFilePath:path coordinates:coordinates completion:block];
        }else{
            if (block) block(nil);
        }
    } */
}

-(void)unarchiveChunkWithFilePath:(NSString *)path coordinates:(CGPoint)coordinates completion:(void(^)(WOChunk *chunk))block
{
    NSLog(@"UNARCHIVING");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *objects = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (WOObject *object in objects){
                [scene addChild:object];
            }
            
            WOChunk *chunk = [[WOChunk alloc] initWithSize:chunkSize coordinates:coordinates];
            chunk.position = CGPointMake(chunk.coordinates.x * chunkSize.width, chunk.coordinates.y * chunkSize.height);
            [chunks addObject:chunk];
            
            if (block) block(chunk);
        });
    });
}

-(void)createChunkAtCoordinates:(CGPoint)coordinates completion:(void(^)(void))block
{
    NSLog(@"CREATING");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        WOChunk *chunk = [[WOChunk alloc] initWithSize:chunkSize coordinates:coordinates];
        
        chunk.position = CGPointMake(chunk.coordinates.x * chunkSize.width, chunk.coordinates.y * chunkSize.height);
        
        //Add floor tiles
        NSArray *tiles = [WOFloor objectsInChunk:chunk];
        
        
        NSArray *walls = [WOWall objectsInChunk:chunk];
        
        
        NSArray *plants = [WOPlant objectsInChunk:chunk];
        
        
        NSArray *scroungers = [WOScrounger objectsInChunk:chunk];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [chunks addObject:chunk];
            
            for (WOObject *tile in tiles)
                [floorTiles addChild:tile];
            
            for (WOObject *scrounger in scroungers)
                [scene addChild:scrounger];
            
            for (WOObject *plant in plants)
                [scene addChild:plant];
            
            for (WOObject *wall in walls)
                [scene addChild:wall];
            
            [scene insertChild:self.player atIndex:0];
            
            if (block) block();
        });
    });
}

-(void)archiveChunk:(WOChunk *)chunk
{
    NSLog(@"ARCHIVING");
    
    NSMutableArray *objectsInChunk = [NSMutableArray array];
    
    for (WOObject *object in scene.children){
        if (CGPointEqualToPoint([object coordinates], chunk.coordinates)){
            //archive it
            [objectsInChunk addObject:object];
        }
    }
    
    for (WOObject *object in floorTiles.children){
        if (CGPointEqualToPoint([object coordinates], chunk.coordinates)){
            //archive it
            [objectsInChunk addObject:object];
        }
    }
    
    //NSData *chunkData = [NSKeyedArchiver archivedDataWithRootObject:objectsInChunk];
    
    //[chunkData writeToFile:[NSString stringWithFormat:@"%@/%i%i", DOCUMENTS, (int)chunk.coordinates.x, (int)chunk.coordinates.y] atomically:YES];
    
    [chunk remove]; //removes all managed objects as well
    [chunks removeObject:chunk];
    
    for (int i = objectsInChunk.count - 1; i>=0; i--)
    {
        WOObject *object = objectsInChunk[i];
        [object remove];
    }
}

@end
