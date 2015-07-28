#include "Mission.h"

Mission::Mission()
{
	m_type = 0;
	m_count = 0;
	m_countMax = 0;
	m_time = 0;
}

Mission::~Mission()
{

}

Mission* Mission::create(const char* type)
{
	Mission* mission = new Mission();
	if (mission)
	{
		mission->init(type);
	}
	return mission;
}

void Mission::init(const char* type)
{
	m_type = type;
}

const char* Mission::getType()
{
	return m_type;
}

bool Mission::isComplete()
{
	return (m_count >= m_countMax);
}

void Mission::addCount(int num, const char* type)
{
	if (strcmp(m_type, type) == 0)
	{
		m_count += num;
	}
}

int Mission::getCount()
{
	return m_count;
}

void Mission::setCountMax(int num)
{
	m_countMax = num;
}

int Mission::getCountMax()
{
	return m_countMax;
}

void Mission::setTimeLimit(float time)
{
	m_time = time;
}

float Mission::getTimeLimit()
{
	return m_time;
}

void Mission::remove()
{
	delete this;
}