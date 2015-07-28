#ifndef __CLIP_SPRITE__
#define __CLIP_SPRITE__

#include "cocos2d.h"

USING_NS_CC;

class ClipSprite : public CCSprite
{
public:
	ClipSprite();
	~ClipSprite();

	static ClipSprite* create(const char* fileName);
	bool initWithFile(const char* fileName);
	void setClip(CCSize size);
	void setWidth(float width);
	void setHeight(float height);

	CCSize getClipSize();

	void addChild(CCNode* pChild);
	void addChild(CCNode *pChild, int zOrder);
protected:
	CCRect getViewRect();
	void visit();

	CCSize m_clipSize;
};

#endif