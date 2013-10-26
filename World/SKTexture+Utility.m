//
//  SKTexture+Utility.m
//  World
//
//  Created by Jon Como on 10/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "SKTexture+Utility.h"

@implementation SKTexture (Utility)

+(SKTexture *)textureWithRandomSubRectOfSize:(CGSize)size ofTexture:(SKTexture *)texture
{
    CGRect randomRect = [SKTexture randomRectWithSize:size containedInTexture:texture];
    
    return [SKTexture textureWithRect:randomRect inTexture:texture];
}

+(CGRect)randomRectWithSize:(CGSize)rectSize containedInTexture:(SKTexture *)texture
{
    int widthRemaining = roundf(texture.size.width - rectSize.width);
    int heightRemaining = roundf(texture.size.height - rectSize.height);
    
    float randomX = (float)((rand()%widthRemaining)/texture.size.width);
    float randomY = (float)((rand()%heightRemaining)/texture.size.height);
    
    return CGRectMake(randomX, randomY, rectSize.width/texture.size.width, rectSize.height/texture.size.width);
}

@end
