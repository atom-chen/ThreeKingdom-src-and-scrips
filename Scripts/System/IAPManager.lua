module("IAPManager", package.seeall)

function init()
    IAPBridge:initIAP();
    IAPBridge:loadStore();
end

function registerCallbackFunction(finishTransaction)
    IAPBridge:registerScriptHandler(finishTransaction);
end

function startTransaction(id)
    IAPBridge:purchaseProUpgrade(id);
end