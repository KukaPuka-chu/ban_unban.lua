loadstring(game:HttpGet("https://raw.githubusercontent.com/KukaPuka-chu/ban_unban.lua/refs/heads/main/ban_unban.lua"))()

-- Пример добавления Гастер-бластера с текстурой и уроном
local function spawnBlaster(position, color, damage)
    local blaster = Instance.new("Part")
    blaster.Size = Vector3.new(3,3,3)
    blaster.Position = position
    blaster.Anchored = true
    blaster.CanCollide = false
    blaster.Parent = workspace

    local decal = Instance.new("Decal", blaster)
    decal.Texture = "https://i.supaimg.com/43eab1e1-08f6-4a79-acf9-5b458354040a.png"

    -- Самонаведение
    game:GetService("RunService").RenderStepped:Connect(function()
        if blaster.Parent then
            local player = game.Players.LocalPlayer
            blaster.CFrame = CFrame.new(blaster.Position, player.Character.Head.Position)
            -- Нанесение урона при контакте
            for _, target in pairs(workspace:GetChildren()) do
                if target:FindFirstChild("Humanoid") and target ~= player.Character then
                    if (target.HumanoidRootPart.Position - blaster.Position).Magnitude < 3 then
                        target.Humanoid:TakeDamage(damage * (1/60)) -- урон 30 ед/сек
                    end
                end
            end
        end
    end)
end

-- Пример стены из костей
local function spawnBoneWall(position, lookVector, damage)
    for i = 0, 5 do
        local bone = Instance.new("Part")
        bone.Size = Vector3.new(1,5,1)
        bone.Position = position + lookVector * (i * 5)
        bone.Anchored = true
        bone.CanCollide = false
        bone.Parent = workspace

        -- Урон при касании
        bone.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid and hit.Parent ~= game.Players.LocalPlayer.Character then
                humanoid:TakeDamage(damage)
            end
        end)
    end
end

-- Меч
local function giveSword()
    local sword = Instance.new("Tool")
    sword.Name = "Classic Sword"
    sword.Parent = game.Players.LocalPlayer.Backpack
    sword.Grip = CFrame.new()
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,4,1)
    handle.Parent = sword
    sword.Activated:Connect(function()
        for _, target in pairs(workspace:GetChildren()) do
            if target:FindFirstChild("Humanoid") and target ~= game.Players.LocalPlayer.Character then
                if (target.HumanoidRootPart.Position - sword.Handle.Position).Magnitude < 5 then
                    target.Humanoid:TakeDamage(50)
                end
            end
        end
    end)
end

-- Музыка Last Breath Phase 2
local music = Instance.new("Sound", workspace)
music.SoundId = "rbxassetid://13080517063" -- Айди музыки
music.Looped = true
music:Play()

-- Примеры спавна
local player = game.Players.LocalPlayer
spawnBlaster(player.Character.Head.Position + Vector3.new(0,5,0), Color3.new(1,0,0), 30)
spawnBoneWall(player.Character.Head.Position + Vector3.new(0,0,5), player.Character.Head.CFrame.LookVector, 25)
giveSword
