#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPTransactionObserver : NSObject <SKPaymentTransactionObserver> {
    NSString *productIdPrefix_;
    BOOL availability_;
}

@property (readonly) BOOL available;
@property (readonly) BOOL processing;

- (id)initWithProductIdPrefix:(NSString *)prefix;
- (void)queuePayment:(NSString *)productName;
- (void)incrementProductCounter:(NSString *)productId;

@end
