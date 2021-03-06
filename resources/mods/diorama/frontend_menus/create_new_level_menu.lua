--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local NumberEntryMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/number_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")
local TextEntryMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/text_entry_menu_item")

--------------------------------------------------
local function onFilenameChanged (menuItem, menu)
    -- if menuItem.value == "" then
    --     menu.createLevel:disable ()
    -- else
    --     menu.createLevel:enable ()
    -- end
end

--------------------------------------------------
local function onCreateLevelClicked (menuItem, menu)
    if menu.filename.value == nil or 
            menu.filename.value == "" or 
            dio.file.isExistingWorldFolder (menu.filename) then

        menu.warningLabel.text = "ERROR! Filename is not valid!"

    else

        local worldSettings =
        {
            path =              menu.filename.value,
            isNew =             true,
            shouldSave =        true,
        }

        local roomSettings =
        {
            path =                              "default/",
            randomSeed =                        menu.randomSeed.value,
            perlinSize =                        menu.perlinSize:getValueAsNumber (),
            perlinOctavesCount =                menu.perlinOctavesCount:getValueAsNumber (),
            perlinFrequency =                   menu.perlinFrequency:getValueAsNumber (),
            perlinAmplitude =                   menu.perlinAmplitude:getValueAsNumber (),
            solidityChanceChangePerY =          menu.solidityChanceChangePerY:getValueAsNumber (),
            solidityChanceOverallOffset =       menu.solidityChanceOverallOffset:getValueAsNumber (),
        }

        menu.loadingLevelMenu:recordWorldSettings (worldSettings, roomSettings)

        menu.warningLabel.text = ""
        return "loading_level_menu"
    end
end

--------------------------------------------------
local function onReturnToParentClicked ()
    return "single_player_top_menu"
end

--------------------------------------------------
local function onResetToDefaultsClicked (menuItem, menu)
    menu.perlinSize.value =                         "128"
    menu.perlinOctavesCount.value =                 "5"
    menu.perlinFrequency.value =                    "2"
    menu.perlinAmplitude.value =                    "0.5"
    menu.solidityChanceChangePerY.value =           "0.0"
    menu.solidityChanceOverallOffset.value =        "0.2"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose ()
    self.parent.onAppShouldClose (self)
    return "quitting_menu"
end

--------------------------------------------------
function c:onEnter (menus)
    self.loadingLevelMenu = menus.loading_level_menu

    if self.doesWorldAlreadyExistError then
        self.warningLabel.text = "World already exists. Please Rename it"
        self.doesWorldAlreadyExistError = nil
    end
end

--------------------------------------------------
function c:onExit ()
    self.warningLabel.text = ""
    self.loadingLevelMenu = nil
end

--------------------------------------------------
function c:recordWorldAlreadyExistsError ()
    self.doesWorldAlreadyExistError = true
end

--------------------------------------------------
return function ()

    local instance = MenuClass ("NEW LEVEL MENU")

    local properties =
    {
        loadingLevelMenu = nil,
        filename =                          TextEntryMenuItem ("Filename", onFilenameChanged, nil, "MyWorld", 16),
        randomSeed =                        TextEntryMenuItem ("Random Seed", nil, nil, "Wauteurz", 16),
        perlinSize =                        NumberEntryMenuItem ("Perlin Initial Size", nil, nil, 128, true),
        perlinOctavesCount =                NumberEntryMenuItem ("Octaves Count", nil, nil, 5, true),
        perlinFrequency =                   NumberEntryMenuItem ("Per Octave Frequency Mulitplier", nil, nil, 2, false),
        perlinAmplitude =                   NumberEntryMenuItem ("Per Octave Amplitude Multiplier", nil, nil, 0.5, false),
        solidityChanceChangePerY =          NumberEntryMenuItem ("Solidity Chance Change Per Y", nil, nil, 0.0, false),
        solidityChanceOverallOffset =       NumberEntryMenuItem ("Solidity Chance Overall Offset", nil, nil, 0.2, false),
        createLevel =                       ButtonMenuItem ("Create Level", onCreateLevelClicked),
        warningLabel =                      LabelMenuItem (""),
    }

    properties.warningLabel.color = 0xff8000ff

    Mixin.CopyTo (instance, properties)
    Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (BreakMenuItem ())

    instance:addMenuItem (properties.filename)
    instance:addMenuItem (properties.randomSeed)
    instance:addMenuItem (properties.perlinSize)
    instance:addMenuItem (properties.perlinOctavesCount)
    instance:addMenuItem (properties.perlinFrequency)
    instance:addMenuItem (properties.perlinAmplitude)
    instance:addMenuItem (properties.solidityChanceChangePerY)
    instance:addMenuItem (properties.solidityChanceOverallOffset)

    instance:addMenuItem (BreakMenuItem ())
    
    instance:addMenuItem (properties.createLevel)

    instance:addMenuItem (BreakMenuItem ())

    instance:addMenuItem (ButtonMenuItem ("Return To Parent Menu", onReturnToParentClicked))
    instance:addMenuItem (ButtonMenuItem ("Reset To Defaults", onResetToDefaultsClicked))

    instance:addMenuItem (properties.warningLabel)

    return instance
end
