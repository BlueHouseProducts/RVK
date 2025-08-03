--!strict
-- uro ;)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local main = require(script.modules.main) -- module that controls everything

-- Edit these if you need!!
local KeyTag: string = "Key" -- Tag all keys have, keys can also have the tag NoSwap to prevent them from swapping when <shift> is pressed
local PlaySoundInstance: RemoteEvent = ReplicatedStorage.PlaySound -- this event is fired whenever a key is pressed.
local NameOfPlayerUi: string = "PlayerUi"
local ToggleSwitch: BasePart = workspace.Main.keyboard.Switch

local HostUrl = "http://localhost:5000/" -- include a / at the end, point it to the root of the site, not a page.

local ShiftSwapTable = {
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

main:Start(KeyTag, PlaySoundInstance, NameOfPlayerUi, ShiftSwapTable, ToggleSwitch, HostUrl)
