//
//  WOChunk.h
//  World
//
//  Created by Jon Como on 10/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOObject.h"

#define chunkSize CGSizeMake(objectSize.width * 16,objectSize.height * 16)

@interface WOChunk : WOObject

-(id)initWithSize:(CGSize)size;
-(void)iterateWithTileSize:(CGSize)size block:(void(^)(int x, int y))block;

@end