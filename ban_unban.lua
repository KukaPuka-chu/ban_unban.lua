local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

-- ===========================
-- Музыка Undertale Last Brick Phase 2
-- ===========================
local music = Instance.new("Sound")
music.SoundId = "rbxassetid://5700464468"  -- Phase 2
music.Looped = true
music.Volume = 1
music.Parent = Workspace
music:Play()

-- ===========================
-- Функция урона
-- ===========================
local function applyDamage(hit, dmg, owner)
    local character = hit.Parent
    if character and character:FindFirstChild("Humanoid") then
        -- Игрок не получает урон от своих объектов
        if owner and character == owner.Character then return end
        character.Humanoid:TakeDamage(dmg)
    end
end

-- ===========================
-- Гастер-бластер
-- ===========================
local function spawnBlaster(position, target, owner)
    local blaster = Instance.new("Part")
    blaster.Size = Vector3.new(1,1,1)
    blaster.Position = position
    blaster.Anchored = true
    blaster.CanCollide = false
    blaster.BrickColor = BrickColor.new("Bright blue")
    blaster.Parent = Workspace

    local dmgPerSecond = 30
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not blaster or not blaster.Parent then connection:Disconnect() return end
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            blaster.Position = blaster.Position:Lerp(target.Character.HumanoidRootPart.Position, 0.1)
            -- Проверка касания
            for _, part in pairs(Workspace:GetChildren()) do
                if part:IsA("Model") and part:FindFirstChild("Humanoid") then
                    for _, p in pairs(part:GetChildren()) do
                        if p:IsA("BasePart") and (p.Position - blaster.Position).Magnitude < 2 then
                            applyDamage(p, dmgPerSecond * dt, owner)
                        end
                    end
                end
            end
        end
    end)
    Debris:AddItem(blaster, 10)
end

-- ===========================
-- Стена из костей
-- ===========================
local function spawnBoneWall(startPos, direction, owner)
    local wall = Instance.new("Part")
    wall.Size = Vector3.new(1,5,0.5)
    wall.Position = startPos
    wall.Anchored = true
    wall.CanCollide = false
    wall.BrickColor = BrickColor.new("White")
    wall.Parent = Workspace

    local speed = 10
    local dmg = 30

    local t = 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        wall.Position = wall.Position + direction.Unit * speed * dt
        -- Проверка касания
        for _, part in pairs(Workspace:GetChildren()) do
            if part:IsA("Model") and part:FindFirstChild("Humanoid") then
                for _, p in pairs(part:GetChildren()) do
                    if p:IsA("BasePart") and (p.Position - wall.Position).Magnitude < 2 then
                        applyDamage(p, dmg * dt, owner)
                    end
                end
            end
        end
        if t > 5 then
            connection:Disconnect()
            wall:Destroy()
        end
    end)
end

-- ===========================
-- Меч
-- ===========================
local function spawnSword(position, owner)
    local sword = Instance.new("Part")
    sword.Size = Vector3.new(0.5,4,0.5)
    sword.Position = position
    sword.Anchored = true
    sword.CanCollide = false
    sword.BrickColor = BrickColor.new("Really red")
    sword.Parent = Workspace

    local dmg = 50
    local t = 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        -- Проверка касания
        for _, part in pairs(Workspace:GetChildren()) do
            if part:IsA("Model") and part:FindFirstChild("Humanoid") then
                for _, p in pairs(part:GetChildren()) do
                    if p:IsA("BasePart") and (p.Position - sword.Position).Magnitude < 2 then
                        applyDamage(p, dmg * dt, owner)
                    end
                end
            end
        end
        if t > 5 then
            connection:Disconnect()
            sword:Destroy()
        end
    end)
end

-- ===========================
-- Примеры спавна
-- ===========================
-- Гастер-бластер на ближайшего врага
spawnBlaster(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,5,0), nil, LocalPlayer)

-- Стена из костей вперед, куда смотрит игрок
spawnBoneWall(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,0,0),
              LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector,
              LocalPlayer)

-- Меч спавн перед игроком
spawnSword(LocalPlayer.Character.HumanoidRootPart.Position + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*3, LocalPlayer)
