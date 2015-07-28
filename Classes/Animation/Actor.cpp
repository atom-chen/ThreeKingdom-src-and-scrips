#include "Actor.h"
#include "CCLuaEngine.h"

Actor::Actor()
{
	m_radius = 0;
	m_speed = 0;
	m_imgName = 0;
	m_scriptHandler = 0;
	m_effectProcess = 0;
	m_emotionPosY = 0;
	m_armature = NULL;
	m_emotion = NULL;
	m_dialog = NULL;
	m_dialogBG = NULL;
	m_dialogArrow = NULL;
	setAnchorPoint(CCPoint(0.5, 0));
	m_tapTriggers = CCArray::create();
	m_tapTriggers->retain();
	m_dieTriggers = CCArray::create();
	m_dieTriggers->retain();
	m_items = CCArray::create();
	m_items->retain();
}

Actor::~Actor()
{
	m_armature = NULL;
	m_emotion = NULL;
	m_dialog = NULL;
	m_dialogBG = NULL;
	m_dialogArrow = NULL;

	m_tapTriggers->removeAllObjects();
	CC_SAFE_RELEASE(m_tapTriggers);

	m_dieTriggers->removeAllObjects();
	CC_SAFE_RELEASE(m_dieTriggers);

	m_items->removeAllObjects();
	CC_SAFE_RELEASE(m_items);
}

Actor* Actor::createActor(const char *imgName, float height, float speed)
{
	Actor * actor = new Actor();
    if (actor && actor->init(imgName, height, speed))
    {
        actor->autorelease();
		return actor;
    }
    else
    {
        CC_SAFE_DELETE(actor);
    }
	return NULL;
}

bool Actor::init(const char *imgName, float height, float speed)
{
	if (CCLayer::init())
	{
		setName(imgName);
		setRadius(height);
		setSpeed(speed);
		createImage(imgName);
		setPosition(CCPoint(DISPLAY_WIDTH, ArcBackground::getDistanceHeight()));
		setContentSize(CCSize(100, m_radius));
		return true;
	}
	return false;
}

void Actor::registerScriptHandler(int handler)
{
	m_scriptHandler = handler;
}

void Actor::unregisterScriptHandler()
{
	m_scriptHandler = 0;
}
	
void Actor::setName(const char *imgName)
{
	m_imgName = imgName;
}
	
void Actor::setRadius(float radius)
{
	m_radius = BASE_RADIUS + radius - ACTOR_HEIGHT_OFFSET;
}

void Actor::setHeight(float height)
{
	setRadius(height);
	m_armature->setPosition(CCPoint(50, m_radius));
}
	
void Actor::setSpeed(float speed)
{
	m_speed = speed;
}

void Actor::createTimer(float time, int handler)
{
	CCDelayTime* delay = CCDelayTime::create(time);
	CCCallFuncN* call = CCCallFuncN::create(handler);
	CCSequence* seq = CCSequence::create(delay, call, NULL);
	runAction(seq);
}

CCArmature* Actor::getArmature()
{
	return m_armature;
}

void Actor::createImage(const char *imgName)
{
	CCArmature *armature = CCArmature::create(imgName);
	armature->getAnimation()->play("stand", 0, 0, -1, 0);
	armature->setPosition(CCPoint(50, m_radius));
	armature->getAnimation()->setMovementEventCallFunc(this, movementEvent_selector(Actor::actionComplete));
	addChild(armature);
	m_armature = armature;
	m_emotionPosY = m_armature->boundingBox().size.height + m_radius;
}

void Actor::setEmotion(const char *emotionName, int loop)
{
	if (m_emotion)
	{
		m_emotion->removeFromParentAndCleanup(true);
		m_emotion = NULL;
	}
	if (strcmp(emotionName, "") == 0)
	{
		m_emotion = NULL;
		return;
	}
	CCArmature *armature = CCArmature::create(emotionName);
	armature->setPosition(CCPoint(50, m_emotionPosY));
	armature->setAnchorPoint(CCPoint(0.5, 0));
	armature->getAnimation()->play("stand", 0, 0, loop, 0);
	if (m_fScaleX < 0)
	{
		armature->setScaleX(m_fScaleX);
	}
	m_emotion = armature;
	addChild(m_emotion, 1);
}

