#include "SceneDataSource.h"

static SceneDataSource* s_sharedSceneDataSource = NULL;

SceneDataSource::SceneDataSource(void)
{
	m_sceneData.clear();
}

SceneDataSource::~SceneDataSource(void)
{
	m_sceneData.clear();
}

SceneDataSource* SceneDataSource::sharedInstance()
{
    if (s_sharedSceneDataSource == NULL)
    {
        s_sharedSceneDataSource = new SceneDataSource();
        if (!s_sharedSceneDataSource)
        {
            CC_SAFE_DELETE(s_sharedSceneDataSource);
        }
    }
    return s_sharedSceneDataSource;
}

void SceneDataSource::loadSceneData(const char* sceneName)
{
	const char* content = openFile(sceneName);
	parseData(content);
}

const char* SceneDataSource::openFile(const char* sceneName)
{
	unsigned long size = 0;
	const char* content = (char*)UtilTxtFile::openFile(sceneName, &size);

	if (!content)
	{
		CCLog("未发现场景文件%s", sceneName);
	}

	return content;
}

void SceneDataSource::parseData(const char* content)
{
	std::string strValue = content;
	m_sceneData.clear();
	CSJson::Reader cReader;
    cReader.parse(strValue, m_sceneData, true);
}

CCArray* SceneDataSource::getAllResources()
{
	CCArray* nameList = CCArray::create();
	std::vector<std::string> names = m_sceneData["Resources"].getMemberNames();
	int count = names.size();
	for (int i = 0; i < count; i++)
	{
		CCString* resName = CCString::create(names[i]);
		nameList->addObject(resName);
	}
	return nameList;
}

CCArray* SceneDataSource::getAllActors()
{
	CCArray* actorList = CCArray::create();
	int count = m_sceneData["Actors"].size();
	for (int i = 0; i < count; i++)
	{
		CCDictionary* actor = CCDictionary::create();
		CCString* type = CCString::create(m_sceneData["Actors"][i]["type"].asCString());
		CCFloat* angle = CCFloat::create(m_sceneData["Actors"][i]["angle"].asFloat());
		CCFloat* height = CCFloat::create(m_sceneData["Actors"][i]["height"].asFloat());
		CCString* res = CCString::create(m_sceneData["Actors"][i]["res"].asCString());
		CCInteger* z = CCInteger::create(m_sceneData["Actors"][i]["z"].asInt());
		CCBool* flip = CCBool::create(m_sceneData["Actors"][i]["flip"].asBool());
		actor->setObject(type, "type");
		actor->setObject(angle, "angle");
		actor->setObject(height, "height");
		actor->setObject(res, "res");
		actor->setObject(z, "z");
		actor->setObject(flip, "flip");
		if (!m_sceneData["Actors"][i]["event"].isNull())
		{
			CCString* eventName = CCString::create(m_sceneData["Actors"][i]["event"].asCString());
			actor->setObject(eventName, "event");
		}
		actorList->addObject(actor);
	}
	return actorList;
}

float SceneDataSource::getSceneLength()
{
	return m_sceneData["Length"].asFloat();
}