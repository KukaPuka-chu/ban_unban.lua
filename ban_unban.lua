-- Исправленный скрипт: нормальный радар + ракеты не убивают игрока

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "RocketSystem"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local BtnPlayers = Instance.new("TextButton", MainFrame)
BtnPlayers.Size = UDim2.new(1, -10, 0, 40)
BtnPlayers.Position = UDim2.new(0, 5, 0, 10)
BtnPlayers.Text = "🎯 Навести на игроков"

local BtnNPC = Instance.new("TextButton", MainFrame)
BtnNPC.Size = UDim2.new(1, -10, 0, 40)
BtnNPC.Position = UDim2.new(0, 5, 0, 60)
BtnNPC.Text = "👾 Навести на NPC"

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(1, -10, 0, 30)
CloseBtn.Position = UDim2.new(0, 5, 0, 110)
CloseBtn.Text = "❌ Скрыть"
local hidden = false
CloseBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    MainFrame.Visible = not hidden
end)

-- === Радар ===
local Radar = Instance.new("Frame", ScreenGui)
Radar.Size = UDim2.new(0, 200, 0, 200)
Radar.Position = UDim2.new(0.8, 0, 0.05, 0)
Radar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Radar.Active = true
Radar.Draggable = true

local RadarLabel = Instance.new("TextLabel", Radar)
RadarLabel.Size = UDim2.new(1, 0, 0, 20)
RadarLabel.Text = "📡 Радар"
RadarLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RadarLabel.TextColor3 = Color3.fromRGB(255,255,255)

-- Размер радара и масштаб
local radarSize = 200
local radarRange = 100 -- радиус обнаружения в студийных единицах

-- === Ракеты ===
local function createRocket(target)
    local rocket = Instance.new("Part", workspace)
    rocket.Shape = Enum.PartType.Cylinder
    rocket.Size = Vector3.new(1,1,4)
    rocket.CFrame = LocalPlayer.Character.Head.CFrame
    rocket.BrickColor = BrickColor.new("Really red")
    rocket.Anchored = false
    rocket.CanCollide = false

    local bv = Instance.new("BodyVelocity", rocket)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)

    -- Наводка
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if target and target.Parent and target:FindFirstChild("HumanoidRootPart") then
            local dir = (target.HumanoidRootPart.Position - rocket.Position).unit * 100
            bv.Velocity = dir
        else
            conn:Disconnect()
        end
    end)

    -- Урон при касании
    rocket.Touched:Connect(function(hit)
        -- Не наносим урон себе
        if hit:IsDescendantOf(LocalPlayer.Character) then return end  

        local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:TakeDamage(100)
        end
        local explosion = Instance.new("Explosion", workspace)
        explosion.Position = rocket.Position
        explosion.BlastRadius = 5
        explosion.BlastPressure = 5000
        rocket:Destroy()
    end)
end

-- Кнопки запуска
BtnPlayers.MouseButton1Click:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            createRocket(plr.Character)
        end
    end
end)

BtnNPC.MouseButton1Click:Connect(function()
    for _,npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
            createRocket(npc)
        end
    end
end)

-- === Обновление радара ===
RunService.Heartbeat:Connect(function()
    for _,c in pairs(Radar:GetChildren()) do
        if c:IsA("Frame") and c.Name == "Dot" then
            c:Destroy()
        end
    end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos = plr.Character.HumanoidRootPart.Position
            local relative = (pos - root.Position) / radarRange -- нормализуем по дальности
            local x = 0.5 + relative.X * 0.5
            local y = 0.5 + relative.Z * 0.5 -- Z вместо Y (вид сверху)

            if x >= 0 and x <= 1 and y >= 0 and y <= 1 then
                local dot = Instance.new("Frame", Radar)
                dot.Size = UDim2.new(0,5,0,5)
                dot.Name = "Dot"
                dot.BackgroundColor3 = (plr == LocalPlayer) and Color3.new(0,1,0) or Color3.new(1,0,0)
                dot.Position = UDim2.new(x, -2, y, -2)
            end
        end
    end
end)
