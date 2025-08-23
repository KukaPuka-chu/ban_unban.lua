-- Last Breath Sans Phase 2 GUI Script
-- by ChatGPT & user

-- === НАСТРОЙКИ ===
local BoneTexture = "https://i.supaimg.com/43eab1e1-08f6-4a79-acf9-5b458354040a.png"
local MusicId = "rbxassetid://345052019" -- Last Breath Phase 2

-- === GUI ===
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SansPhase2"

local function makeButton(name, pos, text)
    local b = Instance.new("TextButton", gui)
    b.Name = name
    b.Text = text
    b.Size = UDim2.new(0, 150, 0, 40)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BorderSizePixel = 2
    return b
end

local wallBtn = makeButton("BoneWall", UDim2.new(0, 50, 0, 100), "🦴 Костяная стена")
local swordBtn = makeButton("BoneSword", UDim2.new(0, 50, 0, 150), "⚔️ Меч-кость")
local blasterBtn = makeButton("Blaster", UDim2.new(0, 50, 0, 200), "🔫 Гастер-бластер")
local shieldBtn = makeButton("Shield", UDim2.new(0, 50, 0, 250), "🛡️ Щит")
local musicBtn = makeButton("Music", UDim2.new(0, 50, 0, 300), "🎵 Включить фазу 2")

-- === ФУНКЦИИ ===

-- Костяная стена
wallBtn.MouseButton1Click:Connect(function()
    local wall = Instance.new("Part", workspace)
    wall.Anchored = true
    wall.Size = Vector3.new(20, 15, 1)
    wall.Position = player.Character.Head.Position + Vector3.new(0, 0, -10)
    local tex = Instance.new("Decal", wall)
    tex.Texture = BoneTexture
end)

-- Меч-кость
swordBtn.MouseButton1Click:Connect(function()
    local sword = Instance.new("Tool", player.Backpack)
    sword.Name = "Bone Sword"
    local handle = Instance.new("Part", sword)
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 4, 1)
    local tex = Instance.new("Decal", handle)
    tex.Texture = BoneTexture
    sword.RequiresHandle = true

    local dmg = 30
    sword.Activated:Connect(function()
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:TakeDamage(dmg) -- наносит урон
        end
    end)
end)

-- Самонаводящийся бластер
blasterBtn.MouseButton1Click:Connect(function()
    local target = nil
    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            target = plr.Character
            break
        end
    end
    if target then
        local blaster = Instance.new("Part", workspace)
        blaster.Size = Vector3.new(3, 3, 8)
        blaster.Anchored = true
        blaster.CFrame = player.Character.Head.CFrame * CFrame.new(0, 5, -10)
        local tex = Instance.new("Decal", blaster)
        tex.Texture = BoneTexture

        task.wait(1)
        local beam = Instance.new("Part", workspace)
        beam.Anchored = true
        beam.Size = Vector3.new(1,1, (player:DistanceFromCharacter(target.HumanoidRootPart.Position)))
        beam.CFrame = CFrame.new(blaster.Position, target.HumanoidRootPart.Position)
        beam.Color = Color3.fromRGB(255,255,255)
        game:GetService("Debris"):AddItem(beam, 0.5)

        target.Humanoid:TakeDamage(40)
    end
end)

-- Щит
shieldBtn.MouseButton1Click:Connect(function()
    local shield = Instance.new("Part", workspace)
    shield.Anchored = true
    shield.Size = Vector3.new(10,10,1)
    shield.Position = player.Character.Head.Position + Vector3.new(0,0,5)
    local tex = Instance.new("Decal", shield)
    tex.Texture = BoneTexture
    game:GetService("Debris"):AddItem(shield, 5)
end)

-- Музыка
musicBtn.MouseButton1Click:Connect(function()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = MusicId
    sound.Looped = true
    sound:Play()
end)