void Actor::setDialog(const char *content)
{
	if (m_dialog)
	{
		m_dialog->removeFromParentAndCleanup(true);
	}
	if (strcmp(content, "") == 0)
	{
		return;
	}
	m_dialog = CCLabelTTF::create(content, "Marker Felt", DIALOG_FONT_SIZE, CCSize(400, 0), kCCTextAlignmentLeft);
	m_dialog->setPosition(CCPoint(50, m_emotionPosY));
	m_dialog->setAnchorPoint(CCPoint(0.5, 0));
	m_dialog->setColor(ccBLACK);
	if (!m_dialogBG)
	{
		m_dialogBG = CCScale9Sprite::create("Res/Images/Dialog/dialog_frame.png");
		m_dialogArrow = CCSprite::create("Res/Images/Dialog/dialog_arrow.png");
		addChild(m_dialogBG, 2);
		addChild(m_dialogArrow, 2);
	}
	CCSize bgSize = m_dialog->getContentSize() + CCSize(50, 50);
	m_dialogBG->setPosition(CCPoint(50, m_emotionPosY - 25));
	m_dialogBG->setAnchorPoint(CCPoint(0.5, 0));
	m_dialogBG->setContentSize(bgSize);
	m_dialogArrow->setPosition(CCPoint(50, m_emotionPosY - 20));
	m_dialogArrow->setAnchorPoint(CCPoint(0.5, 1));
	if (m_fScaleX < 0)
	{
		m_dialog->setFlipX(true);
	}
	addChild(m_dialog, 2);
}

void Actor::setAction(const char *actionName)
{
	m_armature->getAnimation()->play(actionName, 0, 0, -1, 0);
}

void Actor::setAction(const char *actionName, int loop)
{
	m_armature->getAnimation()->play(actionName, 0, 0, loop, 0);
}

void Actor::setRotation(float fRotation)
{
	CCLayer::setRotation(fRotation);
}

void Actor::rotateBy(float fRotation)
{
	float angle = getRotation();
	CCLayer::setRotation(angle + fRotation);
}

void Actor::moveBy(float height)
{
	m_radius += height;
	m_armature->setPosition(CCPoint(50, m_radius));
}

void Actor::setFlipX(bool isFlip)
{
	setScaleX(isFlip? -1 : 1);
	if (isFlip)
	{
		if (m_emotion)
		{
			m_emotion->setScaleX(-1);
		}
		if (m_dialog)
		{
			m_dialog->setFlipX(true);
			m_dialogBG->setScaleX(-1);
		}
	}
}

void Actor::setFlipY(bool isFlip)
{
	setScaleY(isFlip? -1 : 1);
	if (isFlip)
	{
		if (m_emotion)
		{
			m_emotion->setScaleY(-1);
		}
		if (m_dialog)
		{
			m_dialog->setFlipY(true);
			m_dialogBG->setScaleY(-1);
		}
	}
}

float Actor::getProcess()
{
	float process = m_armature->getAnimation()->getCurrentPercent();
	return process;
}

float Actor::getRotation()
{
	return CCLayer::getRotation();
}

float Actor::getHeight()
{
	return (m_radius + ACTOR_HEIGHT_OFFSET - BASE_RADIUS);
}

CCRect Actor::boundingBox()
{
	CCRect box = m_armature->boundingBox();
	box.origin.y = m_armature->getPosition().y;
	return box;
}

void Actor::removeSelf()
{
	this->removeFromParentAndCleanup(true);
}

void Actor::actionComplete(CCArmature* armature, MovementEventType type, const char* name)
{
	if (type == COMPLETE)
	{
		if (m_scriptHandler)
		{
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_scriptHandler, "anim_end", this, "Actor");
		}
	}
}

void Actor::emotionComplete(CCArmature* armature, MovementEventType type, const char* name)
{
	if (type == COMPLETE)
	{
		m_emotion->removeFromParentAndCleanup(true);
		m_emotion = NULL;
	}
}

void Actor::tapActor()
{
	int count = m_tapTriggers->count();
	for (int i = 0; i < count; i++)
	{
		EventTrigger* trigger = (EventTrigger*)m_tapTriggers->objectAtIndex(i);
		trigger->active();
	}
}

void Actor::die()
{
	int count = m_dieTriggers->count();
	for (int i = 0; i < count; i++)
	{
		EventTrigger* trigger = (EventTrigger*)m_dieTriggers->objectAtIndex(i);
		trigger->active();
	}
}

