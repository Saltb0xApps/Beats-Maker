#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "EZAudio.h"
#import "BFPaperButton.h"
#import "ATMusicListView.h"
#import "SCLTAudioPlayer.h"

#import "ATRecordingsViewController.h"

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface ATDrumsViewController : UIViewController <EZAudioFileDelegate, EZOutputDataSource, EZAudioPlayerDelegate, MPMediaPickerControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIDocumentInteractionControllerDelegate>
{
    BFPaperButton *backgroundMusic;
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *beats;
    
    NSMutableArray *soundsKit;
    
    UIScrollView *actionsScroll;
    
    BOOL backgroundBeats;
}
@property (nonatomic, retain) NSString *drumKit;
@property (nonatomic, strong) EZAudioFile *audioFile;
@property (nonatomic, strong) EZAudioPlotGL *audioPlot;
@end
