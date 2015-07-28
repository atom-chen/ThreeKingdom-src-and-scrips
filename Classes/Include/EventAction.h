#ifndef __SCENE_EVENT_ACTION__
#define __SCENE_EVENT_ACTION__

#include "cocos2d.h"
#include "cocos-ext.h"

#include "SceneEvent.h"

USING_NS_CC;
USING_NS_CC_EXT;
using namespace CSJson;

enum EventActionType
{
	EventActionAbstract = -1,
	EventActionNewEvent,
	EventActionTranEvent,
	EventActionDelEvent,
    EventActionDoBehavior,
	EventActionCreateActor,
	EventActionSetCreateNum,
	EventActionRandomCreateNum,
	EventActionSetCreateEvent,
	EventActionCreateMission,
	EventActionSetMissionTime,
	EventActionSetMissionCount,
	EventActionRemoveMission,
	EventActionAddMissionCount,
	EventActionRandom,
	EventActionSetEmotion,
	EventActionSetDialog,
	EventActionModifyHP,
	EventActionGiveMoney,
	EventActionAddItem,
	EventActionDelItem,
	EventActionWin,
	EventActionActiveScene,
	EventActionSetInvalid,
	EventActionActiveHero
};

class EventAction : public CCObject
{
public:
	EventAction();
	virtual ~EventAction();

	static EventAction* createWithData(Value& actionData);
	void initWithData(Value& triggerData);

	CCObject* getValue();
	void setEvent(SceneEvent* eventObj);

	bool doAction();

protected:
	EventActionType m_type;
	CCObject* m_value;
	SceneEvent* m_event;
	int m_scriptHandler;

	void getType(const char* cType);
};

#endif