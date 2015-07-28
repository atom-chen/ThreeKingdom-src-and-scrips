#ifndef __ANIM_LODER__
#define __ANIM_LODER__

#include "cocos2d.h"
#include "cocos-ext.h"

using namespace cs;
USING_NS_CC;
USING_NS_CC_EXT;

class  AnimLoader
{
public:
	AnimLoader();
    virtual ~AnimLoader();

	static AnimLoader* sharedInstance();
	void loadAnimData(const char *resName);
	void loadAnimDataArray(CCArray* animArray);
	void setPath(const char *path);

	static CCArmature* createAnimation(const char *resName, const char *animName);
	static CCArmature* createAnimationOneTime(const char *resName, const char *animName);

	void removeAnim(CCArmature* armature, MovementEventType type, const char* name);

	void purge();
protected:
	const char* m_path;
};

#endif