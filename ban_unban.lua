-- Ban / Unban GUI Script for Roblox (Cryptyc / Mobile)
-- Save this as ban_unban.lua in your GitHub or Gist

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- banned players list
local bannedPlayers = {}

-- check and kick
local function checkBan(player)
    if bannedPlayers[player.Name] then
        player:Kick("You are banned by admin.")
    end
end

Players.PlayerAdded:Connect(checkBan)

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(1, -10, 0, 30)
TextBox.Position = UDim2.new(0, 5, 0, 5)
TextBox.PlaceholderText = "Enter nickname"

local BanButton = Instance.new("TextButton", Frame)
BanButton.Size = UDim2.new(1, -10, 0, 40)
BanButton.Position = UDim2.new(0, 5, 0, 40)
BanButton.Text = "BAN"
BanButton.BackgroundColor3 = Color3.fromRGB(200,50,50)

local UnbanButton = Instance.new("TextButton", Frame)
UnbanButton.Size = UDim2.new(1, -10, 0, 40)
UnbanButton.Position = UDim2.new(0, 5, 0, 90)
UnbanButton.Text = "UNBAN"
UnbanButton.BackgroundColor3 = Color3.fromRGB(50,200,50)

-- buttons logic
BanButton.MouseButton1Click:Connect(function()
    local name = TextBox.Text
    local target = Players:FindFirstChild(name)
    if target then
        bannedPlayers[name] = true
        target:Kick("You are banned by admin.")
    end
end)

UnbanButton.MouseButton1Click:Connect(function()
    local name = TextBox.Text
    if bannedPlayers[name] then
        bannedPlayers[name] = nil
    end
end)
