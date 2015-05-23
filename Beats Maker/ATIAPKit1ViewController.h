#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "BFPaperButton.h"
#import "SCLAlertView.h"

@interface ATIAPKit1ViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    UIScrollView *scrollView;
    
    SCLAlertView *SendingReqAlert;
    SCLAlertView *ReceivedReqAlert;
    SCLAlertView *TransactionSuccessfulAlert;
    SCLAlertView *TransactionFailedAlert;
    SCLAlertView *RestoredPurchaseAlert;
    BFPaperButton *PurchaseButton;
    BFPaperButton *RestoreButton;
}
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@end
