#include "AnimLoader.h"
#include "CCSpriteFrameCacheHelper.h"

static AnimLoader* s_sharedAnimLoader = NULL;

AnimLoader::AnimLoader()
{
	m_path = 0;
}

AnimLoader::~AnimLoader()
{

}

AnimLoader* AnimLoader::sharedInstance()
{
	if (s_sharedAnimLoader == NULL)
    {
        s_sharedAnimLoader = new AnimLoader();
        if (!s_sharedAnimLoader)
        {
            CC_SAFE_DELETE(s_sharedAnimLoader);
        }
    }
    return s_sharedAnimLoader;
}

void AnimLoader::loadAnimData(const char *resName)
{
	//CCString* imageName = CCString::createWithFormat("%s%s0.png", m_path, resName);
	//CCString* plistName = CCString::createWithFormat("%s%s0.plist", m_path, resName);
	CCString* jsonName = CCString::createWithFormat("%s%s.ExportJson", m_path, resName);
	CCArmatureDataManager::sharedArmatureDataManager()->addArmatureFileInfo(jsonName->getCString());
}

void AnimLoader::loadAnimDataArray(CCArray* animArray)
{
	int count = animArray->count();
	for (int i = 0; i < count; i++)
	{
		CCString* resName = (CCString*)animArray->objectAtIndex(i);
		loadAnimData(resName->getCString());
	}
}

void AnimLoader::setPath(const char *path)
{
	m_path = path;
}

CCArmature* AnimLoader::createAnimation(const char *resName, const char *animName)
{
	CCArmature *armature = CCArmature::create(resName);
	armature->getAnimation()->play(animName, 0, 0, -1, 0);
	return armature;
}

CCArmature* AnimLoader::createAnimationOneTime(const char *resName, const char *animName)
{
	CCArmature *armature = CCArmature::create(resName);
	armature->getAnimation()->play(animName, 0, 0, 1, 0);
	armature->getAnimation()->setMovementEventCallFunc(armature, movementEvent_selector(AnimLoader::removeAnim));
	return armature;
}

void AnimLoader::removeAnim(CCArmature* armature, MovementEventType type, const char* name)
{
	if (type == COMPLETE)
	{
		armature->getAnimation()->stopMovementEventCallFunc();
		armature->removeFromParentAndCleanup(true);
	}
}

void AnimLoader::purge()
{
    CCSpriteFrameCacheHelper::sharedSpriteFrameCacheHelper()->purge();
	CCArmatureDataManager::sharedArmatureDataManager()->removeAll();
}