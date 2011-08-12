#import "IAPTransactionObserver.h"

@implementation IAPTransactionObserver

@synthesize available = availability_;

- (id)initWithProductIdPrefix:(NSString *)prefix {
    if ((self = [super init])) {
        productIdPrefix_ = [[prefix stringByAppendingString:@"."] retain];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        availability_ = [SKPaymentQueue canMakePayments];
    }
    return self;
}

- (void)dealloc {
    [productIdPrefix_ release];
    [super dealloc];
}

#pragma mark - Property

- (BOOL)processing {
    return [SKPaymentQueue defaultQueue].transactions.count > 0;
}

#pragma mark - Common Payment Function

- (void)queuePayment:(NSString *)productName {
     NSString *productId = [productIdPrefix_ stringByAppendingString:productName];
     SKPayment *payment = [SKPayment paymentWithProductIdentifier:productId];
     [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Utility Function

- (void)incrementProductCounter:(NSString *)productId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [defaults integerForKey:productId];
    [defaults setInteger:(count + 1) forKey:productId];
    [defaults synchronize];
}

#pragma mark - SKTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            // Completed.
            NSLog(@"Purchased - %@", transaction.payment.productIdentifier);
            [self incrementProductCounter:transaction.payment.productIdentifier];
            [queue finishTransaction:transaction];
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            // Failed.
            NSLog(@"Failed - %@ (%@)", transaction.payment.productIdentifier, transaction.error);
            if (transaction.error.code != SKErrorPaymentCancelled) {
                [[[UIAlertView alloc] initWithTitle:@"Payment Error" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            [queue finishTransaction:transaction];
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            // Restored.
            NSLog(@"Restored - %@", transaction.payment.productIdentifier);
            [self incrementProductCounter:transaction.payment.productIdentifier];
            [queue finishTransaction:transaction];
        }
    }
}

@end
