#ifndef __ARC_BACKGROUND__
#define __ARC_BACKGROUND__

#include "cocos2d.h"
#include "configTK.h"
#include "cocos-ext.h"
#include "Math.h"

USING_NS_CC;
USING_NS_CC_EXT;

#define BASE_RADIUS 2924.0
#define OFFSET_HEIGHT 400

class ArcBackground : public CCLayer
{
public:
	ArcBackground();
    virtual ~ArcBackground();
	//初始化数据
	static void initData();
	//创建弧形背景对象
	static ArcBackground* create(const char *imgName, float height, float angle, float scale);
	static float getDistanceHeight();
	//设置半径
	void setRadius(float radius);
	//设置单位角度
	void setTileAngle(float angle);
	//设置旋转速度
	void setSpeed(float speed);
	//设置角度
	void setRotation(float angle);

	float getAngle();
	float getRadius();
	float getSpeed();

	bool isRun();
	void start();
	void stop();

protected:
	float m_radius;
	float m_curAngle;
	float m_speed;
	float m_tileAngle;

	int m_spriteCount;
	int m_spriteIndex;

	bool m_isRun;
private:
	void createSprites(const char *imgName, float scale);
	virtual void update(float delta);
};


#endif