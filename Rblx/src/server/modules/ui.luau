local uiModule = {}
local CS = game:GetService("CollectionService")

local tag_name = ""
local Keys = {}

function uiModule:Start(tag: string)
  Keys = CS:GetTagged(tag)
end

function uiModule:UpdateKeyGui(use_uppercase: boolean, use_shift: boolean, swap_table)
  local KeySwapTable = swap_table

  if not Keys then return end
  
  for _, Key in ipairs(game:GetService("CollectionService"):GetTagged(tag_name)) do
    if Key:IsA("BasePart") and Key:HasTag("NoSwap") then
      local ui = Key:FindFirstChild("SurfaceGui")
      local tl = ui:FindFirstChild("TextLabel")
      
      if ui and tl and ui:IsA("SurfaceGui") and tl:IsA("TextLabel") then
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

function uiModule:CreateKeyGui()
  if not Keys then return end
  
  for _, Key in ipairs(Keys) do
    print(Key.Name)
  end
end

return uiModule
