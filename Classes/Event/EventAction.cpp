#include "EventAction.h"
#include "Actor.h"

EventAction::EventAction()
{
	m_type = EventActionAbstract;
	m_value = NULL;
	m_event = NULL;
}

EventAction::~EventAction()
{
	CC_SAFE_DELETE(m_value);
}

EventAction* EventAction::createWithData(Value& actionData)
{
	EventAction* action = new EventAction();
	if (action)
	{
		action->initWithData(actionData);
		action->autorelease();
	}
	return action;
}

void EventAction::initWithData(Value& actionData)
{
	std::string triggerType = actionData.getMemberNames()[0];
	getType(triggerType.c_str());
	switch (m_type)
	{
	case EventActionNewEvent:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getCreateEventHandler();
			std::string eventName = actionData[triggerType].asCString();
			m_value = CCString::create(eventName);
			m_value->retain();
		}
		break;
	case EventActionDelEvent:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getRemoveEventHandler();
			std::string eventName = actionData[triggerType].asCString();
			m_value = CCString::create(eventName);
			m_value->retain();
		}
		break;
	case EventActionTranEvent:
		{
			std::string eventName = actionData[triggerType].asCString();
			m_value = CCString::create(eventName);
			m_value->retain();
		}
		break;
	case EventActionDoBehavior:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getDoBehaviorHandler();
			std::string behavior = actionData[triggerType].asCString();
			m_value = CCString::create(behavior);
			m_value->retain();
		}
		break;
	case EventActionCreateActor:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getCreateActorHandler();
			std::string resource = actionData[triggerType].asCString();
			m_value = CCString::create(resource);
			m_value->retain();
		}
		break;
	case EventActionSetCreateNum:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getCreateCountHandler();
			int count = actionData[triggerType].asInt();
			m_value = CCInteger::create(count);
			m_value->retain();
		}
		break;
	case EventActionRandomCreateNum:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getRandomCountHandler();
			int count = actionData[triggerType].asInt();
			m_value = CCInteger::create(count);
			m_value->retain();
		}
		break;
	case EventActionSetCreateEvent:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getEventCreateHandler();
			std::string eventName = actionData[triggerType].asCString();
			m_value = CCString::create(eventName);
			m_value->retain();
		}
		break;
	case EventActionCreateMission:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getCreateMissionHandler();
			std::string type = actionData[triggerType].asCString();
			m_value = CCString::create(type);
			m_value->retain();
		}
		break;
	case EventActionSetMissionTime:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getMissionTimeHandler();
			float time = actionData[triggerType].asFloat();
			m_value = CCFloat::create(time);
			m_value->retain();
		}
		break;
	case EventActionSetMissionCount:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getMissionCountHandler();
			int count = actionData[triggerType].asInt();
			m_value = CCInteger::create(count);
			m_value->retain();
		}
		break;
	case EventActionRemoveMission:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getRemoveMissionHandler();
		}
		break;
	case EventActionAddMissionCount:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getAddMissionCountHandler();
			std::string type = actionData[triggerType].asCString();
			m_value = CCString::create(type);
			m_value->retain();
		}
		break;
	case EventActionSetEmotion:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getEmotionHandler();
			std::string emotionName = actionData[triggerType].asCString();
			m_value = CCString::create(emotionName);
			m_value->retain();
		}
		break;
	case EventActionSetDialog:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getDialogHandler();
			std::string dialog = actionData[triggerType].asCString();
			m_value = CCString::create(dialog);
			m_value->retain();
		}
		break;
	case EventActionModifyHP:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getModifyHPHandler();
			int hp = actionData[triggerType].asInt();
			m_value = CCInteger::create(hp);
			m_value->retain();
		}
		break;
	case EventActionGiveMoney:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getGiveMoneyHandler();
			int money = actionData[triggerType].asInt();
			m_value = CCInteger::create(money);
			m_value->retain();
		}
		break;
	case EventActionAddItem:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getAddItemHandler();
			std::string resName = actionData[triggerType].asCString();
			m_value = CCString::create(resName);
			m_value->retain();
		}
		break;
	case EventActionDelItem:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getDelItemHandler();
		}
		break;
	case EventActionWin:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getWinHandler();
		}
		break;
	case EventActionActiveScene:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getActiveSceneHandler();
			int sceneID = actionData[triggerType].asInt();
			m_value = CCInteger::create(sceneID);
			m_value->retain();
		}
		break;
	case EventActionSetInvalid:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getSetInvalidHandler();
		}
		break;
	case EventActionActiveHero:
		{
			m_scriptHandler = SceneEventLoader::sharedInstance()->getActiveHeroHandler();
			std::string heroName = actionData[triggerType].asCString();
			m_value = CCString::create(heroName);
			m_value->retain();
		}
		break;
	}
}


