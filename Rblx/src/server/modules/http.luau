local module = {}
local types = require(script.Parent.types)

local httpService = game:GetService("HttpService")

local url = "";
local testAddition = "online"

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
  task.wait(record.Time)
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

function module:Test(): boolean
  if not url then return false end
  if url == "" then return false end

  local fullurl = url .. testAddition

  local success = pcall(function()  
    httpService:PostAsync(fullurl)
    return true
  end)

  return success
end

return module
