//
//  SCLTAudioPlayerNotifications.h
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-04-05.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLTAudioPlayerNotifications : NSObject


extern NSString* const SCLTAudioPlayerError;
extern NSString* const SCLTAudioPlayerInterruptionBegan;
extern NSString* const SCLTAudioPlayerInterruptionEnded;

extern NSString* const SCLTAudioPlayerDidPlay;
extern NSString* const SCLTAudioPlayerDidPause;
extern NSString* const SCLTAudioPlayerDidSetPlaylist;
extern NSString* const SCLTAudioPlayerWillAdvancePlaylist;
extern NSString* const SCLTAudioPlayerDidAdvancePlaylist;
extern NSString* const SCLTAudioPlayerWillReversePlaylist;
extern NSString* const SCLTAudioPlayerDidReversePlaylist;

@end
