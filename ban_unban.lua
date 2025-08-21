-- Ban/Unban GUI with player list + hide/show button

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- banned list (UserId)
local bannedPlayers = {}

-- check and kick
local function checkBan(player)
    if bannedPlayers[player.UserId] then
        player:Kick("You are banned by admin.")
    end
end

Players.PlayerAdded:Connect(checkBan)

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.Active = true
MainFrame.Draggable = true

-- Hide/Show button
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 60, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Hide"
ToggleButton.BackgroundColor3 = Color3.fromRGB(70,70,200)

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    MainFrame.Visible = visible
    ToggleButton.Text = visible and "Hide" or "Show"
end)

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Ban/Unban Menu"
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.TextColor3 = Color3.fromRGB(255,255,255)

-- Scrollable player list
local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Size = UDim2.new(1, -10, 1, -40)
PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.BackgroundColor3 = Color3.fromRGB(40,40,40)
PlayerList.ScrollBarThickness = 6

-- Function to refresh list
local function refreshList()
    PlayerList:ClearAllChildren()
    local y = 0
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Frame = Instance.new("Frame", PlayerList)
            Frame.Size = UDim2.new(1, -10, 0, 30)
            Frame.Position = UDim2.new(0, 5, 0, y)
            Frame.BackgroundColor3 = Color3.fromRGB(60,60,60)

            local NameLabel = Instance.new("TextLabel", Frame)
            NameLabel.Size = UDim2.new(0.5, 0, 1, 0)
            NameLabel.Text = player.Name
            NameLabel.BackgroundTransparency = 1
            NameLabel.TextColor3 = Color3.fromRGB(255,255,255)

            local BanBtn = Instance.new("TextButton", Frame)
            BanBtn.Size = UDim2.new(0.25, -2, 1, 0)
            BanBtn.Position = UDim2.new(0.5, 2, 0, 0)
            BanBtn.Text = "BAN"
            BanBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)

            local UnbanBtn = Instance.new("TextButton", Frame)
            UnbanBtn.Size = UDim2.new(0.25, -2, 1, 0)
            UnbanBtn.Position = UDim2.new(0.75, 2, 0, 0)
            UnbanBtn.Text = "UNBAN"
            UnbanBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)

            BanBtn.MouseButton1Click:Connect(function()
                bannedPlayers[player.UserId] = true
                player:Kick("You are banned by admin.")
            end)

            UnbanBtn.MouseButton1Click:Connect(function()
                bannedPlayers[player.UserId] = nil
            end)

            y = y + 35
        end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,0,y)
end

-- Refresh on join/leave
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

-- First refresh
refreshList()
