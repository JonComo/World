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

@implementation WOObject

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
    int x = 0;
    int y = 0;
    
    if (self.position.x > 0){
        x = (int)(self.position.x / chunkSize.width);
    }else{
        x = (int)(self.position.x / chunkSize.width) - 1;
    }
    
    if (self.position.y > 0){
        y = (int)(self.position.y / chunkSize.height);
    }else{
        y = (int)(self.position.y / chunkSize.height) - 1;
    }
    
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

-(void)renderTexture
{
    
}

+(PerlinNoise *)classNoise
{
    return nil;
}

@end