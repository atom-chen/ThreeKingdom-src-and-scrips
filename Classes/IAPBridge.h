#ifndef __IAP_BRIDGE__
#define __IAP_BRIDGE__

#include "cocos2d.h"

#define PRODUCT_ID_1  @"SJSD_TK_payment_6"
#define PRODUCT_ID_2  @"SJSD_TK_payment_12"
#define PRODUCT_ID_3  @"SJSD_TK_payment_30"
#define PRODUCT_ID_4  @"SJSD_TK_payment_68"

USING_NS_CC;

class IAPBridge
{
public:
    static void initIAP();
    static void loadStore();
    static void registerScriptHandler(int handler);
    static void purchaseProUpgrade(int id);
    static void finishTransaction(const char* product, bool wasSuccessful);
};

#endif
