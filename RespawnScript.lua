local Players = game:GetService("Players")

local function onPlayerAdded(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local function onDied()
        wait(3) -- Wait for 3 seconds before respawning
        player:LoadCharacter()
    end

    humanoid.Died:Connect(onDied)
end

Players.PlayerAdded:Connect(onPlayerAdded)