void Actor::registerTapTrigger(EventTrigger* trigger)
{
	m_tapTriggers->addObject(trigger);
}

void Actor::unregisterTapTrigger(EventTrigger* trigger)
{
	m_tapTriggers->removeObject(trigger);
}

void Actor::registerDieTrigger(EventTrigger* trigger)
{
	m_dieTriggers->addObject(trigger);
}

void Actor::unregisterDieTrigger(EventTrigger* trigger)
{
	m_dieTriggers->removeObject(trigger);
}

void Actor::addItem(const char* resName)
{
	int count = m_items->count();
	CCArmature *armature = CCArmature::create(resName);
	armature->setPosition(CCPoint(50, BASE_RADIUS - ACTOR_HEIGHT_OFFSET + count * 100));
	armature->setAnchorPoint(CCPoint(1, 0));
	armature->getAnimation()->play("stand", 0, 0, 0, 0);
	m_items->addObject(armature);
	addChild(armature, -1);
}

void Actor::delItem()
{
	if (m_items->count() == 0)
	{
		return;
	}
	CCNode* obj = (CCNode*)m_items->lastObject();
	obj->removeFromParentAndCleanup(true);
	m_items->removeObject(obj);
}

void Actor::delAllItem()
{
	int count = m_items->count();
	if (count == 0)
	{
		return;
	}
	for (int i = 0; i < count; i++)
	{
		CCNode* obj = (CCNode*)m_items->objectAtIndex(i);
		obj->removeFromParentAndCleanup(true);
	}
	m_items->removeAllObjects();
}

int Actor::getItemCount()
{
	return m_items->count();
}

void Actor::showNumber(const char* number, float height, const ccColor3B& color)
{
	CCLabelBMFont* label = CCLabelBMFont::create(number, "fonts/number.fnt");
	label->setPosition(CCPoint(50, m_radius + height));
	label->setAnchorPoint(CCPoint(0.5, 0));
	label->setColor(color);
	label->setScaleX(m_fScaleX);
	addChild(label, 3);
	CCMoveBy* move = CCMoveBy::create(1, CCPoint(0, 400));
	CCCallFuncN* call = CCCallFuncN::create(label, callfuncN_selector(Actor::clearNumber));
	CCSequence* seq = CCSequence::create(move, call, NULL);
	label->runAction(seq);
}

void Actor::clearNumber(CCNode* label)
{
	label->removeFromParentAndCleanup(true);
}

CCArmature* Actor::createAnimation(const char *imgName, const char *animName, int loop)
{
	CCArmature *armature = CCArmature::create(imgName);
	armature->getAnimation()->play(animName, 0, 0, loop, 0);
	return armature;
}

void Actor::removeFromParentAndCleanup(bool cleanup)
{
	CCLayer::removeFromParentAndCleanup(cleanup);
}

void Actor::cleanup()
{
	//CCLOG("*************************************************cleanup  m_imgName->%s", m_imgName);
	int tapCount = m_tapTriggers->count();
	int dieCount = m_dieTriggers->count();
	for (int i = 0; i < tapCount; i++)
	{
		EventTrigger* trigger = (EventTrigger*)m_tapTriggers->objectAtIndex(i);
		trigger->removeDelegateOwner();
	}
	for (int i = 0; i < dieCount; i++)
	{
		EventTrigger* trigger = (EventTrigger*)m_dieTriggers->objectAtIndex(i);
		trigger->removeDelegateOwner();
	}
	m_armature->getAnimation()->stopMovementEventCallFunc();
	CCLayer::cleanup();
}

void Actor::showRect(float width)
{
#ifdef SHOW_RECT
	m_rectLineL = CCSprite::create("Res/Images/line.png");
	m_rectLineR = CCSprite::create("Res/Images/line.png");
	m_rectLineL->setPosition(CCPoint(50, 0));
	m_rectLineR->setPosition(CCPoint(50, 0));
	m_rectLineL->setAnchorPoint(CCPoint(0.5, 0));
	m_rectLineR->setAnchorPoint(CCPoint(0.5, 0));
	m_rectLineL->setScaleY(35);
	m_rectLineR->setScaleY(35);
	m_rectLineL->setRotation(-(width / 2));
	m_rectLineR->setRotation((width / 2));
	addChild(m_rectLineL, 100);
	addChild(m_rectLineR, 100);
#endif
}