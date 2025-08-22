-- ⚡ Скрипт: Самонаводящиеся ракеты с кнопками и защитой от самоповреждения
-- Работает в LocalScript

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Функция запуска ракеты
local function spawnMissile(target)
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end

    -- создаём модель ракеты
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
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if target and target.Parent and target:FindFirstChild("HumanoidRootPart") then
            local dir = (target.HumanoidRootPart.Position - missile.Position).Unit
            bv.Velocity = dir * 100
            -- Проверка столкновения
            if (missile.Position - target.HumanoidRootPart.Position).Magnitude < 5 then
                -- Взрыв
                local explosion = Instance.new("Explosion")
                explosion.Position = missile.Position
                explosion.BlastRadius = 8
                explosion.BlastPressure = 0
                explosion.Parent = workspace

                -- Урон только другим, не себе
                explosion.Hit:Connect(function(part)
                    local char = part:FindFirstAncestorOfClass("Model")
                    if char and char:FindFirstChild("Humanoid") then
                        if char ~= LocalPlayer.Character then
                            char.Humanoid:TakeDamage(100)
                        end
                    end
                end)

                missile:Destroy()
                connection:Disconnect()
            end
        else
            missile:Destroy()
            connection:Disconnect()
        end
    end)
end

-- UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

local btnPlayers = Instance.new("TextButton", ScreenGui)
btnPlayers.Size = UDim2.new(0,150,0,50)
btnPlayers.Position = UDim2.new(0,20,0,200)
btnPlayers.Text = "🚀 Ракета (Игроки)"
btnPlayers.BackgroundColor3 = Color3.fromRGB(200,50,50)

local btnNPC = Instance.new("TextButton", ScreenGui)
btnNPC.Size = UDim2.new(0,150,0,50)
btnNPC.Position = UDim2.new(0,20,0,260)
btnNPC.Text = "🚀 Ракета (NPC)"
btnNPC.BackgroundColor3 = Color3.fromRGB(50,50,200)

-- Логика кнопок
btnPlayers.MouseButton1Click:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            spawnMissile(plr.Character)
        end
    end
end)

btnNPC.MouseButton1Click:Connect(function()
    for _,npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(npc) then -- не игрок
                spawnMissile(npc)
            end
        end
    end
end)
