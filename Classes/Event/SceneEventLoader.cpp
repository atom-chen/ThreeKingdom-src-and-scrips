#include "SceneEventLoader.h"

static SceneEventLoader* s_sharedEventLoader = NULL;

SceneEventLoader::SceneEventLoader()
{
	m_eventData.clear();
	m_processHandler = 0;
	m_delProcessHandler = 0;
	m_createEventHandler = 0;
	m_removeEventHandler = 0;
	m_doBehaviorHandler = 0;
}

SceneEventLoader::~SceneEventLoader()
{
	m_eventData.clear();
}

SceneEventLoader* SceneEventLoader::sharedInstance()
{
	if (s_sharedEventLoader == NULL)
    {
        s_sharedEventLoader = new SceneEventLoader();
        if (!s_sharedEventLoader)
        {
            CC_SAFE_DELETE(s_sharedEventLoader);
        }
    }
    return s_sharedEventLoader;
}

void SceneEventLoader::loadEvents(const char* fileName)
{
	const char* content = openFile(fileName);
	parseData(content);
}

Value SceneEventLoader::getEventData()
{
	return m_eventData["events"];
}

const char* SceneEventLoader::openFile(const char* fileName)
{
	unsigned long size = 0;
	const char* content = (char*)UtilTxtFile::openFile(fileName, &size);

	if (!content)
	{
		CCLog("未发现事件文件%s", fileName);
	}

	return content;
}

void SceneEventLoader::parseData(const char* content)
{
	std::string strValue = content;
	m_eventData.clear();
	CSJson::Reader cReader;
    cReader.parse(strValue, m_eventData, true);
}

void SceneEventLoader::setProcessHandler(int handler)
{
	m_processHandler = handler;
}

int SceneEventLoader::getProcessHandler()
{
	return m_processHandler;
}

void SceneEventLoader::setDelProcessHandler(int handler)
{
	m_delProcessHandler = handler;
}

int SceneEventLoader::getDelProcessHandler()
{
	return m_delProcessHandler;
}

void SceneEventLoader::setCreateEventHandler(int handler)
{
	m_createEventHandler = handler;
}

int SceneEventLoader::getCreateEventHandler()
{
	return m_createEventHandler;
}

void SceneEventLoader::setRemoveEventHandler(int handler)
{
	m_removeEventHandler = handler;
}

int SceneEventLoader::getRemoveEventHandler()
{
	return m_removeEventHandler;
}

void SceneEventLoader::setDoBehaviorHandler(int handler)
{
	m_doBehaviorHandler = handler;
}

int SceneEventLoader::getDoBehaviorHandler()
{
	return m_doBehaviorHandler;
}

void SceneEventLoader::setCreateActorHandler(int handler)
{
	m_createActorHandler = handler;
}

int SceneEventLoader::getCreateActorHandler()
{
	return m_createActorHandler;
}

void SceneEventLoader::setCreateCountHandler(int handler)
{
	m_createCountHandler = handler;
}

int SceneEventLoader::getCreateCountHandler()
{
	return m_createCountHandler;
}

void SceneEventLoader::setCreateMissionHandler(int handler)
{
	m_createMissionHandler = handler;
}

int SceneEventLoader::getCreateMissionHandler()
{
	return m_createMissionHandler;
}

void SceneEventLoader::setMissionTimeHandler(int handler)
{
	m_missionTimeHandler = handler;
}

int SceneEventLoader::getMissionTimeHandler()
{
	return m_missionTimeHandler;
}

void SceneEventLoader::setMissionCountHandler(int handler)
{
	m_missionCountHandler = handler;
}

int SceneEventLoader::getMissionCountHandler()
{
	return m_missionCountHandler;
}

void SceneEventLoader::setRemoveMissionHandler(int handler)
{
	m_removeMissionHandler = handler;
}

int SceneEventLoader::getRemoveMissionHandler()
{
	return m_removeMissionHandler;
}

void SceneEventLoader::setAddMissionCountHandler(int handler)
{
	m_addMissionCountHandler = handler;
}

int SceneEventLoader::getAddMissionCountHandler()
{
	return m_addMissionCountHandler;
}

void SceneEventLoader::setRandomCountHandler(int handler)
{
	m_randomCountHandler = handler;
}

int SceneEventLoader::getRandomCountHandler()
{
	return m_randomCountHandler;
}

void SceneEventLoader::setModifyHPHandler(int handler)
{
	m_modifyHPHandler = handler;
}

int SceneEventLoader::getModifyHPHandler()
{
	return m_modifyHPHandler;
}

void SceneEventLoader::setGiveMoneyHandler(int handler)
{
	m_giveMoneyHandler = handler;
}

int SceneEventLoader::getGiveMoneyHandler()
{
	return m_giveMoneyHandler;
}

void SceneEventLoader::setWinHandler(int handler)
{
	m_winHandler = handler;
}

int SceneEventLoader::getWinHandler()
{
	return m_winHandler;
}

void SceneEventLoader::setSkillHandler(int handler)
{
	m_skillHandler = handler;
}

int SceneEventLoader::getSkillHandler()
{
	return m_skillHandler;
}

void SceneEventLoader::setDelSkillHandler(int handler)
{
	m_delSkillHandler = handler;
}

int SceneEventLoader::getDelSkillHandler()
{
	return m_delSkillHandler;
}

void SceneEventLoader::setActiveSceneHandler(int handler)
{
	m_activeSceneHandler = handler;
}

int SceneEventLoader::getActiveSceneHandler()
{
	return m_activeSceneHandler;
}

void SceneEventLoader::setEmotionHandler(int handler)
{
	m_emotionHandler = handler;
}

int SceneEventLoader::getEmotionHandler()
{
	return m_emotionHandler;
}

void SceneEventLoader::setDialogHandler(int handler)
{
	m_dialogHandler = handler;
}

int SceneEventLoader::getDialogHandler()
{
	return m_dialogHandler;
}

void SceneEventLoader::setEventCreateHandler(int handler)
{
	m_setCreateEventHandler = handler;
}

int SceneEventLoader::getEventCreateHandler()
{
	return m_setCreateEventHandler;
}

void SceneEventLoader::setAddItemHandler(int handler)
{
	m_addItemHandler = handler;
}

int SceneEventLoader::getAddItemHandler()
{
	return m_addItemHandler;
}

void SceneEventLoader::setDelItemHandler(int handler)
{
	m_delItemHandler = handler;
}

int SceneEventLoader::getDelItemHandler()
{
	return m_delItemHandler;
}

void SceneEventLoader::setAttachItemCountTargetHandler(int handler)
{
	m_attachItemCountHandler = handler;
}

int SceneEventLoader::getAttachItemCountTargetHandler()
{
	return m_attachItemCountHandler;
}

void SceneEventLoader::setSetInvalidHandler(int handler)
{
	m_setInvalidHandler = handler;
}

int SceneEventLoader::getSetInvalidHandler()
{
	return m_setInvalidHandler;
}

void SceneEventLoader::setActiveHeroHandler(int handler)
{
	m_activeHeroHandler = handler;
}

int SceneEventLoader::getActiveHeroHandler()
{
	return m_activeHeroHandler;
}