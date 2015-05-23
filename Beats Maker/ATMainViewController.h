#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import <Social/Social.h>
#import <AVFoundation/AVFoundation.h>
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>

#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"
#import "UIImage+FX.h"
#import "SCLAlertView.h"
#import "RZTransitionsManager.h"

#import "ATDrumsViewController.h"
#import "ATIAPAllKitsViewController.h"

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ATMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>
{
    NSArray *slideshowImages;
    
    UICollectionView *drumsCollectionView;
}
@end