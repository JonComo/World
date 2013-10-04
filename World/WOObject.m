//
//  MJObject.m
//  MazeJump
//
//  Created by Jon Como on 9/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOObject.h"

#import "WOWorld.h"
#import "WOChunk.h"

#import "JCMath.h"

static int seed;

@implementation WOObject

+(void)initialize
{
    seed = 0;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithTexture:nil color:nil size:size]) {
        //init
        _managedObjects = [NSMutableArray array];
    }
    
    return self;
}

-(void)dealloc
{
    
}

-(void)update:(NSTimeInterval)currentTime
{
    
}

-(void)didSimulatePhysics
{
    
}

-(CGPoint)coordinates
{
    int x = (int)(self.position.x / chunkSize.width);
    int y = (int)(self.position.y / chunkSize.height);
    
    return CGPointMake(x, y);
}

-(float)distanceFromObject:(WOObject *)object
{
    return [JCMath distanceBetweenPoint:CGPointMake(self.position.x, self.position.y) andPoint:CGPointMake(object.position.x, object.position.y) sorting:NO];
}

+(NSArray *)objectsInChunk:(WOChunk *)chunk
{
    return nil;
}

-(void)remove
{
    for (WOObject *managedObject in self.managedObjects)
        [managedObject remove];
    
    if (self.parent)
        [self removeFromParent];
}

@end