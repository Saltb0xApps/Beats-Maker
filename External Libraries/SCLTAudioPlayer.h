//
//  SCLTAudioPlayer.h
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-03-30.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SCLTAudioPlayerDelegate.h"
#import "SCLTMediaItem.h"
#import "SCLTAudioPlayerNotifications.h"

@interface SCLTAudioPlayer : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, weak) id<SCLTAudioPlayerDelegate> delegate;

/// The current playlist as an NSArray of SCLTMediaItems
@property (nonatomic, strong) NSArray *playlist;

/// The currently loaded item
@property (nonatomic, strong) SCLTMediaItem *currentItem;

/// The current index of the playlist
@property (nonatomic, assign) NSInteger currentIndex;

/// Is an item currently playing?
@property (nonatomic, assign, readonly) BOOL isPlaying;

/// visualiser and stuff
@property (nonatomic, strong) AVAudioPlayer *player;



+(SCLTAudioPlayer*)sharedPlayer;


/// Play the currently loaded item
-(void)play;

/// Pause playback
-(void)pause;

/// Play if not already playing, otherwise pause
-(void)togglePlayPause;

/// Play the previous item in the playlist
-(void)previous;

/// Play the next item in the playlist
-(void)next;


-(void)handleRemoteControlEvent:(UIEvent*)receivedEvent;

@end
