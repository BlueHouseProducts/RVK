--!strict
-- uro ;)

-- Main
-- Puts all other modules together, and also has the core key pressing and animation functionality.

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

local IsUsingTypingUi: boolean = false
local TypingUi: string? = nil;
local plruifr = require(script.Parent.plrui)

local using_audio: boolean = false
local audio_id: string? = nil

local uppercase_keys: {BasePart} = {}
local shift_keys: {BasePart} = {}

local function EditUi(key: string, plr: Player, toGreyOut: boolean)		
	if not TypingUi then
		IsUsingTypingUi = false
		return
	end

	local ui = plr.PlayerGui:FindFirstChild(TypingUi)

	if (not ui) or (not ui:IsA("ScreenGui")) then
		IsUsingTypingUi = false
		return
	end

	local label = ui:FindFirstChild(UI_LABEL_NAME)

	if (not label) or (not label:IsA("TextLabel")) then
		IsUsingTypingUi = false
		return
	end

	local lower_key = key:lower()

	local old_str = label.Text
	local new_str = ""

	if lower_key == "<backspace>" then
		new_str = string.sub(old_str, 1, #old_str - 1)
	elseif lower_key == "<return>" then
		new_str = old_str .. "\n"
		label.TextXAlignment = Enum.TextXAlignment.Left
	elseif lower_key == "<space>" then
		new_str = old_str .. " "
	else
		new_str = old_str .. key
	end

	label.Text = new_str

	if toGreyOut then
		label.TextColor3 = Color3.new(0.3, 0.3, 0.3)
	else
		label.TextColor3 = Color3.new(0, 0, 0)
	end
end

local function ClearUi(plr: Player)
	if not TypingUi then
		IsUsingTypingUi = false
		return
	end

	local ui = plr.PlayerGui:FindFirstChild(TypingUi)

	if (not ui) or (not ui:IsA("ScreenGui")) then
		IsUsingTypingUi = false
		return
	end

	local label = ui:FindFirstChild(UI_LABEL_NAME)

	if (not label) or (not label:IsA("TextLabel")) then
		IsUsingTypingUi = false
		return
	end

	label.Text = ""
end

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

			if audio_id and using_audio then
				local Sound = Instance.new("Sound")
				Sound.Parent = workspace
				Sound.Name = "KeyPressAudio"
				Sound.SoundId = audio_id
				Sound.Volume = 2
				Sound:Play()

				Sound.Ended:Connect(function()  
					Sound:Destroy()
				end)
			end

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
				for _, NewKey in ipairs(uppercase_keys) do
					if NewKey.Name == "UPPERCASE" then
						if NewKey:IsA("BasePart") then
							NewKey.Color = Color3.new(0, 1, 0)
						end
					end
				end
			else
				for _, NewKey in ipairs(uppercase_keys) do
					if NewKey.Name == "UPPERCASE" then
						if NewKey:IsA("BasePart") then
							NewKey.Color = Color3.new(1, 0, 0)
						end
					end
				end
			end

      if not swap_table then return end
			
			uiService:UpdateKeyGui(use_uppercase, use_shift, swap_table)
			
			return
		end
		
		if Key.Name == "SHIFT" then
			use_shift = not use_shift

      if not swap_table then return end

			if use_shift then
				for _, NewKey in ipairs(uppercase_keys) do
					if NewKey.Name == "SHIFT" then
						if NewKey:IsA("BasePart") then
							NewKey.BrickColor = BrickColor.new("Forest green")
						end
					end
				end
			else
				for _, NewKey in ipairs(shift_keys) do
					if NewKey.Name == "SHIFT" then
						if NewKey:IsA("BasePart") then
							NewKey.BrickColor = BrickColor.new("Persimmon")
						end
					end
				end
			end
			
			uiService:UpdateKeyGui(use_uppercase, use_shift, swap_table :: {[string]: string})
			
			return
		end

		local k: string = Key.Name
		local temp_uppercase: boolean = use_shift

		if string.match(k, "%w+") and use_shift then
			use_shift = false
			temp_uppercase = true
			uiService:UpdateKeyGui(false, false, swap_table :: {[string]: string})
		end

		if IsUsingTypingUi and (not enabled or not recording) then
			EditUi(if use_uppercase or use_shift or temp_uppercase then k:upper() else k:lower(), playerWhoClicked, true)
		end
		
		if not start_time then return end
		if not recording then return end
		if not enabled then return end

    if not record then
      record = {} 
    end
		
		table.insert(record :: types.Recording, {
			["Key"] = if use_uppercase or use_shift or temp_uppercase then k:upper() else k:lower(),
			["Time"] = time() - start_time
		});

		if IsUsingTypingUi then
			EditUi(if use_uppercase or use_shift then k:upper() else k:lower(), playerWhoClicked, false)
		end
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

		if Key.Name == "<caps lock>" then
			Key.Name = "UPPERCASE"
		end

		if Key.Name == "<shift>" then
			Key.Name = "SHIFT"
		end

		if Key.Name == "UPPERCASE" then
			Key.Color = Color3.new(1, 0, 0)
			table.insert(uppercase_keys, Key)
		end

		if Key.Name == "SHIFT" then
			Key.BrickColor = BrickColor.new("Persimmon")
			table.insert(shift_keys, Key)
		end

    local tl = uiService:CreateKeyGui(Key)

    CreateKeyEvent(detector, Key, h, tl, playerUiName, playSoundEvent)
  end
end

local function listenSwitchPress(switch: BasePart, plr: Player)
  recording = not recording
	ClearUi(plr)

  if recording then
    switch.BrickColor = BrickColor.new("Really red")
    
    start_time = time()
  else
    switch.BrickColor = BrickColor.new("Lime green")

    enabled = false

		if not url then
			warn("No url was given for the server address. Defaulting to http://localhost:5000")
		end

		local isOnline: boolean = htService:Test(url or "http://localhost:5000/")
    
    if record and isOnline then
			htService:Start(record, url or "http://localhost:5000/")
    end

		if not isOnline then
			warn("Keyboard playback did not start as the server is not up on " .. (url or "http://localhost:5000 (default url)"))
		end

    record = {}
    start_time = nil

    enabled = true
  end
end

function main:Start(key_tag: string, playSoundEvent: RemoteEvent, playerUiName: string, swapTable: {[string]: string}, listenSwitch: BasePart, given_url: string, key_sound_id: string?)
  local Keys = Collection:GetTagged(key_tag) :: types.KeyList
  
  url = given_url

  swap_table = swapTable
  record = {}

  uiService:Start(Keys)
  SetupKeys(Keys, playerUiName, playSoundEvent)

  local listenDetector = Instance.new("ClickDetector")
  listenDetector.Parent = listenSwitch

  uiService:UpdateKeyGui(use_uppercase, use_shift, swapTable)

  listenDetector.MouseClick:Connect(function(p: Player)  
    listenSwitchPress(listenSwitch, p)
  end)

	if plruifr.GetIsUsingTypingUi() then		
		IsUsingTypingUi = true
		TypingUi = plruifr.GetTypingUiName()
	end

	if key_sound_id then
		using_audio = true
		audio_id = key_sound_id
	end
end

return main
