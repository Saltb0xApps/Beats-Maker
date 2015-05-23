//
//  SCLTAudioPlayerDelegate.h
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-04-05.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLTAudioPlayer.h"

@class SCLTMediaItem, SCLTAudioPlayer;

@protocol SCLTAudioPlayerDelegate <NSObject>

-(void)playerDidPlay:(SCLTAudioPlayer*)player;
-(void)playerDidPause:(SCLTAudioPlayer*)player;

-(void)player:(SCLTAudioPlayer*)player willAdvancePlaylist:(SCLTMediaItem*)currentItem atPoint:(double)normalizedTime;

-(void)player:(SCLTAudioPlayer*)player willReversePlaylist:(SCLTMediaItem*)currentItem atPoint:(double)normalizedTime;

-(void)player:(SCLTAudioPlayer*)player didAdvancePlaylist:(SCLTMediaItem*)newItem;
-(void)player:(SCLTAudioPlayer*)player didReversePlaylist:(SCLTMediaItem*)newItem;

@end
