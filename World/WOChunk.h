//
//  WOChunk.h
//  World
//
//  Created by Jon Como on 10/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOObject.h"

#define chunkSize CGSizeMake(objectSize.width * 3,objectSize.height * 3)

@interface WOChunk : WOObject

-(id)initWithSize:(CGSize)size coordinates:(CGPoint)coordinates;
-(void)iterateWithTileSize:(CGSize)size block:(void(^)(int x, int y))block;

@end