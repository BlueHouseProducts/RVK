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
  local data = httpService:JSONEncode({
    ["req"] = "PressKey",
    ["key"] = key
  })
  
  return AttemptHTTP(data)
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
