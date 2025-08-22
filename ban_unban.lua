local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local soundService = game:GetService("SoundService")

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.9, -50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = screenGui

local buttonBlast = Instance.new("TextButton")
buttonBlast.Size = UDim2.new(0, 90, 0, 30)
buttonBlast.Position = UDim2.new(0, 10, 0, 10)
buttonBlast.Text = "Gaster Blast"
buttonBlast.Parent = frame

local buttonWall = Instance.new("TextButton")
buttonWall.Size = UDim2.new(0, 90, 0, 30)
buttonWall.Position = UDim2.new(0, 10, 0, 50)
buttonWall.Text = "Bone Wall"
buttonWall.Parent = frame

-- ===== Музыка =====
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://5700464468" -- <-- сюда вставь ID Last Breath Phase 2
sound.Looped = true
sound.Volume = 1
sound.Parent = soundService
sound:Play()

-- ===== Функции =====
local function createGasterBlast()
    local blast = Instance.new("Part")
    blast.Size = Vector3.new(1,1,1)
    blast.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)
    blast.Anchored = true
    blast.CanCollide = false
    blast.Parent = workspace

    local dmg = 30
    local connection
    connection = runService.Heartbeat:Connect(function()
        for _, other in pairs(game.Players:GetPlayers()) do
            if other ~= player and other.Character and other.Character:FindFirstChild("Humanoid") then
                local hrp = other.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (blast.Position - hrp.Position).Magnitude < 5 then
                    other.Character.Humanoid:TakeDamage(dmg * runService.Heartbeat:Wait())
                end
            end
        end
    end)

    game.Debris:AddItem(blast, 5)
    delay(5, function() connection:Disconnect() end)
end

local function createBoneWall()
    local wall = Instance.new("Part")
    wall.Size = Vector3.new(2,5,20)
    wall.Position = player.Character.HumanoidRootPart.Position + player.Character.HumanoidRootPart.CFrame.LookVector * 5
    wall.Anchored = true
    wall.CanCollide = true
    wall.BrickColor = BrickColor.new("White")
    wall.Parent = workspace

    local dmg = 30
    local connection
    connection = runService.Heartbeat:Connect(function()
        for _, other in pairs(game.Players:GetPlayers()) do
            if other ~= player and other.Character and other.Character:FindFirstChild("Humanoid") then
                local hrp = other.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (wall.Position - hrp.Position).Magnitude < 5 then
                    other.Character.Humanoid:TakeDamage(dmg * runService.Heartbeat:Wait())
                end
            end
        end
    end)

    game.Debris:AddItem(wall, 7)
    delay(7, function() connection:Disconnect() end)
end

-- ===== Кнопки =====
buttonBlast.MouseButton1Click:Connect(createGasterBlast)
buttonWall.MouseButton1Click:Connect(createBoneWall)
