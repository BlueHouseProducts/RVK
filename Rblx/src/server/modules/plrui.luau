-- Creates user Gui

local Players = game:GetService("Players")

local module = {}

local function CreateGui(Player: Player, UiName: string)
  local ui = Instance.new("ScreenGui")
  ui.Parent = Player.PlayerGui
  ui.Name = UiName

  local label = Instance.new("TextLabel")
  label.Name = "Label" -- editting requires editting modulescript modules/main variable UI_LABEL_NAME
  label.Parent = ui

  label.AnchorPoint = Vector2.new(0, 1)
  label.Position = UDim2.fromScale(0, 1)
  label.Size = UDim2.fromOffset(333, 121)
  label.Text = ""
  label.TextScaled = true
end


function module:Setup(UiName: string)
  Players.PlayerAdded:Connect(function(plr: Player)  
    CreateGui(plr, UiName)
  end)
end

return module
