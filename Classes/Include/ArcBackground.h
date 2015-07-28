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
	//��ʼ������
	static void initData();
	//�������α�������
	static ArcBackground* create(const char *imgName, float height, float angle, float scale);
	static float getDistanceHeight();
	//���ð뾶
	void setRadius(float radius);
	//���õ�λ�Ƕ�
	void setTileAngle(float angle);
	//������ת�ٶ�
	void setSpeed(float speed);
	//���ýǶ�
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