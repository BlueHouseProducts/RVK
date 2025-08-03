--!strict
-- uro ;)

-- Plays the keyboard press sound when a key is pressed.

local event: RemoteEvent = game:GetService("ReplicatedStorage").PlaySound
local sound: Sound = workspace.Main.keyboard.keyPress

local SoundUrl: string = "rbxassetid://18998603679"

if (not sound.SoundId) or (sound.SoundId == "" )then
  sound.SoundId = SoundUrl
end

event.OnClientEvent:Connect(function()  
  sound:Play()
end)

