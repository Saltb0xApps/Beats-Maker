//
//  ATDrumsViewController.m
//  Beats Maker
//
//  Created by Akhil Tolani on 06/02/15.
//  Copyright (c) 2015 Akhil Tolani. All rights reserved.
//

#import "ATDrumsViewController.h"

@implementation ATDrumsViewController
@synthesize drumKit;
@synthesize audioFile;
@synthesize audioPlot;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*basic view setup*/
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.view.backgroundColor = UIColorFromHex(0x191919);
    
    UILabel *TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, self.view.bounds.size.height)];
    TitleLabel.text = self.drumKit;
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
    
    UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithTitle:@"" /*DropDown*/ style:UIBarButtonItemStylePlain target:self action:@selector(dropDownToggle)];
    dropDown.tintColor = [UIColor whiteColor];
    [dropDown setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"googleicon" size:24.0]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = dropDown;
    
    /*secondary actions*/
    actionsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    actionsScroll.contentSize = CGSizeMake((self.view.bounds.size.width*1.5) + 4, 40);
    actionsScroll.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
    actionsScroll.alpha = 1;
    [actionsScroll setShowsHorizontalScrollIndicator:NO];
    [actionsScroll setShowsVerticalScrollIndicator:NO];
    actionsScroll.clipsToBounds = YES;
    [self.view addSubview:actionsScroll];
    backgroundMusic = [[BFPaperButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 0, (self.view.bounds.size.width*1.5)/4, 40)];
    [backgroundMusic setTitle:@"Background Music" forState:UIControlStateNormal];
    backgroundMusic.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12];
    backgroundMusic.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    backgroundMusic.tapCircleColor = [UIColor colorWithWhite:0.1 alpha:1];
    backgroundMusic.rippleFromTapLocation = YES;
    backgroundMusic.rippleBeyondBounds = NO;
    backgroundMusic.isRaised = NO;
    backgroundMusic.backgroundFadeColor = [UIColor clearColor];
    backgroundMusic.titleLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundMusic setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [backgroundMusic addTarget:self action:@selector(toggleMusic:) forControlEvents:UIControlEventTouchUpInside];
    [actionsScroll addSubview:backgroundMusic];
    BFPaperButton *record = [[BFPaperButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width*1.5)/4 + 1, 0, (self.view.bounds.size.width*1.5)/4, 40)];
    [record setTitle:@"Start Recording" forState:UIControlStateNormal];
    record.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12];
    record.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    record.tapCircleColor = [UIColor colorWithWhite:0.1 alpha:1];
    record.rippleFromTapLocation = YES;
    record.rippleBeyondBounds = NO;
    record.isRaised = NO;
    record.backgroundFadeColor = [UIColor clearColor];
    record.titleLabel.textAlignment = NSTextAlignmentCenter;
    [record setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [record addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [actionsScroll addSubview:record];
    BFPaperButton *share = [[BFPaperButton alloc]initWithFrame:CGRectMake(2*((self.view.bounds.size.width*1.5)/4) + 2, 0, (self.view.bounds.size.width*1.5)/4, 40)];
    [share setTitle:@"Manage Recordings" forState:UIControlStateNormal];
    share.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12];
    share.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    share.tapCircleColor = [UIColor colorWithWhite:0.1 alpha:1];
    share.rippleFromTapLocation = YES;
    share.rippleBeyondBounds = NO;
    share.isRaised = NO;
    share.backgroundFadeColor = [UIColor clearColor];
    share.titleLabel.textAlignment = NSTextAlignmentCenter;
    [share setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(openManager) forControlEvents:UIControlEventTouchUpInside];
    [actionsScroll addSubview:share];
    BFPaperButton *toggleBackgroundBeats = [[BFPaperButton alloc]initWithFrame:CGRectMake(3*((self.view.bounds.size.width*1.5)/4) + 3, 0, (self.view.bounds.size.width*1.5)/4, 40)];
    [toggleBackgroundBeats setTitle:@"Toggle Beats" forState:UIControlStateNormal];
    toggleBackgroundBeats.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12];
    toggleBackgroundBeats.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    toggleBackgroundBeats.tapCircleColor = [UIColor colorWithWhite:0.1 alpha:1];
    toggleBackgroundBeats.rippleFromTapLocation = YES;
    toggleBackgroundBeats.rippleBeyondBounds = NO;
    toggleBackgroundBeats.isRaised = NO;
    toggleBackgroundBeats.backgroundFadeColor = [UIColor clearColor];
    toggleBackgroundBeats.titleLabel.textAlignment = NSTextAlignmentCenter;
    [toggleBackgroundBeats setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [toggleBackgroundBeats addTarget:self action:@selector(toggleBeats) forControlEvents:UIControlEventTouchUpInside];
    [actionsScroll addSubview:toggleBackgroundBeats];
    
    [actionsScroll setContentOffset:CGPointMake(backgroundMusic.bounds.size.width/2, 0) animated:NO];
    [self performSelector:@selector(dropDownToggle) withObject:nil afterDelay:0.25];
    
    /*drum pad*/
    UIView *drumPad = [[UIView alloc] initWithFrame:CGRectMake(30, (self.view.bounds.size.height/2)-((self.view.bounds.size.width-30)/2), self.view.bounds.size.width-60, self.view.bounds.size.width-60)];
    drumPad.layer.cornerRadius = 12;
    drumPad.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    drumPad.clipsToBounds = YES;
    [self.view addSubview:drumPad];
    
    self.audioPlot = [[EZAudioPlotGL alloc] initWithFrame:CGRectMake(0, drumPad.frame.origin.y + drumPad.bounds.size.height + 30, self.view.bounds.size.width, self.view.bounds.size.height - (drumPad.frame.origin.y + drumPad.bounds.size.height + 40))];
    self.audioPlot.backgroundColor = self.view.backgroundColor;
    self.audioPlot.color = [UIColor colorWithWhite:0.25 alpha:1];
    self.audioPlot.plotType = EZPlotTypeRolling;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.gain = 0.75;
    self.audioPlot.shouldMirror = YES;
    self.audioPlot.rollingHistoryLength = 512;
    [self.view addSubview:self.audioPlot];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.audioPlot.frame.origin.y + (self.audioPlot.bounds.size.height/2)-0.75, self.view.bounds.size.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1]; /*haxxx*/
    lineView.tag = 0314;
    [self.view insertSubview:lineView aboveSubview:self.audioPlot];
    
    NSArray *flatColors = [[NSArray alloc]initWithObjects:
                  UIColorFromHex(0x2ecc71), UIColorFromHex(0x1abc9c), UIColorFromHex(0x3498db), UIColorFromHex(0x9b59b6), UIColorFromHex(0x34495e),
                  UIColorFromHex(0x16a085), UIColorFromHex(0x27ae60), UIColorFromHex(0x2980b9), UIColorFromHex(0x8e44ad), UIColorFromHex(0x2c3e50),
                  UIColorFromHex(0xf1c40f), UIColorFromHex(0xe67e22), UIColorFromHex(0xe74c3c), UIColorFromHex(0xc0392b), UIColorFromHex(0xd35400),
                  UIColorFromHex(0xf1c40f), nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    soundsKit = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@/",[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Sounds"],[((UILabel*)self.navigationItem.titleView).text lowercaseString]] error:NULL]];
    int z = 0;
    for(int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [soundButton setTitle:@"" forState:UIControlStateNormal];
            [soundButton setTitle:@"" forState:UIControlStateHighlighted];
            [soundButton.layer setBorderColor:[UIColor colorWithWhite:1 alpha:0.1].CGColor];
            [soundButton.layer setBorderWidth:0.125];
            [soundButton setTag:z];
            UIColor *randomColor = [flatColors objectAtIndex:(arc4random()%flatColors.count)];
            [soundButton setTitleColor:[randomColor colorWithAlphaComponent:1] forState:UIControlStateNormal];
            [soundButton setTitleColor:randomColor forState:UIControlStateHighlighted];
            [soundButton.titleLabel setFont:[UIFont fontWithName:@"googleicon" size:28]];
            [soundButton.titleLabel.layer setShadowColor:randomColor.CGColor];
            [soundButton.titleLabel.layer setShadowOpacity:0.5];
            [soundButton.titleLabel.layer setShadowRadius:5];
            [soundButton.titleLabel.layer setShouldRasterize:YES];
            [soundButton.titleLabel.layer setRasterizationScale:[UIScreen mainScreen].scale];
            [soundButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.01]];
            [soundButton addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchDown];
            [soundButton addTarget:self action:@selector(endSound) forControlEvents:UIControlEventTouchUpInside];
            [soundButton setFrame:CGRectMake(x*(drumPad.bounds.size.width/4), y*(drumPad.bounds.size.width/4), drumPad.bounds.size.width/4, drumPad.bounds.size.width/4)];
            [drumPad addSubview:soundButton];
            z++;
            
            /*number labels*/
            if(y == 3) {
                UILabel *numberLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(drumPad.frame.origin.x + (x*(drumPad.bounds.size.width/4)), drumPad.frame.origin.y-20, drumPad.bounds.size.width/4, 20)];
                numberLabelTop.text = [NSString stringWithFormat:@"%d", x + 1];
                numberLabelTop.textColor = [UIColor colorWithWhite:1 alpha:0.1];
                numberLabelTop.font = [UIFont fontWithName:@"Avenir-Light" size:10];
                numberLabelTop.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:numberLabelTop];
                
                UILabel *numberLabelBottom = [[UILabel alloc] initWithFrame:CGRectMake(drumPad.frame.origin.x + (x*(drumPad.bounds.size.width/4)), drumPad.frame.origin.y+drumPad.bounds.size.height, drumPad.bounds.size.width/4, 20)];
                numberLabelBottom.text = [NSString stringWithFormat:@"%d", x + 1];
                numberLabelBottom.textColor = [UIColor colorWithWhite:1 alpha:0.1];
                numberLabelBottom.font = [UIFont fontWithName:@"Avenir-Light" size:10];
                numberLabelBottom.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:numberLabelBottom];
            }
            
            if(x == 4) { x = 0; break; }
        }
        /*number labels*/
        UILabel *numberLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(drumPad.frame.origin.x - 20, drumPad.frame.origin.y + (y*(drumPad.bounds.size.width/4)), 20, drumPad.bounds.size.height/4)];
        numberLabelLeft.text = [NSString stringWithFormat:@"%d", y + 1];
        numberLabelLeft.textColor = [UIColor colorWithWhite:1 alpha:0.1];
        numberLabelLeft.font = [UIFont fontWithName:@"Avenir-Light" size:10];
        numberLabelLeft.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:numberLabelLeft];
        
        UILabel *numberLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(drumPad.frame.origin.x + drumPad.bounds.size.width, drumPad.frame.origin.y + (y*(drumPad.bounds.size.width/4)), 20, drumPad.bounds.size.height/4)];
        numberLabelRight.text = [NSString stringWithFormat:@"%d", y + 1];
        numberLabelRight.textColor = [UIColor colorWithWhite:1 alpha:0.1];
        numberLabelRight.font = [UIFont fontWithName:@"Avenir-Light" size:10];
        numberLabelRight.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:numberLabelRight];
    }
}
- (void)playSound:(UIButton*)sender {
    self.audioFile = [EZAudioFile audioFileWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/Sounds/%@/%@",[[NSBundle mainBundle] bundlePath],[((UILabel*)self.navigationItem.titleView).text lowercaseString],[soundsKit objectAtIndex:sender.tag]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    self.audioFile.audioFileDelegate = self;

    [[EZOutput sharedOutput] setAudioStreamBasicDescription:self.audioFile.clientFormat];
    
    [[EZOutput sharedOutput] setOutputDataSource:self];
    [[EZOutput sharedOutput] startPlayback];
}
- (void)endSound {
    [[EZOutput sharedOutput] stopPlayback];
}
-(void)audioFile:(EZAudioFile *)audioFile readAudio:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([EZOutput sharedOutput].isPlaying){
            [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        }
    });
}
-(void)output:(EZOutput *)output shouldFillAudioBufferList:(AudioBufferList *)audioBufferList withNumberOfFrames:(UInt32)frames {
    if( self.audioFile ) {
        UInt32 bufferSize;
        BOOL test;
        [self.audioFile readFrames:frames audioBufferList:audioBufferList bufferSize:&bufferSize eof:&test];
    }
}
- (AudioStreamBasicDescription)outputHasAudioStreamBasicDescription:(EZOutput *)output {
    return self.audioFile.clientFormat;
}
- (void)openManager {
    ATRecordingsViewController *vc2 = [[ATRecordingsViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc2 animated:YES];
}
- (void)toggleBeats {
    if(beats.isPlaying) {
        [beats stop];
    } else {
        beats = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/metronom.mp3",[[NSBundle mainBundle] bundlePath]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] error:nil];
        beats.numberOfLoops = -1;
        beats.delegate = self;
        [beats play];
    }
}
- (void)toggleMusic:(BFPaperButton*)sender {
    if ([[SCLTAudioPlayer sharedPlayer] isPlaying]) {
        [[SCLTAudioPlayer sharedPlayer] pause];
    } else {
        ATMusicListView *allSongs = [[ATMusicListView alloc] initWithFrame:CGRectMake(0, 0, self.view.window.bounds.size.width, self.view.window.bounds.size.height)];
        allSongs.alpha = 0;
        allSongs.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        [allSongs loadTable];
        [self.view.window addSubview:allSongs];
        [UIView animateWithDuration:0.25 animations:^{
            allSongs.alpha = 1;
        }];
    }
}
- (void)startRecording:(BFPaperButton*)sender {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
    
    if(recorder) {
        [recorder stop];
        [recorder release];
        recorder = nil;
    }
    
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, [NSDate date]]] settings:recordSetting error:nil];
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    [recordSetting release];
    
    [sender removeTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
    [sender setTitle:@"End Recording" forState:UIControlStateNormal];
    [recorder record];
}
- (void)stopRecording:(BFPaperButton*)sender {
    [sender removeTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [sender setTitle:@"Start New Recording" forState:UIControlStateNormal];
    [recorder stop];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
- (void)dropDownToggle {
    if(actionsScroll.frame.size.height == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [actionsScroll setFrame:CGRectMake(actionsScroll.frame.origin.x, actionsScroll.frame.origin.y, self.view.bounds.size.width, 40)];
        }];
        UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithTitle:@"" /*DropUp*/ style:UIBarButtonItemStylePlain target:self action:@selector(dropDownToggle)];
        dropDown.tintColor = [UIColor whiteColor];
        [dropDown setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"googleicon" size:24.0]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = dropDown;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [actionsScroll setFrame:CGRectMake(actionsScroll.frame.origin.x, actionsScroll.frame.origin.y, self.view.bounds.size.width, 0)];
        }];
        UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithTitle:@"" /*DropDown*/ style:UIBarButtonItemStylePlain target:self action:@selector(dropDownToggle)];
        dropDown.tintColor = [UIColor whiteColor];
        [dropDown setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"googleicon" size:24.0]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = dropDown;
    }
}
- (void)dismiss {
    if(recorder) {
        [recorder stop];
        [recorder release];
        recorder = nil;
    }
    
    [beats stop];
    
    [[SCLTAudioPlayer sharedPlayer] pause];

    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setClipsToBounds:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
#pragma mark - Unimportant Stuff -
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    if(recorder) {
        [recorder stop];
        [recorder release];
        recorder = nil;
    }
    
    [beats stop];
    
    [[SCLTAudioPlayer sharedPlayer] pause];
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
- (void)dealloc { [super dealloc]; }
- (BOOL)canBecomeFirstResponder {return YES;}
- (BOOL)prefersStatusBarHidden {return YES;}
- (BOOL)shouldAutorotate{return YES;}
- (UIStatusBarStyle) preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
- (NSUInteger)supportedInterfaceOrientations{return UIInterfaceOrientationMaskAllButUpsideDown;}
@end
