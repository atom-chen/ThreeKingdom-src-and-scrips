#include "EventCondition.h"
#include "Actor.h"

EventCondition::EventCondition()
{
	m_type = EventConditionAbstract;
	m_value = NULL;
	m_target = NULL;
}

EventCondition::~EventCondition()
{
	CC_SAFE_DELETE(m_value);
}

EventCondition* EventCondition::createWithData(Value& conditionData)
{
	EventCondition* condition = new EventCondition();
	if (condition)
	{
		condition->initWithData(conditionData);
		condition->autorelease();
	}
	return condition;
}

void EventCondition::initWithData(Value& conditionData)
{
	std::string conditionType = conditionData.getMemberNames()[0];
	getType(conditionType.c_str());
	switch (m_type)
	{
	case EventConditionItemCount:
		{
			int handler = SceneEventLoader::sharedInstance()->getAttachItemCountTargetHandler();
			int count = conditionData[conditionType].asInt();
			m_value = CCInteger::create(count);
			m_value->retain();
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(handler, "", this, "EventCondition");
		}
		break;
	}
}

void EventCondition::getType(const char* cType)
{
	if (strcmp(cType, "item_count") == 0)
	{
		m_type = EventConditionItemCount;
	}
}

CCObject* EventCondition::getValue()
{
	return m_value;
}

void EventCondition::setTarget(CCObject* target)
{
	m_target = target;
}

bool EventCondition::check()
{
	bool res = true;
	switch (m_type)
	{
	case EventConditionItemCount:
		{
			Actor* target = (Actor*)m_target;
			int count = target->getItemCount();
			CCInteger* value = (CCInteger*)m_value;
			res = (count >= value->getValue());
		}
		break;
	}
	return res;
}