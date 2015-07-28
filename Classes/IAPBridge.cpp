#include "IAPBridge.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#import "IAPManager.h"
#import <StoreKit/StoreKit.h>
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
static IAPManager* s_iapManager;
static NSArray* s_productIDList;
#endif

static int s_scriptHandler;

void IAPBridge::initIAP()
{
	s_scriptHandler = 0;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    s_iapManager = [IAPManager new];
    s_productIDList = [[NSArray arrayWithObjects:PRODUCT_ID_1, PRODUCT_ID_2, PRODUCT_ID_3, PRODUCT_ID_4, nil] retain];
#endif
}

void IAPBridge::loadStore()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    [s_iapManager loadStore:s_productIDList];
#endif
}

void IAPBridge::registerScriptHandler(int handler)
{
    s_scriptHandler = handler;
}

void IAPBridge::purchaseProUpgrade(int id)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    if ([s_iapManager canMakePurchases] == true)
    {
        NSString* productID = [s_productIDList objectAtIndex:(id - 1)];
        [s_iapManager purchaseProUpgrade:productID];
    }
    else

    {
        CCLog("没有可进行的交易");
    }
#endif
}

void IAPBridge::finishTransaction(const char* product, bool wasSuccessful)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    int index = 0;
    int count = [s_productIDList count];
    for (int i = 0; i < count; i++)
    {
        const char* cProduct = [[s_productIDList objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
        if (strcmp(product, cProduct) == 0)
        {
            index = i + 1;
            break;
        }
    }
    if (s_scriptHandler)
    {
        CCInteger* value = CCInteger::create(index);
        const char* result = wasSuccessful ? "true" : "false";
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(s_scriptHandler, result, value, "CCInteger");
    }
#endif
}