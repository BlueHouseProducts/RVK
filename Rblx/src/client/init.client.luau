--!strict
-- uro ;)

-- Plays the keyboard press sound when a key is pressed.

local event: RemoteEvent = game:GetService("ReplicatedStorage").PlaySound
local sound: Sound = workspace.Main.keyboard.keyPress

event.OnClientEvent:Connect(function()  
  sound:Play()
end)

