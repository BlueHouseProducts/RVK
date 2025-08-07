--!strict
-- uro ;)

-- Requirements
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local main = require(script.modules.main)
local plrui = require(script.modules.plrui) -- playerui controller


local KeyTag: string = "Key" -- Tag all keys have, keys can also have the tag NoSwap to prevent them from swapping when <shift> is pressed
local PlaySoundInstance: RemoteEvent = ReplicatedStorage.PlaySound -- this event is fired whenever a key is pressed.
local NameOfPlayerUi: string = "PlayerUi" -- Name of created PlayerUi (what players see on their screen that shows current hovered item)
local ToggleSwitch: BasePart = workspace.Main.keyboard.Switch -- points to the start/stop recording switch part.
local KeySoundId: string? = "rbxassetid://18998603679" -- key sound when pressed. leave blank for no sound

local HostUrl: string = "http://localhost:5000/" -- server url: include a / at the end, point it to the root of the site, not a page.

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
	["'"] = "@",
}


-- Should use Player ScreenGuis (may show `plrui not loaded during GetIsUsingTypingUi call` warning on place startup if disabled - thats fine)
local UseUi: boolean = true

-- Enable Typing feedback ScreenGuis (UseUi must be on)
local CreateFeedbackUi: boolean = true
local FeedbackUiName: string = "CurrentTextGui" -- Must be different to `NameOfPlayerUi`

if UseUi then
	plrui:Setup(NameOfPlayerUi, CreateFeedbackUi, FeedbackUiName)
end

main:Start(KeyTag, PlaySoundInstance, NameOfPlayerUi, ShiftSwapTable, ToggleSwitch, HostUrl, KeySoundId)


-- Vital Information
-- You can edit what keys do what by editting the Name of the Key - it is that easy!
-- The ShiftSwapTable shows what keys will swap to what.
-- Keys have the 'Key' tag
-- Keys with Tag 'NoSwap' will not swap.
-- All <caps lock> keys will be renamed to UPPERCASE keys on startup.
-- All <shift> keys will be renamed to SHIFT keys on startup.
-- All <ctrl> keys will be renamed to CTRL keys on startup.

-- Extra Information
-- Everything outside of these modules is optional
-- You do not need to call plrui:Setup. It just creates screengui. You can edit the screengui inside of plrui:CreateGui and plrui:CreateGui.


-- Extra Settings (e.g. make typing playback faster)
-- You can edit some more typing variables using the http:SetupEditables(editables: types.Editable) function. e.g. :
-- local http = require(script.modules.http)
-- local types = require(script.modules.types)
-- local editables: types.Editable = {
-- 	["UseTypeSpeedDivision"] = {
--		["Enabled"] = true,
--		["DivisionSpeed"] = 3,
--  },
--  ["Debug"] = true, -- enables debug messages (lua only with SendPerKey, lua and python with SendOrdered \/)
--  ["Delay"] = 0, -- delay before sending each key (in seconds)
--  ["HTTPSendType"] = "SendPerKey" -- SendPerKey sends each key to python at time to press, SendOrdered sends all keys to python which uses time to order them
-- 	}
-- } -- makes your resulting typing speed faster by dividing all wait times by 3
-- http:SetupEditables(editables)
-- see all settings at modules > types > Editable (type)
