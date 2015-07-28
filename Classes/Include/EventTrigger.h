#ifndef __SCENE_EVENT_TRIGGER__
#define __SCENE_EVENT_TRIGGER__

#include "cocos2d.h"
#include "cocos-ext.h"

#include "SceneEvent.h"

USING_NS_CC;
USING_NS_CC_EXT;
using namespace CSJson;

enum EventTriggerType
{
	EventTriggerAbstract = -1,
    EventTriggerProcess,
	EventTriggerOwnerTap,
	EventTriggerOwnerDie,
	EventTriggerUseSkill
};

class EventTrigger : public CCObject
{
public:
	EventTrigger();
	virtual ~EventTrigger();

	static EventTrigger* createWithData(Value& triggerData, SceneEvent* se);
	void initWithData(Value& triggerData);
	void setDelegate(SceneEvent* se);
	void removeDelegateOwner();
	CCObject* getValue();
	void setShield(bool isShield);

	void active();

	void cleanup();

protected:
	EventTriggerType m_type;
	CCObject* m_value;
	SceneEvent* m_delegate;
	bool m_isShield;

	void getType(const char* cType);
};

#endif