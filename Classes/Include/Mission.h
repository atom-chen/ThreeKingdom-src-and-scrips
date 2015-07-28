#ifndef __SCENE_MISSION__
#define __SCENE_MISSION__

#include <string.h>

class Mission
{
public:
	Mission();
	virtual ~Mission();

	static Mission* create(const char* type);
	void init(const char* type);
	void remove();

	const char* getType();
	bool isComplete();

	void addCount(int num, const char* type);
	int getCount();

	void setCountMax(int num);
	int getCountMax();

	void setTimeLimit(float time);
	float getTimeLimit();

protected:
	const char* m_type;
	int m_count;
	int m_countMax;
	float m_time;
};

#endif