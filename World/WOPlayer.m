//
//  MJPlayer.m
//  MazeJump
//
//  Created by Jon Como on 9/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOPlayer.h"

@implementation WOPlayer

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        [self renderTexture];
    }
    
    return self;
}

-(void)runInDirection:(float)direction speed:(float)speed
{
    [super runInDirection:direction intensity:speed];
}

-(void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
}

-(void)renderTexture
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 2);
    
    //// Color Declarations
    UIColor* fillColor2 = [UIColor colorWithRed: 0.657 green: 0 blue: 0 alpha: 1];
    UIColor* fillColor3 = [UIColor colorWithRed: 0.2 green: 0 blue: 0 alpha: 1];
    
    //// Frames
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
    
    
    //// Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group) + 0.50000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.01064 * CGRectGetHeight(group))];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.01064 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.86170 * CGRectGetHeight(group))];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.50000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.98936 * CGRectGetHeight(group))];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.98936 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.86170 * CGRectGetHeight(group))];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.50000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.01064 * CGRectGetHeight(group))];
        [bezierPath closePath];
        [fillColor2 setFill];
        [bezierPath fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(group) + 0.39362 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.32979 * CGRectGetHeight(group))];
        [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.50000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.28723 * CGRectGetHeight(group))];
        [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.60638 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.32979 * CGRectGetHeight(group))];
        [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.50000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.41489 * CGRectGetHeight(group))];
        [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.39362 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.32979 * CGRectGetHeight(group))];
        [bezier2Path closePath];
        [fillColor3 setFill];
        [bezier2Path fill];
    }


    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.texture = [SKTexture textureWithCGImage:image.CGImage];
}

@end
