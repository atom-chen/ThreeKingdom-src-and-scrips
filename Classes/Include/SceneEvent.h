#ifndef __SCENE_EVENT__
#define __SCENE_EVENT__

#include "SceneEventLoader.h"

class SceneEvent
{
public:
	SceneEvent();
	virtual ~SceneEvent();

	static SceneEvent* create(const char* eventName, CCObject* owner);
	static void remove(SceneEvent* eventObj);
	void initWithData(Value& eventData);
	void rebuild(const char* eventName);

	void setName(const char* name);
	const char* getName();
	void setOwner(CCObject* owner);
	CCObject* getOwner();

	void activeEvent();
	void checkRebuild();

	void cleanup();

protected:
	char* m_name;
	CCArray* m_triggers;
	CCArray* m_conditions;
	CCArray* m_actions;
	CCObject* m_owner;

	char* m_rebuildEvent;

	void createTriggers(Value& triggerData);
	void createConditions(Value& conditionData);
	void createActions(Value& actionData);

	void forceRebuild(const char* eventName);
};

#endif