#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "BFPaperButton.h"
#import "SCLAlertView.h"

#import "ATIAPKit1ViewController.h"
#import "ATIAPKit2ViewController.h"
#import "ATIAPKit3ViewController.h"

@interface ATIAPAllKitsViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    UIScrollView *scrollView;
        
    SCLAlertView *SendingReqAlert;
    SCLAlertView *ReceivedReqAlert;
    SCLAlertView *TransactionSuccessfulAlert;
    SCLAlertView *TransactionFailedAlert;
    SCLAlertView *RestoredPurchaseAlert;
    
    BFPaperButton *PurchaseButton;
    BFPaperButton *Kit1PurchaseButton;
    BFPaperButton *Kit2PurchaseButton;
    BFPaperButton *Kit3PurchaseButton;
    BFPaperButton *RestoreButton;
}
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@end