//
//  TouchGesture.cpp
//  TouchOne
//
//  Created by WarmHeart  on 13-12-19.
//

#include "TouchGesture.h"

TouchGesture::TouchGesture()
{
	m_gestures = NULL;
}

TouchGesture::~TouchGesture()
{
	CC_SAFE_DELETE(m_gestures);
}

bool TouchGesture::init(const char* fileName, int handler)
{
      m_handler = handler;
      CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, false);
      CCDictionary* content = CCDictionary::createWithContentsOfFile(fileName);
	  m_gestures = (CCArray*)(content->objectForKey(PLIST_ROOT));
	  m_bTouchEnabled = true;
	  m_gestures->retain();
      return true;
}

TouchGesture* TouchGesture::create(const char* fileName, int handler)
{
	TouchGesture *pRet = new TouchGesture();
	if (pRet && pRet->init(fileName, handler))
	{
		pRet->autorelease();
		return pRet;
	}
	else
	{
		CC_SAFE_DELETE(pRet);
		return NULL;
	}
}

bool TouchGesture::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
      P1 = pTouch->getLocation();
      return true;
}

void TouchGesture::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{

}

double TouchGesture::aSIN(double X,double Y)
{
      return true;
}

 void TouchGesture::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
	P2 = pTouch->getLocation();
      //      CCPoint p=ccp(P2.y-P1.y,P2.x-P1.x);
	float angle = atan2f(P2.y - P1.y , P2.x - P1.x);
	float rotation = CC_RADIANS_TO_DEGREES(angle);
	int pt = ccpDistance(P1, P2);
      // AddJiaoDu(rotation,pt);
	int count = m_gestures->count();
	//CCLOG("angle----%f", rotation);
	for (int i = 0; i < count; i++)
	{
		CCDictionary* item = (CCDictionary*)m_gestures->objectAtIndex(i);
		float angleMin = item->valueForKey(ANGLE_MIN)->floatValue();
		float angleMax = item->valueForKey(ANGLE_MAX)->floatValue();
        
		if (rotation > angleMin && rotation <= angleMax)
		{
			float key = item->valueForKey(KEY_LENGTH)->floatValue();
                  
			if (pt > key)
			{
				int id = item->valueForKey(KEY_ID)->intValue();
				CCInteger* value = CCInteger::create(id);
				CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_handler, "ID", value, "CCInteger");
				break;
			}
		}
	}
}