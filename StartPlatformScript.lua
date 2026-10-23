-- StartPlatformScript.lua

local startPlatform = script.Parent

local function onPlayerTouched(otherPart)
    local character = otherPart.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        print("Player started the obby!")
        -- You can add additional logic here, like starting a timer or giving the player a hint
    end
end

startPlatform.Touched:Connect(onPlayerTouched)