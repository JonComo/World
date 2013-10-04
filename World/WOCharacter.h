//
//  MJCharacter.h
//  MazeJump
//
//  Created by Jon Como on 9/25/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "WOObject.h"

@interface WOCharacter : WOObject

-(void)runInDirection:(float)direction intensity:(float)intensity;
-(void)jump;

@end