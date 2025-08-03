--!strict
-- uro ;)

-- Http
-- Contains methods to send data towards the python server and check if the server is up.

-- module:Start - :: Record (types.Record)
----------------- Starts sending info based on Record to the server to press keys.

-- module:Test - :: URL (string)
---------------- Sends a request to url .. "online" to check if the server is online.
---------------- URL: must include ending / e.g. http://localhost:5000/

-- module:SetupEditables - :: Editables (types.Editable)
-------------------------- Edits more settings such as typing playback speed. View more info in the `types` module.

local module = {}
local types = require(script.Parent.types)

local httpService = game:GetService("HttpService")

local url = "";

local Editables: types.Editable = {
	["UseTypeSpeedDivision"] = {
		["Enabled"] = false
	}
}

local function AttemptHTTP(data: string)
  local success, res = pcall(function()  
    httpService:PostAsync(url .. "useKey", data)
    return true
  end)

  if not success then
    warn("Failed to send: " .. tostring(res))
  end

  return success
end

local function RunHTTP(key: string): boolean
  local data: types.HTTPSendData = {
    ["req"] = "PressKey",
    ["key"] = key
  }
  
  local strdata = httpService:JSONEncode(data)
  
  return AttemptHTTP(strdata)
end

local function RecordHolder(record: types.Record)
  local realTime = if Editables.UseTypeSpeedDivision.Enabled then record.Time / Editables.UseTypeSpeedDivision.DivisionSpeed else record.Time
  
  task.wait(realTime)
  return RunHTTP(record.Key)
end

function module:Start(recording: types.Recording, given_url: string)
  url = given_url
  
  for i, record in pairs(recording) do
    task.spawn(function() 
      local res = RecordHolder(record)

      if not res then
        warn("1 key failed to send! || Key number " .. tostring(i))
        warn("Key: " .. record.Key .. " at " .. tostring(record.Time))
        warn("-----------------------------------")
      end
    end)
  end
end

function module:Test(given_url: string): boolean
  if not given_url then return false end
  if given_url == "" then return false end

  local fullurl = given_url .. "online"

  local success = pcall(function()  
    httpService:GetAsync(fullurl)
    return true
  end)

  return success
end

function module:SetupEditables(editables: types.Editable)
  Editables = editables
end

return module
