//
//  TouchGesture.h
//  TouchOne
//
//  Created by WarmHeart  on 13-12-19.
//
//

#ifndef __TouchOne__TouchMoveHeng__
#define __TouchOne__TouchMoveHeng__

#include <iostream>
#include "cocos2d.h"
#include "math.h"

using namespace cocos2d;
using namespace std;

#define ANGLE_MAX "angle_max"
#define ANGLE_MIN "angle_min"
#define KEY_LENGTH "length"
#define KEY_ID "ID"
#define PLIST_ROOT "duiying"

class TouchGesture : public CCLayer
{
public:
//      CREATE_FUNC(TouchMoveHeng);
	TouchGesture();
	~TouchGesture();

	static TouchGesture* create(const char* fileName, int handler);
	virtual bool init(const char* fileName, int handler);
	double aSIN(double X, double Y);
      //触摸事件
	virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);

	//CCSprite* sp;
	CCPoint P1;
	CCPoint P2;
	CCPoint p3;
	int m_handler;
	CCArray* m_gestures;
};

#endif /* defined(__TouchOne__TouchMoveHeng__) */
