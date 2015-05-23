#import "ATIAPAllKitsViewController.h"

#define kAllDrumsProductIdentifier @"com.Saltb0xApps.BeatsMaker.AllDrums"

@implementation ATIAPAllKitsViewController
@synthesize productsRequest = productsRequest;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithWhite:0.11 alpha:1];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    UILabel *Title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 20, 60)];
    Title.text = @"Unlock All Drum Kits";
    Title.textAlignment = NSTextAlignmentRight;
    Title.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    Title.backgroundColor = [UIColor clearColor];
    Title.font = [UIFont fontWithName:@"Avenir" size:25];
    Title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [scrollView addSubview:Title];
    BFPaperButton *DoneButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [DoneButton setTitle:@"←" forState:UIControlStateNormal];
    DoneButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:25];
    DoneButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    DoneButton.tapCircleColor = [UIColor colorWithWhite:1 alpha:0.5];
    DoneButton.rippleFromTapLocation = YES;
    DoneButton.rippleBeyondBounds = YES;
    DoneButton.isRaised = NO;
    DoneButton.backgroundFadeColor = [UIColor clearColor];
    DoneButton.titleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    DoneButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [DoneButton addTarget:self action:@selector(Dismiss) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:DoneButton];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon180x180.png"]]; // this is required because we cant add shadow and corner radius on the same view together
    icon.frame = CGRectMake(0, 0, 60, 60);
    icon.layer.cornerRadius = 14;
    icon.layer.masksToBounds = YES;
    UIView *iconShadowView = [[UIView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)-(icon.frame.size.width/2), 80 , icon.frame.size.width, icon.frame.size.height)];
    iconShadowView.layer.shadowOffset = CGSizeMake(0, 0);
    iconShadowView.layer.shadowOpacity = 0.5;
    iconShadowView.layer.shadowRadius = 5;
    iconShadowView.layer.shouldRasterize = YES;
    iconShadowView.layer.rasterizationScale = [[UIScreen mainScreen]scale];
    iconShadowView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [iconShadowView addSubview:icon];
    [scrollView addSubview:iconShadowView];
    
    UILabel *FAQLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, iconShadowView.frame.origin.y + iconShadowView.bounds.size.height + 10, self.view.bounds.size.width - 40, 350 /*arbitrary*/)];
    FAQLabel.textColor =  [UIColor colorWithWhite:0.9 alpha:1];
    FAQLabel.font =  [UIFont fontWithName:@"Avenir" size:14];
    FAQLabel.numberOfLines = 0;
    FAQLabel.textAlignment = NSTextAlignmentCenter;
    FAQLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    FAQLabel.text = @"How To Unlock All Drum Kits?\n\nAs you must have noticed, some of the drum sets are locked. To unlock all these, you will need to purchase this In-App. This will unlock all 3 drum kits, each consisting of 5 drum sets making a total of 15 drum sets.\n\nYou can also purchase individual kits (each consisting of 5 drum sets) at lower prices by selecting the corresponding buttons below.";
    [scrollView addSubview:FAQLabel];
    
    /*buttons*/
    PurchaseButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, FAQLabel.bounds.size.height + FAQLabel.frame.origin.y + 10, self.view.bounds.size.width, 40)];
    PurchaseButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    PurchaseButton.layer.borderWidth = 1;
    PurchaseButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    PurchaseButton.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:143.0/255.0f blue:255.0f/255.0f alpha:1];
    PurchaseButton.tapCircleColor = [UIColor colorWithWhite:0 alpha:0.25];
    PurchaseButton.rippleFromTapLocation = YES;
    PurchaseButton.rippleBeyondBounds = NO;
    PurchaseButton.isRaised = YES;
    PurchaseButton.backgroundFadeColor = [UIColor clearColor];
    PurchaseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    PurchaseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [PurchaseButton addTarget:self action:@selector(PurchaseAllEx) forControlEvents:UIControlEventTouchUpInside];
    [PurchaseButton setTitle:@"Unlock All Drum Kits (3.99$)" forState:UIControlStateNormal];
    [PurchaseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [scrollView addSubview:PurchaseButton];
 
    Kit1PurchaseButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, PurchaseButton.bounds.size.height + PurchaseButton.frame.origin.y + 10, self.view.bounds.size.width, 40)];
    Kit1PurchaseButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    Kit1PurchaseButton.layer.borderWidth = 1;
    Kit1PurchaseButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    Kit1PurchaseButton.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:143.0/255.0f blue:255.0f/255.0f alpha:1];
    Kit1PurchaseButton.tapCircleColor = [UIColor colorWithWhite:0 alpha:0.25];
    Kit1PurchaseButton.rippleFromTapLocation = YES;
    Kit1PurchaseButton.rippleBeyondBounds = NO;
    Kit1PurchaseButton.isRaised = YES;
    Kit1PurchaseButton.backgroundFadeColor = [UIColor clearColor];
    Kit1PurchaseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    Kit1PurchaseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [Kit1PurchaseButton addTarget:self action:@selector(Launch1) forControlEvents:UIControlEventTouchUpInside];
    [Kit1PurchaseButton setTitle:@"Drum Kit 1 (1.99$)" forState:UIControlStateNormal];
    [Kit1PurchaseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [scrollView addSubview:Kit1PurchaseButton];
    Kit2PurchaseButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, Kit1PurchaseButton.bounds.size.height + Kit1PurchaseButton.frame.origin.y + 10, self.view.bounds.size.width, 40)];
    Kit2PurchaseButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    Kit2PurchaseButton.layer.borderWidth = 1;
    Kit2PurchaseButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    Kit2PurchaseButton.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:143.0/255.0f blue:255.0f/255.0f alpha:1];
    Kit2PurchaseButton.tapCircleColor = [UIColor colorWithWhite:0 alpha:0.25];
    Kit2PurchaseButton.rippleFromTapLocation = YES;
    Kit2PurchaseButton.rippleBeyondBounds = NO;
    Kit2PurchaseButton.isRaised = YES;
    Kit2PurchaseButton.backgroundFadeColor = [UIColor clearColor];
    Kit2PurchaseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    Kit2PurchaseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [Kit2PurchaseButton addTarget:self action:@selector(Launch2) forControlEvents:UIControlEventTouchUpInside];
    [Kit2PurchaseButton setTitle:@"Drum Kit 2 (1.99$)" forState:UIControlStateNormal];
    [Kit2PurchaseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [scrollView addSubview:Kit2PurchaseButton];
    Kit3PurchaseButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, Kit2PurchaseButton.bounds.size.height + Kit2PurchaseButton.frame.origin.y + 10, self.view.bounds.size.width, 40)];
    Kit3PurchaseButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    Kit3PurchaseButton.layer.borderWidth = 1;
    Kit3PurchaseButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    Kit3PurchaseButton.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:143.0/255.0f blue:255.0f/255.0f alpha:1];
    Kit3PurchaseButton.tapCircleColor = [UIColor colorWithWhite:0 alpha:0.25];
    Kit3PurchaseButton.rippleFromTapLocation = YES;
    Kit3PurchaseButton.rippleBeyondBounds = NO;
    Kit3PurchaseButton.isRaised = YES;
    Kit3PurchaseButton.backgroundFadeColor = [UIColor clearColor];
    Kit3PurchaseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    Kit3PurchaseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [Kit3PurchaseButton addTarget:self action:@selector(Launch3) forControlEvents:UIControlEventTouchUpInside];
    [Kit3PurchaseButton setTitle:@"Drum Kit 3 (1.99$)" forState:UIControlStateNormal];
    [Kit3PurchaseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [scrollView addSubview:Kit3PurchaseButton];
    
    RestoreButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(20, Kit3PurchaseButton.frame.origin.y + Kit3PurchaseButton.bounds.size.height + 10, self.view.bounds.size.width - 40, 40)];
    [RestoreButton setTitle:@"Restore Purchases" forState:UIControlStateNormal];
    RestoreButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16];
    RestoreButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    RestoreButton.tapCircleColor = [UIColor colorWithWhite:0.1 alpha:1];
    RestoreButton.rippleFromTapLocation = YES;
    RestoreButton.rippleBeyondBounds = NO;
    RestoreButton.isRaised = NO;
    RestoreButton.backgroundFadeColor = [UIColor clearColor];
    RestoreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    RestoreButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [RestoreButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [RestoreButton addTarget:self action:@selector(RestorePurchases) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:RestoreButton];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}
