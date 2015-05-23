//
//  SCLTAudioPlayer.m
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-03-30.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import "SCLTAudioPlayer.h"



@implementation SCLTAudioPlayer

+(SCLTAudioPlayer*)sharedPlayer {
    static dispatch_once_t onceToken;
    static SCLTAudioPlayer *sharedPlayer = nil;
    dispatch_once(&onceToken, ^{
        sharedPlayer = [[SCLTAudioPlayer alloc] init];
    });
    return sharedPlayer;
}

-(instancetype) init {
    if (self = [super init]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        _isPlaying = NO;
    }
    return self;
}



#pragma mark - Player Controls

-(void)play {
    _isPlaying = YES;
    [self.player play];
    
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    [strongDelegate playerDidPlay:self];
    
    [self postNotification:SCLTAudioPlayerDidPlay];
    [self updateSystemControls];
}

-(void)pause {
    _isPlaying = NO;
    [self.player pause];
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    [strongDelegate playerDidPause:self];
    
    [self postNotification:SCLTAudioPlayerDidPause];
    [self updateSystemControls];
}

-(void)togglePlayPause {
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

-(void)previous {
    [self reversePlaylist];
}

-(void)next {
    [self advancePlaylist];
}


#pragma mark - Playlist Management

-(void)playItem:(SCLTMediaItem*)item {
    NSError *error;
    if (self.player) {
        self.player.delegate = nil;
        self.player = nil;
    }
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:item.assetURL error:&error];
    self.currentItem = item;
    self.player.delegate = self;
    [self.player setMeteringEnabled:YES];
    
    if (error) {
        NSLog(@"SCLTAudioPlayer: error playing item!");
        [self postNotification:SCLTAudioPlayerError];
        self.player.delegate = nil;
        self.player = nil;
        _isPlaying = NO;
        return;
    }
    
    if (self.isPlaying) {
        [self play];
    }
    
    [self updateSystemControls];
}


-(void)advancePlaylist {
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    
    double time = self.player.currentTime / self.player.duration;
    // currentTime is 0 if the track reaches the end and stops playing
    if (time == 0) {
        time = 1.0;
    }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"RepeatSong"]) {
        SCLTMediaItem *repeatItem = self.playlist[self.currentIndex];
        [self playItem:repeatItem];
        [strongDelegate player:self didAdvancePlaylist:repeatItem];
    } else {
        [strongDelegate player:self willAdvancePlaylist:self.currentItem atPoint:time];
        [self postNotification:SCLTAudioPlayerWillAdvancePlaylist];
        self.currentIndex = self.currentIndex + 1;
        SCLTMediaItem *nextItem = self.playlist[self.currentIndex];
        [self playItem:nextItem];
        [strongDelegate player:self didAdvancePlaylist:nextItem];
    }
    [self postNotification:SCLTAudioPlayerDidAdvancePlaylist];
}


-(void)reversePlaylist {
    id<SCLTAudioPlayerDelegate> strongDelegate = self.delegate;
    
    double time = self.player.currentTime / self.player.duration;
    [strongDelegate player:self willReversePlaylist:self.currentItem atPoint:time];
    [self postNotification:SCLTAudioPlayerWillReversePlaylist];
    
    self.currentIndex = self.currentIndex - 1;
    SCLTMediaItem *nextItem = self.playlist[self.currentIndex];
    [self playItem:nextItem];
    
    [strongDelegate player:self didReversePlaylist:nextItem];
    [self postNotification:SCLTAudioPlayerDidReversePlaylist];
}


-(void)setPlaylist:(NSArray *)playlist {
    _playlist = playlist;
    if ([playlist count] > 0) {
        self.currentItem = playlist[0];
        self.currentIndex = 0;
        
        [self playItem:self.currentItem];

        [self updateSystemControls];
    }
}


-(void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (!self.playlist) {
        _currentIndex = 0;
        [self postNotification:SCLTAudioPlayerError];
        return;
    }
    
    // count is unsigned so -1 ( returns true for currentIndex > count
    // need to make sure it's also > 0
    if (currentIndex >= 0 && currentIndex >= [self.playlist count]) {
        // reached the end so loop to beginning
        _currentIndex = 0;
    } else if (currentIndex < 0) {
        // at the beginning, loop to end
        _currentIndex = [self.playlist count]-1;
    } else {
        // go to the specified index
        _currentIndex = currentIndex;
    }
    
    [self postNotification:SCLTAudioPlayerDidSetPlaylist];
}


#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self advancePlaylist];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [self postNotification:SCLTAudioPlayerInterruptionBegan];
    [player pause];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    [self postNotification:SCLTAudioPlayerInterruptionEnded];
    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        [player play];
    }
}


#pragma mark - System bindings

-(void)handleRemoteControlEvent:(UIEvent*)receivedEvent{
    if (receivedEvent.type == UIEventTypeRemoteControl){
        switch (receivedEvent.subtype){
            case UIEventSubtypeRemoteControlPause:
                [self pause];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self play];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self togglePlayPause];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previous];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self next];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                break;
            default:
                break;
        }
    }
}

-(void)updateSystemControls{
    if (!self.currentItem.mediaItem) {
        return;
    }
    
    MPMediaItem* currentItem = self.currentItem.mediaItem;
    MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
    MPMediaItemArtwork *artwork2 = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:@"NoArtworkImage.png"]];
    NSDictionary *nowPlayingInfo = @{MPMediaItemPropertyTitle:[currentItem valueForKey:MPMediaItemPropertyTitle],
                                     MPMediaItemPropertyArtist:[currentItem valueForKey:MPMediaItemPropertyArtist],
                                     MPMediaItemPropertyArtwork:(CGSizeEqualToSize(artwork.bounds.size, CGSizeZero))?artwork2:artwork,
                                     MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithDouble:self.player.duration],
                                     MPNowPlayingInfoPropertyElapsedPlaybackTime:[NSNumber numberWithDouble:self.player.currentTime],
                                     MPNowPlayingInfoPropertyPlaybackRate:@1.0};
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
}



#pragma mark - Util

-(void)postNotification:(NSString*)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}



@end