//
//  SKTexture+Utility.h
//  World
//
//  Created by Jon Como on 10/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTexture (Utility)

+(SKTexture *)textureWithRandomSubRectOfSize:(CGSize)size ofTexture:(SKTexture *)texture;

@end