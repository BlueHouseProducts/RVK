--!strict
-- uro ;)

local uiModule = {}
local types = require(script.Parent.types)

local Keys: types.KeyList? = {}

function uiModule:Start(KeysGiven)
  Keys = KeysGiven
end

function uiModule:UpdateKeyGui(use_uppercase: boolean, use_shift: boolean, swap_table: {[string]: string})
  local KeySwapTable = swap_table

  if not Keys then return end
  
  for _, Key in pairs(Keys) do
    if Key:IsA("BasePart") and not Key:HasTag("NoSwap") then
      local ui = Key:FindFirstChild("SurfaceGui")
      if not ui then continue end

      local tl = ui:FindFirstChild("TextLabel")
      
      if tl and ui:IsA("SurfaceGui") and tl:IsA("TextLabel") then
        local K = Key :: BasePart;
        if K.Name == "SHIFT" or K.Name == "UPPERCASE" then continue end
        
        if use_uppercase then
          if tl.Text:find("<") and tl.Text:find(">") then continue end
          tl.Text = K.Name:upper()
        else
          if tl.Text:find("<") and tl.Text:find(">") then continue end
          tl.Text = K.Name:lower()
        end
        
        if use_shift then          
          K.Name = KeySwapTable[K.Name] or K.Name;
          (tl :: TextLabel).Text = K.Name
        else
          for swap, old in pairs(KeySwapTable) do
            if old == K.Name then
              (K :: any).Name = swap;
              (tl :: TextLabel).Text = swap
              break
            end
          end
        end
      end
    end
	end
end

function uiModule:CreateKeyGui(Key: BasePart): TextLabel
  local r = Instance.new("SurfaceGui")
	r.Face = Enum.NormalId.Top
	r.AlwaysOnTop = true
	r.Parent = Key
	
	r.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	r.PixelsPerStud = 50
	
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.Text = Key.Name
	t.BackgroundTransparency = 1
	t.Parent = r
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextScaled = true

  t.Text = Key.Name

  return t
end

return uiModule