void EventAction::getType(const char* cType)
{
	if (strcmp(cType, "new_event") == 0)
	{
		m_type = EventActionNewEvent;
	}
	else if (strcmp(cType, "tran_event") == 0)
	{
		m_type = EventActionTranEvent;
	}
	else if (strcmp(cType, "del_event") == 0)
	{
		m_type = EventActionDelEvent;
	}
	else if (strcmp(cType, "do_behavior") == 0)
	{
		m_type = EventActionDoBehavior;
	}
	else if (strcmp(cType, "create_actor") == 0)
	{
		m_type = EventActionCreateActor;
	}
	else if (strcmp(cType, "set_create_count") == 0)
	{
		m_type = EventActionSetCreateNum;
	}
	else if (strcmp(cType, "random_create_count") == 0)
	{
		m_type = EventActionRandomCreateNum;
	}
	else if (strcmp(cType, "set_create_event") == 0)
	{
		m_type = EventActionSetCreateEvent;
	}
	else if (strcmp(cType, "create_mission") == 0)
	{
		m_type = EventActionCreateMission;
	}
	else if (strcmp(cType, "set_mission_time") == 0)
	{
		m_type = EventActionSetMissionTime;
	}
	else if (strcmp(cType, "set_mission_count") == 0)
	{
		m_type = EventActionSetMissionCount;
	}
	else if (strcmp(cType, "remove_mission") == 0)
	{
		m_type = EventActionRemoveMission;
	}
	else if (strcmp(cType, "add_mission_count") == 0)
	{
		m_type = EventActionAddMissionCount;
	}
	else if (strcmp(cType, "emotion") == 0)
	{
		m_type = EventActionSetEmotion;
	}
	else if (strcmp(cType, "dialog") == 0)
	{
		m_type = EventActionSetDialog;
	}
	else if (strcmp(cType, "modify_hp") == 0)
	{
		m_type = EventActionModifyHP;
	}
	else if (strcmp(cType, "give_money") == 0)
	{
		m_type = EventActionGiveMoney;
	}
	else if (strcmp(cType, "add_item") == 0)
	{
		m_type = EventActionAddItem;
	}
	else if (strcmp(cType, "del_item") == 0)
	{
		m_type = EventActionDelItem;
	}
	else if (strcmp(cType, "win") == 0)
	{
		m_type = EventActionWin;
	}
	else if (strcmp(cType, "active_scene") == 0)
	{
		m_type = EventActionActiveScene;
	}
	else if (strcmp(cType, "set_invalid") == 0)
	{
		m_type = EventActionSetInvalid;
	}
	else if (strcmp(cType, "active_hero") == 0)
	{
		m_type = EventActionActiveHero;
	}
}



CCObject* EventAction::getValue()
{
	return m_value;
}

void EventAction::setEvent(SceneEvent* eventObj)
{
	m_event = eventObj;
}

