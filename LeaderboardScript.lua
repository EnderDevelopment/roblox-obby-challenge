-- LeaderboardScript.lua

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local leaderboardDataStore = DataStoreService:GetDataStore("ObbyLeaderboard")

local function updateLeaderboard()
    local leaderboardFrame = script.Parent:FindFirstChild("LeaderboardFrame")
    if not leaderboardFrame then return end
    
    local success, leaderboardData = pcall(function()
        return leaderboardDataStore:GetAsync("TopPlayers") or {}
    end)
    
    if not success then
        warn("Failed to load leaderboard data:", leaderboardData)
        return
    end
    
    -- Clear existing entries
    for _, child in ipairs(leaderboardFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Add new entries
    for i, playerData in ipairs(leaderboardData) do
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Player" .. i
        textLabel.Text = string.format("%d. %s - %.2f seconds", i, playerData.name, playerData.time)
        textLabel.Size = UDim2.new(1, 0, 0, 30)
        textLabel.Position = UDim2.new(0, 0, 0, (i-1)*30)
        textLabel.Parent = leaderboardFrame
    end
end

local function onPlayerFinished(player, time)
    local playerData = {
        name = player.Name,
        time = time
    }
    
    local success, existingData = pcall(function()
        return leaderboardDataStore:GetAsync("TopPlayers") or {}
    end)
    
    if not success then
        warn("Failed to load existing leaderboard data:", existingData)
        return
    end
    
    -- Add new player data
    table.insert(existingData, playerData)
    
    -- Sort by time (ascending)
    table.sort(existingData, function(a, b)
        return a.time < b.time
    end)
    
    -- Keep only top 10
    if #existingData > 10 then
        table.remove(existingData, 11)
    end
    
    -- Save updated data
    local saveSuccess, saveError = pcall(function()
        leaderboardDataStore:SetAsync("TopPlayers", existingData)
    end)
    
    if not saveSuccess then
        warn("Failed to save leaderboard data:", saveError)
    end
    
    updateLeaderboard()
end

-- Connect to the RemoteEvent
local leaderboardEvent = Instance.new("RemoteEvent")
leaderboardEvent.Name = "LeaderboardEvent"
leaderboardEvent.Parent = script

leaderboardEvent.OnServerEvent:Connect(function(player, time)
    onPlayerFinished(player, time)
end)

-- Initial update
updateLeaderboard()