-- Создаем M4 в инвентаре
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gun = Instance.new("Tool")
gun.Name = "M4"
gun.Parent = player.Backpack

-- Ствол
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1,1,4)
handle.Parent = gun

-- Прицел
local gui = Instance.new("ScreenGui", player.PlayerGui)
local crosshair = Instance.new("Frame")
crosshair.Size = UDim2.new(0, 4, 0, 4)
crosshair.BackgroundColor3 = Color3.new(1,0,0)
crosshair.Position = UDim2.new(0.5, -2, 0.5, -2)
crosshair.Parent = gui

-- Настройка стрельбы
local damage = 50
local fireRate = 0.1 -- скорость стрельбы

local canShoot = true
gun.Activated:Connect(function()
    if canShoot then
        canShoot = false
