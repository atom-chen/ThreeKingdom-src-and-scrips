
#import <UIKit/UIKit.h>
#import "IAPManager.h"
#include "configTK.h"
#include "IAPBridge.h"

@implementation IAPManager

//static AppDelegate s_sharedApplication;

-(void) requestProUpgradeProductData:(NSSet*)productIdentifiers
{
    m_productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    m_productsRequest.delegate = self;
    [m_productsRequest start];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    m_proUpgradeProducts = [[NSMutableDictionary dictionary] retain];
    
    for (SKProduct* proUpgradeProduct in products)
    {
        [m_proUpgradeProducts setValue:proUpgradeProduct forKey:proUpgradeProduct.productIdentifier];
        NSLog(@"Product title: %@", proUpgradeProduct.localizedTitle);
        NSLog(@"Product price: %@", proUpgradeProduct.price);
        NSLog(@"Product id: %@", proUpgradeProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@", invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [m_productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

// call this method once on startup
-(void) loadStore:(NSArray*)productIDList
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // get the product description (defined in early sections)
    NSSet* productIdentifiers = [NSSet setWithArray:productIDList];
    [self requestProUpgradeProductData:productIdentifiers];
}

// call this before making a purchase
-(BOOL) canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

// kick off the upgrade transaction
-(void) purchaseProUpgrade:(NSString*)productID
{
    SKProduct* proUpgradeProduct = [m_proUpgradeProducts objectForKey:productID];
    SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// removes the transaction from the queue and posts a notification with the transaction result
-(void) finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction", nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
    const char* productID = [transaction.payment.productIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
    IAPBridge::finishTransaction(productID, wasSuccessful);
}

// called when the transaction was successful
-(void) completeTransaction:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has been restored and and successfully completed
-(void) restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has failed
-(void) failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

// called when the transaction status is updated
-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end