- (void)RestorePurchases {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)PurchaseAllEx {
    SendingReqAlert = [[SCLAlertView alloc] init];
    SendingReqAlert.hideAnimationType = SlideOutToBottom;
    SendingReqAlert.showAnimationType = SlideInFromTop;
    SendingReqAlert.backgroundType = Shadow;
    SendingReqAlert.shouldDismissOnTapOutside = YES;
    [SendingReqAlert showInfo:self title:@"Getting Things Started" subTitle:@"Beats Maker is processing information & contacting Apple's servers, please wait." closeButtonTitle:nil duration:0];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kAllDrumsProductIdentifier]];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}
- (void)Launch1 {
    ATIAPKit1ViewController *VC = [[ATIAPKit1ViewController alloc]initWithNibName:nil bundle:nil];
    VC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:VC animated:YES completion:nil];
}
- (void)Launch2 {
    ATIAPKit2ViewController *VC = [[ATIAPKit2ViewController alloc]initWithNibName:nil bundle:nil];
    VC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:VC animated:YES completion:nil];
}
- (void)Launch3 {
    ATIAPKit3ViewController *VC = [[ATIAPKit3ViewController alloc]initWithNibName:nil bundle:nil];
    VC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:VC animated:YES completion:nil];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [SendingReqAlert hideView];
    SKProduct *validProduct = [response.products objectAtIndex:0];
    [self purchase:validProduct];
}
- (void)purchase:(SKProduct *)product{
    ReceivedReqAlert = [[SCLAlertView alloc] init];
    ReceivedReqAlert.shouldDismissOnTapOutside = NO;
    ReceivedReqAlert.hideAnimationType = SlideOutToBottom;
    ReceivedReqAlert.showAnimationType = SlideInFromTop;
    ReceivedReqAlert.backgroundType = Shadow;
    [ReceivedReqAlert showInfo:self title:@"Received Response" subTitle:@"Beats Maker is now processing the response & will now guide you to the next step" closeButtonTitle:@"Okay" duration:0];
    [ReceivedReqAlert alertIsDismissed:^{
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }];
    }
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateDeferred:
                break;
            case SKPaymentTransactionStatePurchased:
                TransactionSuccessfulAlert = [[SCLAlertView alloc] init];
                TransactionSuccessfulAlert.hideAnimationType = SlideOutToBottom;
                TransactionSuccessfulAlert.showAnimationType = SlideInFromTop;
                TransactionSuccessfulAlert.backgroundType = Shadow;
                [TransactionSuccessfulAlert showSuccess:self title:@"Transaction Successful" subTitle:@"You can now select all locked drums" closeButtonTitle:@"Okay" duration:0];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self EnableAllDrums];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self EnableAllDrums];
                break;
            case SKPaymentTransactionStateFailed:
                TransactionFailedAlert = [[SCLAlertView alloc] init];
                TransactionFailedAlert.hideAnimationType = SlideOutToBottom;
                TransactionFailedAlert.showAnimationType = SlideInFromTop;
                TransactionFailedAlert.backgroundType = Shadow;
                [TransactionFailedAlert showError:self title:@"Error" subTitle:@"Transaction failed for some reason. Please try again later." closeButtonTitle:@"Okay" duration:0];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    for (SKPaymentTransaction *transaction in queue.transactions) {
        if(SKPaymentTransactionStateRestored) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Transaction Restored" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [self EnableAllDrums];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}
- (void)EnableAllDrums {
    [[NSUserDefaults standardUserDefaults] setObject:@"Yep" forKey:@"Kit1Unlocked"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Yep" forKey:@"Kit2Unlocked"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Yep" forKey:@"Kit3Unlocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Useless Stuff
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
- (void)viewWillDisappear:(BOOL)animated { [[SKPaymentQueue defaultQueue] removeTransactionObserver:self]; }
- (void)viewDidLayoutSubviews { scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, RestoreButton.bounds.size.height + RestoreButton.frame.origin.y + 10); }
- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }
- (void)Dismiss {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController.navigationBar setHidden:NO];
}
- (BOOL)prefersStatusBarHidden { return YES; }
- (BOOL)shouldAutorotate { return YES; }
- (NSUInteger)supportedInterfaceOrientations { return UIInterfaceOrientationMaskAllButUpsideDown; }
@end