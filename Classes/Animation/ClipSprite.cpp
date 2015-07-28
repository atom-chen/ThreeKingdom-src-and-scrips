#include "ClipSprite.h"

ClipSprite::ClipSprite()
{

}

ClipSprite::~ClipSprite()
{

}

ClipSprite* ClipSprite::create(const char* fileName)
{
	ClipSprite *sprite = new ClipSprite();
    if (sprite && sprite->initWithFile(fileName))
    {
        sprite->autorelease();
        return sprite;
    }
    CC_SAFE_DELETE(sprite);
    return NULL;
}

bool ClipSprite::initWithFile(const char* fileName)
{
	bool res = CCSprite::initWithFile(fileName);
	if (res)
	{
		setClip(CCSize(1, 1));
	}
	return res;
}

void ClipSprite::setClip(CCSize size)
{
	m_clipSize = size;
}

void ClipSprite::setWidth(float width)
{
	 m_clipSize.width = width;
}

void ClipSprite::setHeight(float height)
{
	m_clipSize.height = height;
}

CCSize ClipSprite::getClipSize()
{
	return m_clipSize;
}

CCRect ClipSprite::getViewRect()
{
    CCPoint screenPos = this->convertToWorldSpace(CCPointZero);
    
	float scaleX = getScaleX();
	float scaleY = getScaleY();
    
    for (CCNode *p = m_pParent; p != NULL; p = p->getParent())
	{
        scaleX *= p->getScaleX();
        scaleY *= p->getScaleY();
    }

    if(scaleX<0.f)
	{
        screenPos.x += m_obContentSize.width * scaleX;
        scaleX = -scaleX;
    }
    if(scaleY<0.f)
	{
        screenPos.y += m_obContentSize.height * scaleY;
        scaleY = -scaleY;
    }

	return CCRectMake(screenPos.x, screenPos.y, m_obContentSize.width * scaleX * m_clipSize.width, m_obContentSize.height * scaleY * m_clipSize.height);
}

void ClipSprite::visit()
{
	CCRect frame = getViewRect();
	glEnable(GL_SCISSOR_TEST);
    CCEGLView::sharedOpenGLView()->setScissorInPoints(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
	CCSprite::visit();
	glDisable(GL_SCISSOR_TEST);
}

void ClipSprite::addChild(CCNode* pChild)
{
    CCNode::addChild(pChild);
}

void ClipSprite::addChild(CCNode *pChild, int zOrder)
{
    CCNode::addChild(pChild, zOrder);
}