-- Last Breath Sans GUI (Phase 2)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- создаём GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true

-- функция создания кнопок
local function makeButton(name, pos, func)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(func)
    return btn
end

-- функция урона
local function dealDamage(part, dmg)
    part.Touched:Connect(function(hit)
        local hum = hit.Parent:FindFirstChild("Humanoid")
        if hum and hit.Parent ~= LocalPlayer.Character then
            hum:TakeDamage(dmg)
        end
    end)
end

-- 1. Кость (Bone)
local function spawnBone()
    local char = LocalPlayer.Character
    if not char then return end

    local bone = Instance.new("Part")
    bone.Size = Vector3.new(1, 4, 1)
    bone.Position = char.Head.Position + Vector3.new(0, 3, -5)
    bone.BrickColor = BrickColor.new("Institutional white")
    bone.Anchored = false
    bone.CanCollide = true
    bone.Parent = workspace

    local mesh = Instance.new("SpecialMesh", bone)
    mesh.MeshType = Enum.MeshType.Brick
    mesh.Scale = Vector3.new(0.5, 2, 0.5)

    dealDamage(bone, 20)

    game:GetService("Debris"):AddItem(bone, 5)
end

-- 2. Бластер (Gaster Blaster)
local function spawnBlaster()
    local char = LocalPlayer.Character
    if not char then return end

    local blaster = Instance.new("Part")
    blaster.Size = Vector3.new(2, 2, 6)
    blaster.Position = char.Head.Position + Vector3.new(0, 3, -10)
    blaster.BrickColor = BrickColor.new("Really black")
    blaster.Anchored = true
    blaster.Parent = workspace

    local beam = Instance.new("Part")
    beam.Size = Vector3.new(1, 1, 20)
    beam.Position = blaster.Position + Vector3.new(0, 0, -10)
    beam.BrickColor = BrickColor.new("Really red")
    beam.Anchored = true
    beam.Parent = workspace

    dealDamage(beam, 50)

    game:GetService("Debris"):AddItem(blaster, 2)
    game:GetService("Debris"):AddItem(beam, 2)
end

-- 3. Щит (Shield)
local shieldActive = false
local function toggleShield()
    local char = LocalPlayer.Character
    if not char then return end
    if shieldActive then
        if char:FindFirstChild("BoneShield") then
            char.BoneShield:Destroy()
        end
        shieldActive = false
    else
        local shield = Instance.new("ForceField", char)
        shield.Name = "BoneShield"
        shieldActive = true
    end
end

-- 4. Меч (Bone Sword)
local function spawnSword()
    local char = LocalPlayer.Character
    if not char then return end

    local sword = Instance.new("Tool")
    sword.Name = "Bone Sword"
    sword.RequiresHandle = true
    sword.Parent = LocalPlayer.Backpack

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5,5,0.5)
    handle.BrickColor = BrickColor.new("Institutional white")
    handle.Parent = sword

    local mesh = Instance.new("SpecialMesh", handle)
    mesh.MeshType = Enum.MeshType.Brick
    mesh.Scale = Vector3.new(0.3,1,0.3)

    dealDamage(handle, 30)
end

-- добавляем кнопки
makeButton("Summon Bone (20 dmg)", 10, spawnBone)
makeButton("Summon Blaster (50 dmg)", 60, spawnBlaster)
makeButton("Toggle Shield", 110, toggleShield)
makeButton("Bone Sword (30 dmg)", 160, spawnSword)
