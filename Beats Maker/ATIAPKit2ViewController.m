#import "ATIAPKit2ViewController.h"

#define kKit2ProductIdentifier @"com.Saltb0xApps.BeatsMaker.kit2"

@implementation ATIAPKit2ViewController
@synthesize productsRequest = productsRequest;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.11 alpha:1];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    UILabel *Title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 20, 60)];
    Title.text = @"Unlock Drum Kit 2";
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
    
    UILabel *FAQLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, iconShadowView.frame.origin.y + iconShadowView.bounds.size.height + 10, self.view.bounds.size.width - 40, 150 /*arbitrary*/)];
    FAQLabel.textColor =  [UIColor colorWithWhite:0.9 alpha:1];
    FAQLabel.font =  [UIFont fontWithName:@"Avenir" size:14];
    FAQLabel.numberOfLines = 0;
    FAQLabel.textAlignment = NSTextAlignmentCenter;
    FAQLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    FAQLabel.text = @"This In-App purchase will unlock Drum kit 2 which contains funk, fusion, garage, groove & indie drums";
    [scrollView addSubview:FAQLabel];
    
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
    [PurchaseButton addTarget:self action:@selector(PurchaseEx) forControlEvents:UIControlEventTouchUpInside];
    [PurchaseButton setTitle:@"Unlock Drum Kit 2 (1.99$)" forState:UIControlStateNormal];
    [PurchaseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [scrollView addSubview:PurchaseButton];
    
    RestoreButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(20, PurchaseButton.frame.origin.y + PurchaseButton.bounds.size.height + 10, self.view.bounds.size.width - 40, 40)];
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
- (void)PurchaseEx {
    SendingReqAlert = [[SCLAlertView alloc] init];
    SendingReqAlert.hideAnimationType = SlideOutToBottom;
    SendingReqAlert.showAnimationType = SlideInFromTop;
    SendingReqAlert.backgroundType = Shadow;
    SendingReqAlert.shouldDismissOnTapOutside = YES;
    [SendingReqAlert showInfo:self title:@"Getting Things Started" subTitle:@"Beats Maker is processing information & contacting Apple's servers, please wait." closeButtonTitle:nil duration:0];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kKit2ProductIdentifier]];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
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
                [TransactionSuccessfulAlert showSuccess:self title:@"Transaction Successful" subTitle:@"You can now select funk, fusion, garage, groove & indie drums" closeButtonTitle:@"Okay" duration:0];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self EnableExercise];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self EnableExercise];
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
            [self EnableExercise];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}
- (void)EnableExercise {
    [[NSUserDefaults standardUserDefaults] setObject:@"Yep" forKey:@"Kit2Unlocked"];
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
- (void)Dismiss { [self dismissViewControllerAnimated:YES completion:nil]; }
- (BOOL)prefersStatusBarHidden { return YES; }
- (BOOL)shouldAutorotate { return YES; }
- (NSUInteger)supportedInterfaceOrientations { return UIInterfaceOrientationMaskAllButUpsideDown; }
@end