bool EventAction::doAction()
{
	bool isContinue = true;
	switch (m_type)
	{
	case EventActionNewEvent:
		{
			CCString* value = (CCString*)m_value;
			const char* eventName = value->getCString();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, eventName, NULL, "");
		}
		break;
	case EventActionTranEvent:
		{
			CCString* value = (CCString*)m_value;
			const char* eventName = value->getCString();
			m_event->rebuild(eventName);
			isContinue = false;
		}
		break;
	case EventActionDelEvent:
		{
			CCString* value = (CCString*)m_value;
			const char* eventName = value->getCString();
			Actor* actor = (Actor*)m_event->getOwner();
			if (strcmp(eventName, "self") == 0)
			{
				eventName = m_event->getName();
			}
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, eventName, actor, "Actor");
		}
		break;
	case EventActionDoBehavior:
		{
			CCString* value = (CCString*)m_value;
			const char* behavior = value->getCString();
			Actor* actor = (Actor*)m_event->getOwner();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, behavior, actor, "Actor");
		}
		break;
	case EventActionCreateActor:
		{
			CCString* value = (CCString*)m_value;
			const char* resource = value->getCString();
			Actor* actor = (Actor*)m_event->getOwner();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, resource, actor, "Actor");
		}
		break;
	case EventActionSetCreateNum:
	case EventActionRandomCreateNum:
		{
			CCInteger* value = (CCInteger*)m_value;
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "create_count", value, "CCInteger");
		}
		break;
	case EventActionSetCreateEvent:
		{
			CCString* value = (CCString*)m_value;
			const char* eventName = value->getCString();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, eventName, NULL, "");
		}
		break;
	case EventActionCreateMission:
		{
			CCString* value = (CCString*)m_value;
			const char* type = value->getCString();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, type, NULL, "");
		}
		break;
	case EventActionSetMissionTime:
		{
			CCFloat* value = (CCFloat*)m_value;
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "mission_time", value, "CCFloat");
		}
		break;
	case EventActionSetMissionCount:
		{
			CCInteger* value = (CCInteger*)m_value;
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "mission_count", value, "CCInteger");
		}
		break;
	case EventActionRemoveMission:
		{
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "remove_mission", NULL, "");
		}
		break;
	case EventActionAddMissionCount:
		{
			CCString* value = (CCString*)m_value;
			const char* type = value->getCString();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, type, NULL, "");
		}
		break;
	case EventActionSetEmotion:
		{
			CCString* value = (CCString*)m_value;
			const char* type = value->getCString();
			Actor* actor = (Actor*)m_event->getOwner();

			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, type, actor, "Actor");
		}
		break;
	case EventActionSetDialog:
		{
			CCString* value = (CCString*)m_value;
			const char* content = value->getCString();
			Actor* actor = (Actor*)m_event->getOwner();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, content, actor, "Actor");
		}
		break;
	case EventActionModifyHP:
		{
			CCInteger* value = (CCInteger*)m_value;
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "modify_hp", value, "CCInteger");
		}
		break;
	case EventActionGiveMoney:
		{
			CCInteger* value = (CCInteger*)m_value;
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "give_money", value, "CCInteger");
		}
		break;
	case EventActionAddItem:
		{
			CCString* value = (CCString*)m_value;
			const char* resName = value->getCString();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, resName, NULL, "");
		}
		break;
	case EventActionDelItem:
		{
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "", NULL, "");
		}
		break;
	case EventActionWin:
		{
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "win", NULL, "");
		}
		break;
	case EventActionActiveScene:
		{
			CCInteger* value = (CCInteger*)m_value;
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "active_scene", value, "CCInteger");
		}
		break;
	case EventActionSetInvalid:
		{
			Actor* actor = (Actor*)m_event->getOwner();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "set_invalid", actor, "Actor");
		}
		break;
	case EventActionActiveHero:
		{
			CCString* value = (CCString*)m_value;
			const char* heroName = value->getCString();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, heroName, NULL, "");
		}
		break;
	}
	return isContinue;
}