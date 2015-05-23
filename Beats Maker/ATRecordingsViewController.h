#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+FX.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ATRecordingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate, AVAudioPlayerDelegate>
{
    UITableView *allRecTable;
    NSMutableArray *rec;
    AVAudioPlayer *audio;
}
@property (nonatomic, strong) UIDocumentInteractionController *docController;
@end
