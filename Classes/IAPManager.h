#ifndef __IAP_MANAGER__
#define __IAP_MANAGER__

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@class IAPManager;

@interface IAPManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSMutableDictionary* m_proUpgradeProducts;
    SKProductsRequest* m_productsRequest;
}

-(void) requestProUpgradeProductData:(NSSet*)productIdentifiers;
-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;

-(void) loadStore:(NSArray*)productIDList;
-(BOOL) canMakePurchases;
-(void) purchaseProUpgrade:(NSString*)productID;
-(void) finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful;
-(void) completeTransaction:(SKPaymentTransaction *)transaction;
-(void) restoreTransaction:(SKPaymentTransaction *)transaction;
-(void) failedTransaction:(SKPaymentTransaction *)transaction;
-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

@end

#endif