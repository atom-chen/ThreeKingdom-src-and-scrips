#ifndef __GAME_ACTOR__
#define __GAME_ACTOR__

#include "cocos2d.h"
#include "configTK.h"
#include "Math.h"
#include "ArcBackground.h"
#include "EventTrigger.h"

USING_NS_CC;

#define ACTOR_HEIGHT_OFFSET	170
#define DIALOG_FONT_SIZE 48
#define NUMBER_FONT_SIZE 72

#define SHOW_RECT

class Actor : public CCLayer
{
public:
	Actor();
	virtual ~Actor();

	static Actor* createActor(const char *imgName, float height, float speed);
	virtual bool init(const char *imgName, float height, float speed);
	void registerScriptHandler(int handler);
	void unregisterScriptHandler();
	void setName(const char *imgName);
	void setRadius(float radius);
	void setHeight(float radius);
	void setSpeed(float speed);
	void createTimer(float time, int handler);
	void createImage(const char *imgName);
	void setEmotion(const char *emotionName, int loop);
	void setDialog(const char *content);
	void setAction(const char *actionName);
	void setAction(const char *actionName, int loop);
	void setRotation(float fRotation);
	void rotateBy(float fRotation);
	void moveBy(float height);
	void setFlipX(bool isFlip);
	void setFlipY(bool isFlip);
	float getProcess();
	float getRotation();
	float getHeight();
	CCRect boundingBox();
	void removeSelf();
	void actionComplete(CCArmature* armature, MovementEventType type, const char* name);
	void emotionComplete(CCArmature* armature, MovementEventType type, const char* name);
	void tapActor();
	void die();
	void registerTapTrigger(EventTrigger* trigger);
	void unregisterTapTrigger(EventTrigger* trigger);
	void registerDieTrigger(EventTrigger* trigger);
	void unregisterDieTrigger(EventTrigger* trigger);
	void addItem(const char* resName);
	void delItem();
	void delAllItem();
	int getItemCount();
	void showNumber(const char* number, float height, const ccColor3B& color);
	void clearNumber(CCNode* label);
	virtual void removeFromParentAndCleanup(bool cleanup);
	virtual void cleanup(void);
	void showRect(float width);

	CCArmature* getArmature();
	static CCArmature* createAnimation(const char *imgName, const char *animName, int loop);
    
    float getSpeed();
protected:
	const char* m_imgName;
	float m_radius;
	float m_speed;
	CCArmature* m_armature;
	int m_scriptHandler;
	float m_effectProcess;
	CCArray* m_tapTriggers;
	CCArray* m_dieTriggers;
	CCArmature* m_emotion;
	float m_emotionPosY;
	CCLabelTTF* m_dialog;
	CCScale9Sprite* m_dialogBG;
	CCSprite* m_dialogArrow;
	CCArray* m_items;

	CCSprite* m_rectLineL;
	CCSprite* m_rectLineR;
};

#endif
