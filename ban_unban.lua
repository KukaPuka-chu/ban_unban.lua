-- Last Breath Sans Phase 2 – GUI + Способности + Музыка с текстурами и звуками

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

-- Фоновая музыка
local Music = Instance.new("Sound", workspace)
Music.SoundId = "rbxassetid://5621597815" -- Last Breath Phase 2 (Remastered)
Music.Volume = 5
Music.Looped = true

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Кнопка скрытия
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Утилита для создания кнопок
local function addButton(text, callback, order)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 50 + (order - 1) * 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.MouseButton1Click:Connect(callback)
end

-- Запуск или остановка музыки
local function toggleMusic()
    if Music.IsPlaying then
        Music:Stop()
    else
        Music:Play()
    end
end

-- Стена из костей
local function spawnBoneWall()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = LocalPlayer.Character.HumanoidRootPart.CFrame
    for i = -2, 2 do
        local bone = Instance.new("Part", workspace)
        bone.Size = Vector3.new(1, 8, 1)
        bone.Anchored = true
        bone.CFrame = root * CFrame.new(i * 2, 0, -8)
        bone.BrickColor = BrickColor.White()
        bone.Material = Enum.Material.Neon
        Debris:AddItem(bone, 5)
    end
end

-- Кость-меч
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

-- Самонаводящийся гастер-бластер
local function summonGasterBlaster()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return end
    local headPos = LocalPlayer.Character.Head.Position
    local blaster = Instance.new("Part", workspace)
    blaster.Size = Vector3.new(3, 3, 3)
    blaster.Anchored = true
    blaster.CFrame = CFrame.new(headPos + Vector3.new(0, 5, -8))
    blaster.BrickColor = BrickColor.new("Really black")

    local sfx = Instance.new("Sound", blaster)
    sfx.SoundId = "rbxassetid://345052019" -- Gaster Blaster Sound
    sfx.Volume = 3
    sfx:Play()

    local duration = 0
    local heartbeatConn
    heartbeatConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
        duration = duration + dt
        local nearest = nil
        local nearestDist = math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - blaster.Position).Magnitude
                if dist < nearestDist then
                    nearest = plr.Character.HumanoidRootPart
                    nearestDist = dist
                end
            end
        end
        if nearest then
            blaster.CFrame = CFrame.new(blaster.Position, nearest.Position)
            if nearestDist < 25 then
                local hum = nearest.Parent:FindFirstChild("Humanoid")
                if hum then hum:TakeDamage(15) end
            end
        end
        if duration > 3 then
            heartbeatConn:Disconnect()
            blaster:Destroy()
        end
    end)
end

-- Щит (ForceField)
local function spawnShield()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local ff = Instance.new("ForceField", LocalPlayer.Character)
    Debris:AddItem(ff, 5)
end

-- Добавляем кнопки
addButton("Toggle Music", toggleMusic, 1)
addButton("Bone Wall", spawnBoneWall, 2)
addButton("Bone Sword", equipBoneSword, 3)
addButton("Gaster Blaster", summonGasterBlaster, 4)
addButton("Shield", spawnShield, 5)

-- Сворачивание окна по клавише "P"
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.P then
        frame.Visible = not frame.Visible
    end
end)
