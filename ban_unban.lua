-- 🚀 Самонаводящаяся ракета (одна на выстрел)
-- Работает в LocalScript (StarterPlayerScripts или через loadstring)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ===== ФУНКЦИЯ СОЗДАНИЯ РАКЕТЫ =====
local function spawnMissile(target)
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end

    local missile = Instance.new("Part")
    missile.Size = Vector3.new(1,1,3)
    missile.BrickColor = BrickColor.new("Really red")
    missile.Material = Enum.Material.Neon
    missile.Anchored = false
    missile.CanCollide = false
    missile.CFrame = LocalPlayer.Character.PrimaryPart.CFrame
        + (LocalPlayer.Character.PrimaryPart.CFrame.LookVector * 5)
        + Vector3.new(0,3,0)
    missile.Parent = workspace

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = missile

    -- Наведение
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") then
            local dir = (target.HumanoidRootPart.Position - missile.Position).Unit
            bv.Velocity = dir * 120

            if (missile.Position - target.HumanoidRootPart.Position).Magnitude < 5 then
                -- ВЗРЫВ
                local explosion = Instance.new("Explosion")
                explosion.Position = missile.Position
                explosion.BlastRadius = 6
                explosion.BlastPressure = 0
                explosion.Parent = workspace

                -- Уничтожение цели
                if target ~= LocalPlayer.Character then
                    target.Humanoid.Health = 0
                end

                missile:Destroy()
                connection:Disconnect()
            end
        else
            missile:Destroy()
            connection:Disconnect()
        end
    end)
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0,200,0,120)
frame.Position = UDim2.new(0,20,0,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🚀 Панель Ракет"
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.TextColor3 = Color3.fromRGB(255,255,255)

local btnPlayer = Instance.new("TextButton", frame)
btnPlayer.Size = UDim2.new(1,-20,0,40)
btnPlayer.Position = UDim2.new(0,10,0,40)
btnPlayer.Text = "Выстрелить по игроку"
btnPlayer.BackgroundColor3 = Color3.fromRGB(200,50,50)
btnPlayer.TextColor3 = Color3.new(1,1,1)

local btnNPC = Instance.new("TextButton", frame)
btnNPC.Size = UDim2.new(1,-20,0,40)
btnNPC.Position = UDim2.new(0,10,0,85)
btnNPC.Text = "Выстрелить по NPC"
btnNPC.BackgroundColor3 = Color3.fromRGB(50,50,200)
btnNPC.TextColor3 = Color3.new(1,1,1)

-- ===== ЛОГИКА =====
btnPlayer.MouseButton1Click:Connect(function()
    -- Найти ближайшего игрока
    local closest, dist = nil, math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = plr.Character
            end
        end
    end
    if closest then
        spawnMissile(closest)
    end
end)

btnNPC.MouseButton1Click:Connect(function()
    -- Найти ближайшего NPC (Model с Humanoid без игрока)
    local closest, dist = nil, math.huge
    for _,npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(npc) then
                local d = (npc.HumanoidRootPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = npc
                end
            end
        end
    end
    if closest then
        spawnMissile(closest)
    end
end)
