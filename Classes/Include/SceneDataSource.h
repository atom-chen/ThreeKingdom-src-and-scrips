#ifndef __SCENE_DATA_SOURCE__
#define __SCENE_DATA_SOURCE__

#include "cocos2d.h"
#include "configTK.h"
#include "cocos-ext.h"
//#include "Include/UtilDirFinder.h"
#include "UtilTxtFile.h"

USING_NS_CC;
USING_NS_CC_EXT;

class SceneDataSource
{
public:
	SceneDataSource(void);
	virtual ~SceneDataSource(void);

	static SceneDataSource* sharedInstance();
	void loadSceneData(const char* sceneName);
	const char* openFile(const char* sceneName);
	CCArray* getAllResources();
	CCArray* getAllActors();
	float getSceneLength();

protected:
	CSJson::Value m_sceneData;

	void parseData(const char* content);
};

#endif