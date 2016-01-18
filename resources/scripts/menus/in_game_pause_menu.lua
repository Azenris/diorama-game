--------------------------------------------------
local BreakMenuItem = require ("resources/scripts/menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/scripts/menus/menu_items/button_menu_item")
local Menus = require ("resources/scripts/menus/menu_construction")
local MenuClass = require ("resources/scripts/menus/menu_class")
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function onResumeClicked (self)
	return "playing_game_menu"
end

--------------------------------------------------
local function onReturnToMainMenuClicked (self)
	dio.session.terminate ()
	return "saving_game_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onAppShouldClose ()
	dio.session.terminate ()
	self.parent.onAppShouldClose (self)
	return "quitting_menu"
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)

	-- local keyCodeClicked = dio.inputs.keys.consumeKeyCodeClicked ()
	-- if keyCodeClicked and (keyCodeClicked == dio.inputs.keyCodes.ESCAPE) then
	-- 	return "playing_game_menu"
	-- end

	return self.parent.onUpdate(self, x, y, was_left_clicked)
end

--------------------------------------------------
function c:onKeyCodeClicked (keyCode, menus)

	local keyCodes = dio.inputs.keyCodes
	
	if keyCode == keyCodes.ESCAPE then
		menus.next_menu_name = "playing_game_menu"
		return true
	end
end

--------------------------------------------------
return function ()
	local instance = MenuClass ("IN GAME PAUSE MENU")

	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Resume", onResumeClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onReturnToMainMenuClicked))	
	instance:addMenuItem (BreakMenuItem ())

	return instance
end
