local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Прицел
local crosshair = Instance.new("ImageLabel", gui)
crosshair.Size = UDim2.new(0,50,0,50)
crosshair.Position = UDim2.new(0.5,-25,0.5,-25)
crosshair.BackgroundTransparency = 1
crosshair.Image = "http://www.roblox.com/asset/?id=6031077289" -- пример прицела

-- Кнопка выстрела
local fireButton = Instance.new("TextButton", gui)
fireButton.Size = UDim2.new(0,100,0,100)
fireButton.Position = UDim2.new(0.85,0,0.75,0)
fireButton.Text = "FIRE"
fireButton.TextScaled = true

-- Закрываемый GUI
local closeButton = Instance.new("TextButton", gui)
closeButton.Size = UDim2.new(0,50,0,50)
closeButton.Position = UDim2.new(0.95, -50, 0, 0)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Настройки стрельбы
local fireRate = 0.1
local damage = 50
local canFire = true

local function shoot()
    if not canFire then return end
    canFire = false

    local bullet = Instance.new("Part", workspace)
    bullet.Size = Vector3.new(0.3,0.3,1)
    bullet.CFrame = player.Character.Head.CFrame
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.BrickColor = BrickColor.new("Bright blue")

    local bv = Instance.new("BodyVelocity", bullet)
    bv.Velocity = player.Character.Head.CFrame.LookVector * 300
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)

    bullet.Touched:Connect(function(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid and hit.Parent ~= player.Character then
            humanoid:TakeDamage(damage)
            bullet:Destroy()
        end
    end)

    game:GetService("Debris"):AddItem(bullet, 3)
    wait(fireRate)
    canFire = true
end

fireButton.MouseButton1Click:Connect(shoot)
