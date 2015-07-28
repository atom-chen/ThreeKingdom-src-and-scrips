#include "EventTrigger.h"
#include "SceneEventLoader.h"
#include "SceneEvent.h"
#include "Actor.h"

EventTrigger::EventTrigger()
{
	m_type = EventTriggerAbstract;
	m_value = NULL;
	m_delegate = NULL;
	m_isShield = false;
}

EventTrigger::~EventTrigger()
{
	CC_SAFE_DELETE(m_value);
}

EventTrigger* EventTrigger::createWithData(Value& triggerData, SceneEvent* se)
{
	EventTrigger* trigger = new EventTrigger();
	if (trigger)
	{
		trigger->setDelegate(se);
		trigger->initWithData(triggerData);
		trigger->autorelease();
	}
	return trigger;
}

void EventTrigger::initWithData(Value& triggerData)
{
	std::string triggerType = triggerData.getMemberNames()[0];
	getType(triggerType.c_str());
	switch (m_type)
	{
	case EventTriggerProcess:
		{
			float value = triggerData[triggerType].asFloat();
			m_value = CCFloat::create(value);
			m_value->retain();
			int scriptHandler = SceneEventLoader::sharedInstance()->getProcessHandler();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(scriptHandler, "process", this, "EventTrigger");
		}
		break;
	case EventTriggerOwnerTap:
		{
			Actor* actor = (Actor*)(m_delegate->getOwner());
			actor->registerTapTrigger(this);
		}
		break;
	case EventTriggerOwnerDie:
		{
			Actor* actor = (Actor*)(m_delegate->getOwner());
			actor->registerDieTrigger(this);
		}
		break;
	case EventTriggerUseSkill:
		{
			const char* value = triggerData[triggerType].asCString();
			int scriptHandler = SceneEventLoader::sharedInstance()->getSkillHandler();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(scriptHandler, value, this, "EventTrigger");
		}
		break;
	}
}

void EventTrigger::setDelegate(SceneEvent* se)
{
	m_delegate = se;
}

void EventTrigger::removeDelegateOwner()
{
	m_delegate->setOwner(NULL);
}

void EventTrigger::getType(const char* cType)
{
	if (strcmp(cType, "process") == 0)
	{
		m_type = EventTriggerProcess;
	}
	else if (strcmp(cType, "owner_tap") == 0)
	{
		m_type = EventTriggerOwnerTap;
	}
	else if (strcmp(cType, "owner_die") == 0)
	{
		m_type = EventTriggerOwnerDie;
	}
	else if (strcmp(cType, "use_skill") == 0)
	{
		m_type = EventTriggerUseSkill;
	}
}

CCObject* EventTrigger::getValue()
{
	return m_value;
}

void EventTrigger::active()
{
	if (m_isShield)
	{
		return;
	}
	if (m_delegate)
	{
		setShield(true);
		m_delegate->activeEvent();
		setShield(false);
		m_delegate->checkRebuild();
	}
}

void EventTrigger::setShield(bool isShield)
{
	m_isShield = isShield;
}

void EventTrigger::cleanup()
{
	switch (m_type)
	{
	case EventTriggerProcess:
		{
			int handler = SceneEventLoader::sharedInstance()->getDelProcessHandler();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(handler, "process", this, "EventTrigger");
		}
		break;
	case EventTriggerOwnerTap:
		{
			Actor* actor = (Actor*)(m_delegate->getOwner());
			if (actor)
			{
				actor->unregisterTapTrigger(this);
			}
		}
		break;
	case EventTriggerOwnerDie:
		{
			Actor* actor = (Actor*)(m_delegate->getOwner());
			if (actor)
			{
				actor->unregisterDieTrigger(this);
			}
		}
		break;
	case EventTriggerUseSkill:
		{
			int handler = SceneEventLoader::sharedInstance()->getDelSkillHandler();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(handler, "skill", this, "EventTrigger");
		}
		break;
	}
}