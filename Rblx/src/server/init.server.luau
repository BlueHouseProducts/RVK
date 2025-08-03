--!strict
-- uro ;)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local main = require(script.modules.main) -- module that controls everything
local plrui = require(script.modules.plrui)

-- Edit these if you need!!
local KeyTag: string = "Key" -- Tag all keys have, keys can also have the tag NoSwap to prevent them from swapping when <shift> is pressed
local PlaySoundInstance: RemoteEvent = ReplicatedStorage.PlaySound -- this event is fired whenever a key is pressed.
local NameOfPlayerUi: string = "PlayerUi" -- Name of created PlayerUi (what players see on their screen that shows current hovered item)
local ToggleSwitch: BasePart = workspace.Main.keyboard.Switch

-- you can edit the sound played in StarterPlayerScripts>Client

local HostUrl: string = "http://localhost:5000/" -- include a / at the end, point it to the root of the site, not a page.

local ShiftSwapTable: {[string]: string} = {
	["1"] = "!",
	["2"] = '"',
	["3"] = "£",
	["4"] = "$",
	["5"] = "%",
	["6"] = "^",
	["7"] = "&",
	["8"] = "*",
	["9"] = "(",
	["0"] = ")",
	["-"] = "_",
	["+"] = "=",
	["["] = "{",
	["]"] = "}",
	["\\"] = "|",
	[";"] = ":",
	["#"] = "~",
	["'"] = "@"
}

-- You can create a ui of what you have typed on the keyboard with setting to true:
local CreateTypingView: boolean = false
local TypingViewGuiName: string = "CurrentTextGui"

plrui:Setup(NameOfPlayerUi, CreateTypingView, TypingViewGuiName)

-- You can edit some more typing variables using the http:SetupEditables(editables: types.Editable) function. e.g. :
-- local http = require(script.modules.http)
-- local types = require(script.modules.types)
-- local editables: types.Editable = {
-- 	["UseTypeSpeedDivision"] = {
--		["Enabled"] = true,
--		["DivisionSpeed"] = 3
-- 	}
-- } -- makes your resulting typing speed faster by dividing all wait times by 3
-- http:SetupEditables(editables)

main:Start(KeyTag, PlaySoundInstance, NameOfPlayerUi, ShiftSwapTable, ToggleSwitch, HostUrl)
