#ifndef __SCENE_EVENT_LOADER__
#define __SCENE_EVENT_LOADER__

#include "cocos2d.h"
#include "cocos-ext.h"
#include "UtilTxtFile.h"

USING_NS_CC;
USING_NS_CC_EXT;
using namespace CSJson;

class SceneEventLoader
{
public:
	SceneEventLoader();
	virtual ~SceneEventLoader();

	static SceneEventLoader* sharedInstance();
	
	void loadEvents(const char* fileName);
	Value getEventData();

	void setProcessHandler(int handler);
	int getProcessHandler();
	void setDelProcessHandler(int handler);
	int getDelProcessHandler();
	void setCreateEventHandler(int handler);
	int getCreateEventHandler();
	void setRemoveEventHandler(int handler);
	int getRemoveEventHandler();
	void setDoBehaviorHandler(int handler);
	int getDoBehaviorHandler();
	void setCreateActorHandler(int handler);
	int getCreateActorHandler();
	void setCreateCountHandler(int handler);
	int getCreateCountHandler();
	void setRandomCountHandler(int handler);
	int getRandomCountHandler();
	void setCreateMissionHandler(int handler);
	int getCreateMissionHandler();
	void setMissionTimeHandler(int handler);
	int getMissionTimeHandler();
	void setMissionCountHandler(int handler);
	int getMissionCountHandler();
	void setRemoveMissionHandler(int handler);
	int getRemoveMissionHandler();
	void setAddMissionCountHandler(int handler);
	int getAddMissionCountHandler();
	void setModifyHPHandler(int handler);
	int getModifyHPHandler();
	void setGiveMoneyHandler(int handler);
	int getGiveMoneyHandler();
	void setWinHandler(int handler);
	int getWinHandler();
	void setSkillHandler(int handler);
	int getSkillHandler();
	void setDelSkillHandler(int handler);
	int getDelSkillHandler();
	void setActiveSceneHandler(int handler);
	int getActiveSceneHandler();
	void setEmotionHandler(int handler);
	int getEmotionHandler();
	void setDialogHandler(int handler);
	int getDialogHandler();
	void setEventCreateHandler(int handler);
	int getEventCreateHandler();
	void setAddItemHandler(int handler);
	int getAddItemHandler();
	void setDelItemHandler(int handler);
	int getDelItemHandler();
	void setAttachItemCountTargetHandler(int handler);
	int getAttachItemCountTargetHandler();
	void setSetInvalidHandler(int handler);
	int getSetInvalidHandler();
	void setActiveHeroHandler(int handler);
	int getActiveHeroHandler();

protected:
	Value m_eventData;
	int m_processHandler;
	int m_delProcessHandler;
	int m_createEventHandler;
	int m_removeEventHandler;
	int m_doBehaviorHandler;
	int m_createActorHandler;
	int m_createCountHandler;
	int m_createMissionHandler;
	int m_missionTimeHandler;
	int m_missionCountHandler;
	int m_removeMissionHandler;
	int m_addMissionCountHandler;
	int m_randomCountHandler;
	int m_modifyHPHandler;
	int m_giveMoneyHandler;
	int m_winHandler;
	int m_skillHandler;
	int m_delSkillHandler;
	int m_activeSceneHandler;
	int m_emotionHandler;
	int m_dialogHandler;
	int m_setCreateEventHandler;
	int m_addItemHandler;
	int m_delItemHandler;
	int m_attachItemCountHandler;
	int m_setInvalidHandler;
	int m_activeHeroHandler;

	const char* openFile(const char* fileName);
	void parseData(const char* content);
};

#endif