local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =====================================
-- Настройки урона
-- =====================================
local GasterDamagePerSecond = 30
local BoneDamage = 20
local SwordDamage = 25

-- =====================================
-- Гастер-бластеры (самонаводящиеся)
-- =====================================
RunService.Stepped:Connect(function(deltaTime)
    for _, blast in pairs(workspace:WaitForChild("GasterBlasters"):GetChildren()) do
        if blast:IsA("Part") then
            -- выбираем цель, исключая себя
            local target = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    target = player
                    break
                end
            end
            
            if target then
                -- самонаведение
                local direction = (target.Character.HumanoidRootPart.Position - blast.Position).Unit
                blast.CFrame = blast.CFrame + direction * (blast:FindFirstChild("Speed") and blast.Speed.Value or 30) * deltaTime
                
                -- урон при касании
                local hitHumanoid = target.Character:FindFirstChild("Humanoid")
                if hitHumanoid and (blast.Position - target.Character.HumanoidRootPart.Position).Magnitude < 5 then
                    hitHumanoid:TakeDamage(GasterDamagePerSecond * deltaTime)
                end
            end
        end
    end
end)

-- =====================================
-- Стена из костей
-- =====================================
workspace.ChildAdded:Connect(function(child)
    if child.Name == "BoneWall" and child:IsA("Part") then
        -- сохраняем направление игрока, который её создал
        local creator = child:FindFirstChild("Creator")  -- ссылка на игрока
        local moveDirection = Vector3.new(0,0,1)  -- по умолчанию вперед
        if creator and creator.Value and creator.Value.Character and creator.Value.Character:FindFirstChild("HumanoidRootPart") then
            moveDirection = creator.Value.Character.HumanoidRootPart.CFrame.LookVector
        end

        -- урон при касании
        child.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid and hit.Parent ~= LocalPlayer.Character then
                humanoid:TakeDamage(BoneDamage)
            end
        end)

        -- движение в направлении игрока
        RunService.Stepped:Connect(function(deltaTime)
            child.CFrame = child.CFrame + moveDirection * 20 * deltaTime
        end)
    end
end)

-- =====================================
-- Меч
-- =====================================
local sword = workspace:WaitForChild("Sword")
sword.Touched:Connect(function(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if humanoid and hit.Parent ~= LocalPlayer.Character then
        humanoid:TakeDamage(SwordDamage)
    end
end)

-- =====================================
-- Музыка (Undertale Last Brick Phase 2)
-- =====================================
local music = Instance.new("Sound")
music.SoundId = "rbxassetid://5700464468"  -- ID Phase 2
music.Looped = true
music.Volume = 1
music.Parent = workspace
music:Play()
