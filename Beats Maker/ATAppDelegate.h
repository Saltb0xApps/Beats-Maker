#import <UIKit/UIKit.h>

#import "ATMainViewController.h"

#import "iRate.h"
#import "RZTransitionsManager.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZAnimationControllerProtocol.h"
#import "RZCirclePushAnimationController.h"
#import "RZRectZoomAnimationController.h"

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@class MainViewController;
@interface ATAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ATMainViewController *mainViewController;
@end