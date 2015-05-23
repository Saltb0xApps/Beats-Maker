//
//  SCLTMediaItem.m
//  AudioPlayer
//
//  Created by Christopher Baltzer on 2014-04-05.
//  Copyright (c) 2014 Scarlet. All rights reserved.
//

#import "SCLTMediaItem.h"

@implementation SCLTMediaItem

-(instancetype)initWithMediaItem:(MPMediaItem*)item; {
    NSURL* url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    SCLTMediaItem* media = [[SCLTMediaItem alloc] initWithURL:url];
    media.mediaItem = item;
    return media;
}

-(instancetype)initWithURL:(NSURL *)url {
    SCLTMediaItem* mediaItem = [[SCLTMediaItem alloc] init];
    mediaItem.assetURL = url;
    return mediaItem;
}

@end
