-- Скрипт для локального игрока 
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

-- Создаём оружие
local tool = Instance.new("Tool")
tool.Name = "M41C"
tool.RequiresHandle = true
tool.Parent = player.Backpack

-- Создаём ручку оружия (handle)
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1,1,3)
handle.Color = Color3.fromRGB(30,30,30)
handle.Parent = tool
tool.Handle = handle

-- Создаём скрипт для стрельбы
tool.Activated:Connect(function()
    local bullet = Instance.new("Part")
    bullet.Size = Vector3.new(0.3,0.3,1)
    bullet.BrickColor = BrickColor.new("Bright red")
    bullet.Position = handle.Position + (handle.CFrame.lookVector * 2)
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.Parent = workspace

    local bv = Instance.new("BodyVelocity")
    bv.Velocity = handle.CFrame.lookVector * 200 -- скорость пули
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = bullet

    -- Урон при касании
    bullet.Touched:Connect(function(hit)
        local h = hit.Parent:FindFirstChild("Humanoid")
        if h and hit.Parent ~= character then
            h:TakeDamage(50) -- 50 урона
            bullet:Destroy()
        end
    end)

    -- Уничтожение пули через 3 секунды
    game:GetService("Debris"):AddItem(bullet, 3)
end)
