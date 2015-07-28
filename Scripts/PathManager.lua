function setCommonPath()
    PATH_SCRIPT_ROOT = "Scripts/"
    PATH_RES_ROOT = "Res/"
    PATH_AUDIO_ROOT = "Audio/"
    PATH_FONTS_ROOT = "fonts/"
    PATH_CCB_ROOT = "ccbres/"

    PATH_RES_ANIMATION = PATH_RES_ROOT .. "Animatons/"
    PATH_RES_IMAGES = PATH_RES_ROOT .. "Images/"
    PATH_RES_SCENES = PATH_RES_ROOT .. "Scenes/"
    PATH_RES_MAPS = PATH_RES_ROOT .. "Maps/"
    PATH_RES_DATA = PATH_RES_ROOT .. "Data/"
    PATH_RES_UI = PATH_RES_ROOT .. "UI/"
    PATH_RES_EVENTS = PATH_RES_ROOT .. "Events/"
    PATH_RES_AUDIO = PATH_RES_ROOT .. "Audio/"

    PATH_RES_ACTORS = PATH_RES_ANIMATION .. "Actors/"
    PATH_RES_HEROES = PATH_RES_ANIMATION .. "Heroes/"
    PATH_RES_EFFECTS = PATH_RES_ANIMATION .. "Effects/"
    PATH_RES_EMOTION = PATH_RES_ANIMATION .. "Emotion/"
    PATH_RES_OTHER = PATH_RES_ANIMATION .. "Other/"

    PATH_RES_IMG_UI = PATH_RES_IMAGES .. "UI/"

    PATH_CCB_ANIM = PATH_CCB_ROOT .. "Animation/"
    PATH_CCB_HEAD = PATH_CCB_ROOT .. "head/"

    PATH_SCRIPT_SCENE = PATH_SCRIPT_ROOT .. "Scene/"
    PATH_SCRIPT_AUDIO = PATH_SCRIPT_ROOT .. "Audio/"
    PATH_SCRIPT_ACTOR = PATH_SCRIPT_ROOT .. "Actor/"
    PATH_SCRIPT_UI = PATH_SCRIPT_ROOT .. "UI/"
    PATH_SCRIPT_DATA = PATH_SCRIPT_ROOT .. "Data/"
    PATH_SCRIPT_PLAYER = PATH_SCRIPT_ROOT .. "Player/"
    PATH_SCRIPT_SYSTEM = PATH_SCRIPT_ROOT .. "System/"

end

function loadScriptPath()
    local pathList = 
    {
        PATH_SCRIPT_ROOT,
        PATH_SCRIPT_SCENE,
        PATH_SCRIPT_AUDIO,
        PATH_SCRIPT_ACTOR,
        PATH_SCRIPT_UI,
        PATH_SCRIPT_DATA,
        PATH_SCRIPT_PLAYER,
        PATH_SCRIPT_SYSTEM
    }

    for i, path in ipairs(pathList) do
        package.path = package.path .. path .. "?.lua;";
    end
end