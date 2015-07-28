#ifndef __UTIL_TXT_FILE__
#define __UTIL_TXT_FILE__

#include <string>
#include "cocos2d.h"
using namespace std;
USING_NS_CC;

class UtilTxtFile
{
public:
	static unsigned char* openFile(const char* fileName, unsigned long* pSize);
	static void saveFile(const char* fileName, const char* content);
};

#endif