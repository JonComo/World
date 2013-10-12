//
//  RRAudioEngine.h
//  RatRace
//
//  Created by Jon Como on 9/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import "RRAudioPlayer.h"

#define MUTE_MUSIC @"muteMusic"

@interface RRAudioEngine : NSObject

@property BOOL muted;

+(RRAudioEngine *)sharedEngine;

-(void)initializeAudioSession;

-(RRAudioPlayer *)playSoundNamed:(NSString *)soundName volume:(float)volume loop:(BOOL)loop;
-(void)stopSoundName:(NSString *)soundName;

-(void)stopAllSounds;

-(void)mute:(BOOL)mute;

-(void)toggleMusic;
-(BOOL)musicMuted;

@end
