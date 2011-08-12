#import <Foundation/Foundation.h>
#import "IAPTransactionObserver.h"

static IAPTransactionObserver *observer;

#pragma mark - Utility Function

static NSString* CreateNSString (const char* string) {
    return [NSString stringWithUTF8String:(string ? string : "")];
}

#pragma mark Plug-in Function

extern "C" void _StoreKitInstall(const char *productIdPrefix) {
    if (observer == nil) {
        observer = [[IAPTransactionObserver alloc] initWithProductIdPrefix:CreateNSString(productIdPrefix)];
    }
}

extern "C" bool _StoreKitIsAvailable() {
    return observer.available;
}

extern "C" bool _StoreKitIsProcessing() {
    return observer.processing;
}

extern "C" void _StoreKitBuy(const char *productName) {
    [observer queuePayment:CreateNSString(productName)];
}
