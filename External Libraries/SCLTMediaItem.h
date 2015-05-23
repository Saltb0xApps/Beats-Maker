//
//  SCLTMediaItem.h
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-04-05.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SCLTMediaItem : NSObject

@property (nonatomic, strong) NSURL* assetURL;
@property (nonatomic, strong) MPMediaItem* mediaItem;

-(instancetype)initWithMediaItem:(MPMediaItem*)item;
-(instancetype)initWithURL:(NSURL*)url;


@end
