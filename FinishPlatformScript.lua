-- FinishPlatformScript.lua

local finishPlatform = script.Parent

local function onPlayerTouched(otherPart)
    local character = otherPart.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        print("Player finished the obby!")
        -- You can add additional logic here, like displaying a victory message or teleporting the player
    end
end

finishPlatform.Touched:Connect(onPlayerTouched)