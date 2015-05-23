//
//  ATMusicListViewController.m
//  iMusic
//
//  Created by Akhil Tolani on 02/05/13.
//
//

#import "ATMusicListView.h"
@implementation ATMusicListView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *Title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.bounds.size.width, 60)];
        Title.text = @"Select Music";
        Title.textAlignment = NSTextAlignmentCenter;
        Title.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        Title.backgroundColor = [UIColor clearColor];
        Title.font = [UIFont fontWithName:@"Avenir" size:25];
        Title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:Title];
        BFPaperButton *DoneButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(5, 0, 60, 60)];
        [DoneButton setTitle:@"←" forState:UIControlStateNormal]; //back
        DoneButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:25];
        DoneButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        DoneButton.tapCircleColor = [UIColor colorWithWhite:1 alpha:0.5];
        DoneButton.rippleFromTapLocation = YES;
        DoneButton.rippleBeyondBounds = YES;
        DoneButton.isRaised = NO;
        DoneButton.backgroundFadeColor = [UIColor clearColor];
        DoneButton.titleLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1];
        DoneButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [DoneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:DoneButton];
        
        SongSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, Title.frame.origin.y+Title.bounds.size.height+10, self.bounds.size.width, 44)];
        SongSearchBar.searchBarStyle = UISearchBarStyleMinimal;
        SongSearchBar.placeholder = @"Search";
        SongSearchBar.tintColor = [UIColor whiteColor];
        SongSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        SongSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        SongSearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        SongSearchBar.keyboardAppearance = UIKeyboardAppearanceDark;
        SongSearchBar.showsCancelButton = YES;
        SongSearchBar.delegate = self;
        SongSearchBar.keyboardType = UIKeyboardTypeAlphabet;
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithWhite:1 alpha:0.8]];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithWhite:1 alpha:0.8]];
        [self addSubview:SongSearchBar];
        
        TopBlurView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SongSearchBar.bounds.size.height + SongSearchBar.frame.origin.y)];
        TopBlurView.barStyle = UIBarStyleBlackTranslucent;
        TopBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self insertSubview:TopBlurView belowSubview:Title];

        filteredContentList = [[NSMutableArray alloc] init];
        
        self.songs = [[MPMediaQuery songsQuery] items];
    }
    return self;
}
- (void)loadTable {
    if(!MusicTable) {
        MusicTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain] autorelease];
        MusicTable.dataSource = self;
        MusicTable.delegate = self;
        MusicTable.rowHeight = 80;
        MusicTable.contentInset = UIEdgeInsetsMake(SongSearchBar.bounds.size.height + SongSearchBar.frame.origin.y, 0, 0, 0);
        MusicTable.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        MusicTable.alpha = 0;
        [MusicTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [MusicTable setSeparatorColor:[UIColor clearColor]];
        [MusicTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self insertSubview:MusicTable belowSubview:TopBlurView];
        [MusicTable performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
        [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseIn animations:^{
            MusicTable.alpha = 1;
        } completion:nil];
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    isSearching = YES;
    if(searchText.length == 0) {
        [filteredContentList removeAllObjects];
        [filteredContentList addObjectsFromArray:self.songs];
    } else {
        [filteredContentList removeAllObjects];
        for(MPMediaItem *tempStr in self.songs) {
            NSRange nameRange = [[tempStr valueForProperty:MPMediaItemPropertyTitle] rangeOfString:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            if(nameRange.location != NSNotFound) {
                [filteredContentList addObject:tempStr];
            }
        }
    }
    if(filteredContentList.count == 0) {
        [filteredContentList addObject:@"No Songs Found"];
    }
    [MusicTable reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearching = NO;
    [searchBar resignFirstResponder];
}

- (void)SwitchTableData {
    [MusicTable reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        SongSearchBar.alpha = 1;
        MusicTable.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);
        TopBlurView.frame = CGRectMake(0, 0, self.bounds.size.width, SongSearchBar.bounds.size.height + SongSearchBar.frame.origin.y);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching)
        return [filteredContentList count];
    return [self.songs count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:14]];
        [cell.textLabel setHighlightedTextColor:[UIColor blackColor]];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:10]];
        [cell.detailTextLabel setHighlightedTextColor:[UIColor blackColor]];
        [cell.imageView setClipsToBounds:YES];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setOpaque:NO];
    }
    if(self.songs.count == 0) {
        return cell;
    }
    
    MPMediaItemArtwork *artwork = nil;
    if (isSearching) {
        if([[filteredContentList objectAtIndex:indexPath.row] respondsToSelector:NSSelectorFromString(@"valueForProperty:")]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[filteredContentList objectAtIndex:indexPath.row]valueForProperty:MPMediaItemPropertyTitle]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[filteredContentList objectAtIndex:indexPath.row]valueForProperty:MPMediaItemPropertyArtist]];
            artwork = [[filteredContentList objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork];
        } else {
            cell.textLabel.text = @"No Songs Found";
            cell.detailTextLabel.text = @"";
            cell.imageView.image = nil;
            return cell;
        }
    } else {
        cell.textLabel.text =  [[self.songs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle];
        cell.detailTextLabel.text = [[self.songs objectAtIndex:indexPath.row]valueForProperty:MPMediaItemPropertyArtist];
        artwork = [[self.songs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork];
    }
    
    [cell.imageView setImage:[[UIImage imageNamed:@"NoArtworkImage.png"] imageScaledToSize:CGSizeMake(80, 80)]]; /*For the lazy images which take too long and leave the image empty until scrolled*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (!CGSizeEqualToSize(artwork.bounds.size, CGSizeZero)) {
            UIImage *image = [UIImage new];
            image = [[artwork imageWithSize:CGSizeMake(80, 80)] imageScaledToSize:CGSizeMake(80, 80)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.imageView setImage:image];
            });
        }
    });
    artwork = nil;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SongSearchBar resignFirstResponder];
    
    if([[MusicTable cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"No Songs Found"]) {
        return;
    }
    
    NSMutableArray *playlist;
    if(isSearching) {
        playlist = [NSMutableArray arrayWithCapacity:([filteredContentList count] - indexPath.row)];
        for (NSInteger i = indexPath.row; i < [filteredContentList count]; i++) {
            MPMediaItem *song = filteredContentList[i];
            SCLTMediaItem *smi = [[SCLTMediaItem alloc] initWithMediaItem:song];
            [playlist addObject:smi];
        }
    } else {
        playlist = [NSMutableArray arrayWithCapacity:([self.songs count] - indexPath.row)];
        for (NSInteger i = indexPath.row; i < [self.songs count]; i++) {
            MPMediaItem *song = self.songs[i];
            SCLTMediaItem *smi = [[SCLTMediaItem alloc] initWithMediaItem:song];
            [playlist addObject:smi];
        }
    }
    [[SCLTAudioPlayer sharedPlayer] setPlaylist:playlist];
    [[SCLTAudioPlayer sharedPlayer] play];
    [self dismiss];
}
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self release];
    }];
}
- (BOOL)shouldAutorotate { return YES; }
- (NSUInteger)supportedInterfaceOrientations { return UIInterfaceOrientationMaskAll; }
- (BOOL)prefersStatusBarHidden { return YES; }
- (void)dealloc { [super dealloc]; }
@end
