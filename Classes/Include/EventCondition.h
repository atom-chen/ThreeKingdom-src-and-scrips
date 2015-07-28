#ifndef __SCENE_EVENT_CONDITION__
#define __SCENE_EVENT_CONDITION__

#include "cocos2d.h"
#include "cocos-ext.h"

USING_NS_CC;
USING_NS_CC_EXT;
using namespace CSJson;

enum EventConditionType
{
    EventConditionAbstract = -1,
	EventConditionItemCount = 0
};

class EventCondition : public CCObject
{
public:
	EventCondition();
	~EventCondition();

	static EventCondition* createWithData(Value& conditionData);
	void initWithData(Value& conditionData);
	CCObject* getValue();
	void setTarget(CCObject* target);
	bool check();

protected:
	EventConditionType m_type;
	CCObject* m_value;
	CCObject* m_target;

	void getType(const char* cType);
};

#endif