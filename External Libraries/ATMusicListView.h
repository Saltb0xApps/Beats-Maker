//
//  ATMusicListView.h
//  iMusic
//
//  Created by Akhil Tolani on 02/05/13.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

#import "UIImage+FX.h"
#import "SCLTAudioPlayer.h"
#import "BFPaperButton.h"

@interface ATMusicListView : UIView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *MusicTable;
    UIToolbar *TopBlurView;
    UISearchBar *SongSearchBar;
    
    NSMutableArray *filteredContentList;
    BOOL isSearching;
}
@property (nonatomic, strong) NSArray* songs;

- (void)loadTable;
@end
