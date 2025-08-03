--!strict
-- uro ;)

local Collection = game:GetService("CollectionService")

local main = {}
local uiService = require(script.Parent.ui)
local htService = require(script.Parent.http)
local types = require(script.Parent.types)

local use_uppercase = false
local use_shift = false

local enabled = true
local recording = false
local record: types.Recording? = {}

local start_time: number? = nil
local swap_table: {[string]: string}? = nil

local url: string? = nil

local UI_LABEL_NAME: string = "Label"

local function CreateKeyEvent(detector: ClickDetector, Key: BasePart, h: Highlight, t: TextLabel, playerUiName: string, soundPlayEvent: RemoteEvent)
  detector.MouseHoverEnter:Connect(function(playerWhoClicked: Player) 
    h.Enabled = true
		
		if Key.Name == "UPPERCASE" then return end
		if Key.Name == "SHIFT" then return end
		
		(Key :: BasePart).BrickColor = BrickColor.new("Pearl")	
		t.TextColor3 = Color3.new(0, 0, 0)
		
    local ui = playerWhoClicked.PlayerGui:FindFirstChild(playerUiName)
    if not ui or not ui:IsA("ScreenGui") then return end

    local label = ui:FindFirstChild(UI_LABEL_NAME)
    if not label or not label:IsA("TextLabel") then return end
    label.Text = if use_uppercase then Key.Name:upper() else Key.Name:lower()
	end)
	
	detector.MouseHoverLeave:Connect(function(playerWhoClicked: Player) 
		h.Enabled = false
		
		if Key.Name == "UPPERCASE" then return end
		if Key.Name == "SHIFT" then return end
		
		(Key :: BasePart).BrickColor = BrickColor.new("Black")
		t.TextColor3 = Color3.new(1, 1, 1)
		
    local ui = playerWhoClicked.PlayerGui:FindFirstChild(playerUiName)
    if not ui or not ui:IsA("ScreenGui") then return end

    local label = ui:FindFirstChild(UI_LABEL_NAME)
    if not label or not label:IsA("TextLabel") then return end
    label.Text = if use_uppercase then Key.Name:upper() else Key.Name:lower()
	end)
	
	detector.MouseClick:Connect(function(playerWhoClicked: Player) 
		task.spawn(function() 
			soundPlayEvent:FireClient(playerWhoClicked);

			if Key.Name ~= "UPPERCASE" and Key.Name ~= "SHIFT" then 
				Key.BrickColor = BrickColor.new("Pastel green") 
			end
			
			Key.Position = Vector3.new(Key.Position.X, Key.Position.Y - 0.5, Key.Position.Z)
			
			task.wait(0.2);
			
			if Key.Name ~= "UPPERCASE" and Key.Name ~= "SHIFT" then 
				Key.BrickColor = BrickColor.new("Black") 
			end
			
			Key.Position = Vector3.new(Key.Position.X, Key.Position.Y + 0.5, Key.Position.Z)
		end)
		
		if not Key or not Key:IsA("BasePart") then
			return
		end
		
		if Key.Name == "UPPERCASE" then
			use_uppercase = not use_uppercase

			if use_uppercase then
				Key.Color = Color3.new(0, 1, 0)
			else
				Key.Color = Color3.new(1, 0, 0)
			end

      if not swap_table then return end
			
			uiService:UpdateKeyGui(use_uppercase, use_shift, swap_table)
			
			return
		end
		
		if Key.Name == "SHIFT" then
			use_shift = not use_shift

      if not swap_table then return end
			
			if use_shift then
				Key.BrickColor = BrickColor.new("Forest green")
			else
				Key.BrickColor = BrickColor.new("Persimmon")
			end
			
			uiService:UpdateKeyGui(use_uppercase, use_shift, swap_table :: {[string]: string})
			
			return
		end
		
		if not enabled then return end
		if not recording then return end
		if not start_time then return end
		
		local k: string = Key.Name

    if not record then
      record = {} 
    end
		
		table.insert(record :: types.Recording, {
			["Key"] = if use_uppercase or use_shift then k:upper() else k:lower(),
			["Time"] = time() - start_time
		});
	end)
end

local function SetupKeys(keys: types.KeyList, playerUiName: string, playSoundEvent: RemoteEvent)
  for _, Key in pairs(keys) do
    if not Key:IsA("BasePart") then continue end
    
    local h: Highlight = Instance.new("Highlight")
    h.Parent = Key
    h.Enabled = false
    h.FillColor = BrickColor.new("Pearl").Color
	  h.FillTransparency = 0.8

    local detector = Instance.new("ClickDetector")
    detector.Parent = Key

    local tl = uiService:CreateKeyGui(Key)

    CreateKeyEvent(detector, Key, h, tl, playerUiName, playSoundEvent)
  end
end

local function listenSwitchPress(switch: BasePart)
  recording = not recording

  if recording then
    switch.BrickColor = BrickColor.new("Really red")
    
    start_time = time()
  else
    switch.BrickColor = BrickColor.new("Lime green")

    enabled = false
    
    if record and url then
      htService:Start(record, url)
    end

    record = {}
    start_time = nil

    enabled = true
  end
end

function main:Start(key_tag: string, playSoundEvent: RemoteEvent, playerUiName: string, swapTable: {[string]: string}, listenSwitch: BasePart, given_url: string)
  local Keys = Collection:GetTagged(key_tag) :: types.KeyList
  
  url = given_url

  swap_table = swapTable
  record = {}

  uiService:Start(Keys)
  SetupKeys(Keys, playerUiName, playSoundEvent)

  local listenDetector = Instance.new("ClickDetector")
  listenDetector.Parent = listenSwitch

  uiService:UpdateKeyGui(use_uppercase, use_shift, swapTable)

  listenDetector.MouseClick:Connect(function()  
    listenSwitchPress(listenSwitch)
  end)
end

return main
