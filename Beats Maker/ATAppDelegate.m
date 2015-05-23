#import "ATAppDelegate.h"

@implementation ATAppDelegate
@synthesize window = window;
@synthesize mainViewController = mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    id<RZAnimationControllerProtocol> presentDismissAnimationController = [[RZCirclePushAnimationController alloc] init];
    id<RZAnimationControllerProtocol> pushPopAnimationController = [[RZZoomPushAnimationController alloc] init];
    [[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:presentDismissAnimationController];
    [[RZTransitionsManager shared] setDefaultPushPopAnimationController:pushPopAnimationController];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ATMainViewController alloc] initWithNibName:nil bundle:nil]];
    [navigationController setDelegate:[RZTransitionsManager shared]];
    [navigationController.navigationBar setTranslucent:YES];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.mainViewController = [[[ATMainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = UIColorFromHex(0x151515);
    self.window.layer.cornerRadius = 7.5;
    self.window.layer.masksToBounds = YES;
    self.window.layer.shouldRasterize = YES;
    self.window.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.window makeKeyAndVisible];

    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    return YES;
}
+ (void)initialize {
    [iRate sharedInstance].usesUntilPrompt = 3;
    [iRate sharedInstance].daysUntilPrompt = 2;
}
- (void)applicationWillTerminate:(UIApplication *)application {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*2];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = @"Be the life of the party!";
    localNotification.alertAction = @"Launch Beats Maker";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
@end