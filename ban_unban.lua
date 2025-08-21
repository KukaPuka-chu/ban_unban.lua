-- Last Breath Sans Phase 2 – GUI + Способности + Музыка

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

-- ===========================
-- Музыка, которая играет у всех
-- ===========================
local Music = Instance.new("Sound", workspace)
Music.SoundId = "rbxassetid://5700464468"  -- Last Breath Phase 2 (Remastered)
Music.Volume = 5
Music.Looped = true
Music:Play()

-- ===========================
-- GUI
-- ===========================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function addButton(text, callback, order)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 50 + (order - 1) * 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.MouseButton1Click:Connect(callback)
end

-- ===========================
-- Способности
-- ===========================
local function toggleMusic()
    if Music.IsPlaying then
        Music:Stop()
    else
        Music:Play()
    end
end

local function spawnBoneWall()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for i = -2, 2 do
        local bone = Instance.new("Part", workspace)
        bone.Size = Vector3.new(1, 8, 1)
        bone.Anchored = true
        bone.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(i * 2, 0, -8)
        bone.BrickColor = BrickColor.White()
        bone.Material = Enum.Material.Neon
        Debris:AddItem(bone, 5)
    end
end

local function equipBoneSword()
    if not LocalPlayer.Character then return end
    local tool = Instance.new("Tool")
    tool.Name = "Bone Sword"
    tool.RequiresHandle = true
    tool.Parent = LocalPlayer.Backpack
    local handle = Instance.new("Part", tool)
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 4, 1)
    handle.BrickColor = BrickColor.White()
    tool.Activated:Connect(function()
        local target = LocalPlayer:GetMouse().Target
        if target and target.Parent and target.Parent:FindFirstChildOfClass("Humanoid") and target.Parent ~= LocalPlayer.Character then
            target.Parent.Humanoid:TakeDamage(30)
        end
    end)
end

local function summonGasterBlaster()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    local headPos = char.Head.Position
    local blaster = Instance.new("Part", workspace)
    blaster.Size = Vector3.new(3, 3, 3)
    blaster.Anchored = true
    blaster.CFrame = CFrame.new(headPos + Vector3.new(0, 5, -8))
    blaster.BrickColor = BrickColor.new("Really black")
    local sound = Instance.new("Sound", blaster)
    sound.SoundId = "rbxassetid://345052019"  -- Gaster Blaster Sound
    sound.Volume = 3
    sound:Play()
    local timer = 0
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        timer += dt
        local nearest, dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - blaster.Position).Magnitude
                if d < dist then
                    nearest, dist = p.Character.HumanoidRootPart, d
                end
            end
        end
        if nearest then
            blaster.CFrame = CFrame.new(blaster.Position, nearest.Position)
            if dist < 25 then
                local hum = nearest.Parent:FindFirstChild("Humanoid")
                if hum then
                    hum:TakeDamage(15)
                end
            end
        end
        if timer > 3 then
            conn:Disconnect()
            blaster:Destroy()
        end
    end)
end

local function spawnShield()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local ff = Instance.new("ForceField", LocalPlayer.Character)
    Debris:AddItem(ff, 5)
end

-- ===========================
-- Кнопки
-- ===========================
addButton("Toggle Music", toggleMusic, 1)
addButton("Bone Wall", spawnBoneWall, 2)
addButton("Bone Sword", equipBoneSword, 3)
addButton("Gaster Blaster", summonGasterBlaster, 4)
addButton("Shield", spawnShield, 5)

-- ===========================
-- Управление GUI
-- ===========================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.P then
        frame.Visible = not frame.Visible
    end
end)
