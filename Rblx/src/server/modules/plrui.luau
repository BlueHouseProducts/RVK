-- Creates user Gui

local Players = game:GetService("Players")

local module = {}
local isUsingTypingUi = false
local typingUiName: string? = nil;
local loaded = false;

local UI_LABEL_NAME: string = "Label"  -- editting requires editting modulescript modules/main variable UI_LABEL_NAME

local function CreateGui(Player: Player, UiName: string)
  local ui = Instance.new("ScreenGui")
  ui.Parent = Player.PlayerGui
  ui.Name = UiName

  local label = Instance.new("TextLabel")
  label.Name = UI_LABEL_NAME
  label.Parent = ui

  label.AnchorPoint = Vector2.new(0, 1)
  label.Position = UDim2.fromScale(0, 1)
  label.Size = UDim2.fromOffset(333, 121)
  label.Text = ""
  label.TextScaled = true
end

function CreateTypeView(Player: Player, UiName: string)
  local ui = Instance.new("ScreenGui")
  ui.Parent = Player.PlayerGui
  ui.Name = UiName

  local label = Instance.new("TextLabel")
  label.Name = UI_LABEL_NAME
  label.Parent = ui

  label.AnchorPoint = Vector2.new(1, 1)
  label.Position = UDim2.fromScale(1, 1)
  label.Size = UDim2.fromOffset(400, 100)
  label.TextSize = 20
  label.Text = ""
  label.TextScaled = false
  label.TextWrapped = true
  label.AutomaticSize = Enum.AutomaticSize.Y

  local padding = Instance.new("UIPadding")
  padding.Parent = label

  local paddingUdim = UDim.new(0, 5)
  padding.PaddingTop = paddingUdim
  padding.PaddingLeft = paddingUdim
  padding.PaddingRight = paddingUdim
  padding.PaddingBottom = paddingUdim
end


function module:Setup(UiName: string, createTypingView: boolean, typingViewName: string?)
  if createTypingView and typingViewName then
    isUsingTypingUi = true
    typingUiName = typingViewName
  end
  
  Players.PlayerAdded:Connect(function(plr: Player)  
    CreateGui(plr, UiName)

    if createTypingView and typingViewName then
      if UiName == typingViewName then
        warn("Your typingViewName must not be equal to your UiName - Setup -- plrUi module")
      else
        CreateTypeView(plr, typingViewName)
      end
    end

    if createTypingView and not typingViewName then
      warn("To create typing view you must suply a typingViewName - Setup -- plrUi module")
    end
  end)

  loaded = true
end

function module.GetIsUsingTypingUi(): boolean
  if not loaded then 
    warn("plrui not loaded during GetIsUsingTypingUi call") 
  end
  
  return isUsingTypingUi
end

function module.GetTypingUiName(): string?
  if not loaded then 
    warn("plrui not loaded during GetTypingUi call") 
  end
  
  if module.GetIsUsingTypingUi() and typingUiName then
    return typingUiName
  end

  return
end

return module
