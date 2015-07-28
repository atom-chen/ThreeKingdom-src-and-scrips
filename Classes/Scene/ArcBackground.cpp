#include "ArcBackground.h"
#include "AppDelegate.h"
#include "Actor.h"


static float s_angleMax;
static float s_exchangeAngle;
static float s_distancHeight;

ArcBackground::ArcBackground()
{
	m_curAngle = 0;
	m_radius = 0;
	m_speed = 0;
	m_spriteCount = 0;
	m_spriteIndex = 0;
	m_isRun = false;
}

ArcBackground::~ArcBackground()
{
	
}

void ArcBackground::initData()
{
	s_exchangeAngle = 180 / 3.1415926f;
	s_angleMax = asin(DISPLAY_WIDTH / BASE_RADIUS) * s_exchangeAngle;
	s_distancHeight = sqrt(BASE_RADIUS * BASE_RADIUS - DISPLAY_WIDTH * DISPLAY_WIDTH * 4);
}

float ArcBackground::getDistanceHeight()
{
	return (-s_distancHeight - OFFSET_HEIGHT);
}

ArcBackground* ArcBackground::create(const char *imgName, float height, float angle, float scale)
{
	ArcBackground * ab = new ArcBackground();
    if (ab && ab->init())
    {
        ab->autorelease();
		ab->setPosition(CCPoint(0, -s_distancHeight - OFFSET_HEIGHT));
		ab->setAnchorPoint(CCPoint(0, 0));
		ab->setContentSize(CCSize(SCREEN_WIDTH, SCREEN_HEIGHT));
		ab->setRadius(height);
		ab->setTileAngle(angle);
		ab->createSprites(imgName, scale);
		return ab;
    }
    else
    {
        CC_SAFE_DELETE(ab);
    }
	return NULL;
}

void ArcBackground::setRadius(float radius)
{
	m_radius = BASE_RADIUS + radius;
}

void ArcBackground::setTileAngle(float angle)
{
	m_tileAngle = angle;
}

void ArcBackground::setSpeed(float speed)
{
	m_speed = speed;
}

void ArcBackground::setRotation(float angle)
{
	CCObject* child;
    CCARRAY_FOREACH(m_pChildren, child)
    {
        CCNode* pChild = (CCNode*) child;
        if (pChild)
        {
			float rotation = pChild->getRotation();
			pChild->setRotation(rotation - angle);
			if ((rotation - angle) < -(s_angleMax * 2))
			{
				pChild->setRotation(pChild->getRotation() + (m_spriteCount * m_tileAngle));
			}
			else if ((rotation - angle) > (s_angleMax * 2))
			{
				pChild->setRotation(pChild->getRotation() - (m_spriteCount * m_tileAngle));
			}
        }
    }
}

void ArcBackground::createSprites(const char *imgName, float scale)
{
	float curAngle = 0;
	int tag = 0;
	m_spriteCount = 0;

	CCTexture2D* texture = CCTextureCache::sharedTextureCache()->addImage(imgName);
	CCSize size = texture->getContentSize();

	while (curAngle < s_angleMax * 4)
	{
		CCLayer* layer = CCLayerColor::create();
		layer->setAnchorPoint(CCPoint(0, 0));
		layer->setPosition(CCPoint(SCREEN_WIDTH / 2, 0));
		layer->setRotation(curAngle - s_angleMax * 2);
		CCSprite* sprite = CCSprite::createWithTexture(texture);
		sprite->setPosition(CCPoint(0, m_radius - size.height * scale));
		sprite->setAnchorPoint(CCPoint(0.5, 0));
		sprite->setScale(scale);
		layer->addChild(sprite, 0, m_spriteCount);
		addChild(layer, 0, tag++);
		curAngle += m_tileAngle;
		m_spriteCount++;
	}
}

float ArcBackground::getAngle()
{
	return m_curAngle;
}

float ArcBackground::getRadius()
{
	return m_radius;
}

float ArcBackground::getSpeed()
{
	return m_speed;
}

bool ArcBackground::isRun()
{
	return m_isRun;
}

void ArcBackground::start()
{
	if (m_isRun == false)
	{
		scheduleUpdate();
		m_isRun = true;
	}
}

void ArcBackground::stop()
{
	if (m_isRun == true)
	{
		unscheduleUpdate();
		m_isRun = false;
	}
}

void ArcBackground::update(float delta)
{
	float angle = m_speed * delta;
	m_curAngle += angle;
	setRotation(angle);
}