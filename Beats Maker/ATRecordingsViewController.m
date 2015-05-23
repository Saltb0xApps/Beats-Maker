#import "ATRecordingsViewController.h"
@implementation ATRecordingsViewController
@synthesize docController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*basic view setup*/
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.view.backgroundColor = UIColorFromHex(0x191919);
    
    UILabel *TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, self.view.bounds.size.height)];
    TitleLabel.text = @"Recordings";
    TitleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    TitleLabel.backgroundColor = [UIColor clearColor];
    TitleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = TitleLabel;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setClipsToBounds:YES];
    [self.navigationController.navigationBar setBarTintColor:self.view.backgroundColor];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" /*back*/ style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    back.tintColor = [UIColor whiteColor];
    [back setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"googleicon" size:24.0]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = back;
    
    rec = [[NSMutableArray alloc] initWithArray:[self listCAFFileAtPath:DOCUMENTS_FOLDER]];

    /*main stuff*/
    allRecTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    allRecTable.dataSource = self;
    allRecTable.delegate = self;
    allRecTable.rowHeight = 75;
    allRecTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    allRecTable.backgroundColor = UIColorFromHex(0x191919);
    [self.view addSubview:allRecTable];
}
- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView2 deselectRowAtIndexPath:indexPath animated:NO];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, [rec objectAtIndex:indexPath.row]]]] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (NSMutableArray *)listCAFFileAtPath:(NSString *)path {
    NSMutableArray *directoryContent = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL]];
    for(int i = 0; i<directoryContent.count; i++) {
        if(![[directoryContent objectAtIndex:i] hasSuffix:@".caf"]) /*remove temp .mp4 video file from array, too lazy to do shit properly.*/ {
            [directoryContent removeObjectAtIndex:i];
        }
    }
    return directoryContent;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{ return 1; }
- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section{
    return rec.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
    UIView *backgroundColorView = [[UIView alloc]init];
    backgroundColorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.01];
    cell.selectedBackgroundView = backgroundColorView;
    
    if(tableView2 == allRecTable) {
        cell.imageView.image = [[UIImage imageNamed:@"Play.png"] imageScaledToSize:CGSizeMake(30, 30)]; /*show play button in image view*/
        cell.imageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5]; /*ios 8 bug fix*/
        cell.imageView.layer.cornerRadius = cell.imageView.image.size.width/2;
        cell.imageView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        cell.imageView.layer.borderWidth = 2.5;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.tag = indexPath.row;
        [cell.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playCustomDialogueWithIndex:)]];
        
        cell.textLabel.numberOfLines = 4;
        NSString *movie = [rec objectAtIndex:indexPath.row];
        movie = [movie stringByReplacingOccurrencesOfString:@".caf" withString:@""];
        cell.textLabel.text = movie;
        cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:12];
        
        UIView *separatorLineViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView2.bounds.size.width, 1.5)];
        separatorLineViewTop.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
        [cell.contentView addSubview:separatorLineViewTop];
        
        return cell;
    }
    return cell;
}
- (void)playCustomDialogueWithIndex:(id)sender {
    if(audio) /*kill audio if already exists*/ {
        [audio stop];
        audio = nil;
        return;
    }
    NSString *fileName = [rec objectAtIndex:[sender view].tag];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    audio = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName]] error:nil];
    audio.delegate = self;
    [audio play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == audio) {
        audio = nil;
    }
}

- (void)tableView:(UITableView *)tableView2 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.tintColor = self.view.backgroundColor;
    deleteButton.frame = CGRectMake(cell.bounds.size.width - 35, 0, 25, 25); /*meh*/
    deleteButton.center = CGPointMake(deleteButton.center.x, (cell.bounds.size.height/2)); /*meh part 2*/
    [deleteButton setTitle:@"x" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.01]];
    [deleteButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:15.5]];
    [deleteButton setTag:indexPath.row + 100];
    [deleteButton addTarget:self action:@selector(deleteCustomDialogue:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deleteButton];
}
- (void)deleteCustomDialogue:(UIButton*)sender {
    [[NSFileManager defaultManager] removeItemAtPath:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[rec objectAtIndex:sender.tag - 100]] error:nil];
    [rec removeObjectAtIndex:sender.tag - 100];
    [allRecTable reloadData];
}
- (void)tableView:(UITableView *)tableView2 didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[cell viewWithTag:indexPath.row + 100] removeFromSuperview];
}
- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Unimportant Stuff -
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
- (void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}
- (void)viewDidUnload{ [super viewDidUnload]; }
- (BOOL)canBecomeFirstResponder {return YES;}
- (BOOL)prefersStatusBarHidden {return YES;}
- (BOOL)shouldAutorotate{return YES;}
- (UIStatusBarStyle) preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
- (NSUInteger)supportedInterfaceOrientations{return UIInterfaceOrientationMaskAllButUpsideDown;}
@end
