#include "cocos2d.h"
#include "CCEGLView.h"
#include "platform/CCEGLViewProtocol.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "Lua_extensions_CCB.h"
#include "configTK.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif

#include "Include/ArcBackground.h"
#include "Include/SceneDataSource.h"
#include "Include/Actor.h"

using namespace CocosDenshion;

USING_NS_CC;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

CCSize AppDelegate::getDrawSizeByDesignSize(const CCSize designSize){
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    CCSize drawSize;
    float deviceSizeRate = winSize.width / winSize.height;
    float designSizeRate = designSize.width / designSize.height;
    if (deviceSizeRate < designSizeRate) {
        drawSize.width = designSize.width;
        drawSize.height = designSize.width / deviceSizeRate;
    }else if (deviceSizeRate > designSizeRate){
        drawSize.height = designSize.height;
        drawSize.width = designSize.height * deviceSizeRate;
    }else{
        drawSize = designSize;
    }
    return drawSize;
}

bool AppDelegate::applicationDidFinishLaunching()
{

    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());

    // turn on display FPS
    pDirector->setDisplayStats(false);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / GAME_FPS);

    // register lua engine
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);

    CCLuaStack *pStack = pEngine->getLuaStack();
    lua_State *tolua_s = pStack->getLuaState();
    tolua_extensions_ccb_open(tolua_s);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    pStack = pEngine->getLuaStack();
    tolua_s = pStack->getLuaState();
    tolua_web_socket_open(tolua_s);
#endif

//#if (CC_TARGET_PLATFORM == CC_PLATFORM_BLACKBERRY)
    CCFileUtils::sharedFileUtils()->addSearchPath("scripts");
//#endif

	/*CCFileUtils* fu = CCFileUtils::sharedFileUtils();
	pEngine->addSearchPath((fu->fullPathForFilename("Scripts/Scene/")).c_str());
	pEngine->addSearchPath((fu->fullPathForFilename("Scripts/Audio/")).c_str());*/
    
    
    //CCDirector* director = CCDirector::sharedDirector();
    //CCEGLView* glview = director->getOpenGLView();
    //CCSize drawSize = getDrawSizeByDesignSize(ccp(2048, 1536));
    //glview->setDesignResolutionSize(drawSize.width, drawSize.height, ResolutionPolicy::kResolutionExactFit);

    std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("main.lua");
    pEngine->executeScriptFile(path.c_str());

	return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();

    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();

    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
