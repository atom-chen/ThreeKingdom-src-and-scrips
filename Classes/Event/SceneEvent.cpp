#include "SceneEvent.h"
#include "EventTrigger.h"
#include "EventCondition.h"
#include "EventAction.h"

SceneEvent::SceneEvent()
{
	m_name = NULL;
	m_rebuildEvent = NULL;
	m_triggers = CCArray::create();
	m_conditions = CCArray::create();
	m_actions = CCArray::create();
	m_triggers->retain();
	m_conditions->retain();
	m_actions->retain();
}

SceneEvent::~SceneEvent()
{
	m_triggers->removeAllObjects();
	CC_SAFE_DELETE(m_triggers);

	m_conditions->removeAllObjects();
	CC_SAFE_DELETE(m_conditions);

	m_actions->removeAllObjects();
	CC_SAFE_DELETE(m_actions);

	if (m_name)
	{
		delete m_name;
		m_name = NULL;
	}
	if (m_rebuildEvent)
	{
		delete m_rebuildEvent;
		m_rebuildEvent = NULL;
	}
}

SceneEvent* SceneEvent::create(const char* eventName, CCObject* owner)
{
	Value eventData = SceneEventLoader::sharedInstance()->getEventData();
	SceneEvent* sceneEvent = new SceneEvent();
	sceneEvent->setOwner(owner);
	sceneEvent->initWithData(eventData[eventName]);
	sceneEvent->setName(eventName);
	return sceneEvent;
}

void SceneEvent::initWithData(Value& eventData)
{
	createTriggers(eventData["trigger"]);
	createConditions(eventData["condition"]);
	createActions(eventData["action"]);
}

void SceneEvent::rebuild(const char* eventName)
{
	if (m_rebuildEvent)
	{
		delete m_rebuildEvent;
	}
	int len = strlen(eventName);
	m_rebuildEvent = new char[len + 1];
	memcpy(m_rebuildEvent, eventName, len);
	m_rebuildEvent[len] = '\0';
}

void SceneEvent::forceRebuild(const char* eventName)
{
	int count = m_triggers->count();
	for (int i = 0; i < count; i++)
	{
		EventTrigger* trigger = (EventTrigger*)m_triggers->objectAtIndex(i);
		trigger->cleanup();
	}

	m_triggers->removeAllObjects();
	m_conditions->removeAllObjects();
	m_actions->removeAllObjects();

	Value eventData = SceneEventLoader::sharedInstance()->getEventData();
	initWithData(eventData[eventName]);
}

void SceneEvent::setName(const char* name)
{
	if (m_name)
	{
		delete m_name;
		m_name = NULL;
	}
	int len = strlen(name);
	m_name = new char[len + 1];
	memcpy(m_name, name, len);
	m_name[len] = '\0';
}

void SceneEvent::setOwner(CCObject* owner)
{
	m_owner = owner;
}

const char* SceneEvent::getName()
{
	return m_name;
}

CCObject* SceneEvent::getOwner()
{
	return m_owner;
}

void SceneEvent::createTriggers(Value& triggerData)
{
	int count = triggerData.size();
	for (int i = 0; i < count; i++)
	{
		EventTrigger* trigger = EventTrigger::createWithData(triggerData[i], this);
		m_triggers->addObject(trigger);
	}
}

void SceneEvent::createConditions(Value& conditionData)
{
	int count = conditionData.size();
	for (int i = 0; i < count; i++)
	{
		EventCondition* condition = EventCondition::createWithData(conditionData[i]);
		m_conditions->addObject(condition);
	}
}

void SceneEvent::createActions(Value& actionData)
{
	int count = actionData.size();
	for (int i = 0; i < count; i++)
	{
		EventAction* action = EventAction::createWithData(actionData[i]);
		m_actions->addObject(action);
		action->setEvent(this);
	}
}

void SceneEvent::activeEvent()
{
	bool isAccord = true;
	int count = m_conditions->count();
	for (int i = 0; i < count; i++)
	{
		EventCondition* condition = (EventCondition*)m_conditions->objectAtIndex(i);
		isAccord = condition->check();
		if (!isAccord)
		{
			break;
		}
	}
	if (isAccord)
	{
		count = m_actions->count();
		for (int i = 0; i < count; i++)
		{
			EventAction* action = (EventAction*)(m_actions->objectAtIndex(i));
			bool isContinue = action->doAction();
			if (!isContinue)
			{
				break;
			}
		}
	}
}

void SceneEvent::checkRebuild()
{
	if (m_rebuildEvent)
	{
		forceRebuild(m_rebuildEvent);
		delete m_rebuildEvent;
		m_rebuildEvent = NULL;
	}
}

void SceneEvent::cleanup()
{
	int count = m_triggers->count();
	for (int i = 0; i < count; i++)
	{
		EventTrigger* trigger = (EventTrigger*)m_triggers->objectAtIndex(i);
		trigger->cleanup();
	}
}

void SceneEvent::remove(SceneEvent* eventObj)
{
	eventObj->cleanup();
	delete eventObj;
}