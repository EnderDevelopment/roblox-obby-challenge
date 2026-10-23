-- ObstacleScript.lua

local obstacle = script.Parent

local function onPlayerTouched(otherPart)
    local character = otherPart.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        print("Player hit an obstacle!")
        -- You can add additional logic here, like playing a sound or giving the player a penalty
    end
end

obstacle.Touched:Connect(onPlayerTouched)