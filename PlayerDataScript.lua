-- PlayerDataScript.lua

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local playerDataStore = DataStoreService:GetDataStore("PlayerObbyData")

local function onPlayerAdded(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local bestTime = Instance.new("IntValue")
    bestTime.Name = "BestTime"
    bestTime.Value = 0
    bestTime.Parent = leaderstats
    
    -- Load player's best time
    local success, data = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        bestTime.Value = data.bestTime or 0
    end
    
    -- Update best time when player finishes the obby
    local function onObbyFinished(time)
        if bestTime.Value == 0 or time < bestTime.Value then
            bestTime.Value = time
            
            -- Save the new best time
            local saveSuccess, saveError = pcall(function()
                playerDataStore:SetAsync(player.UserId, {bestTime = time})
            end)
            
            if not saveSuccess then
                warn("Failed to save player data:", saveError)
            end
        end
    end
    
    -- Connect to the RemoteEvent
    local leaderboardEvent = game:GetService("ServerScriptService"):FindFirstChild("LeaderboardScript"):FindFirstChild("LeaderboardEvent")
    if leaderboardEvent then
        leaderboardEvent.OnServerEvent:Connect(function(_, time)
            onObbyFinished(time)
        end)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)