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

-- Создаём GUI для выстрела
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local fireButton = Instance.new("TextButton", screenGui)
fireButton.Size = UDim2.new(0,100,0,50)
fireButton.Position = UDim2.new(0.9, -50, 0.9, -25)
fireButton.Text = "FIRE"

local fireRate = 0.05 -- очень быстрый выстрел
local canFire = true

local function shoot()
    if not canFire then return end
    canFire = false
    local bullet = Instance.new("Part")
    bullet.Size = Vector3.new(0.3,0.3,1)
    bullet.BrickColor = BrickColor.new("Bright red")
    bullet.Position = handle.Position + (handle.CFrame.lookVector * 2)
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.Parent = workspace

    local bv = Instance.new("BodyVelocity")
    bv.Velocity = handle.CFrame.lookVector * 500 -- скорость пули
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = bullet

    bullet.Touched:Connect(function(hit)
        local h = hit.Parent:FindFirstChild("Humanoid")
        if h and hit.Parent ~= character then
            h:TakeDamage(50)
            bullet:Destroy()
        end
    end)

    game:GetService("Debris"):AddItem(bullet, 3)
    
    wait(fireRate)
    canFire = true
end

fireButton.MouseButton1Click:Connect(shoot)
tool.Activated:Connect(shoot) -- также можно стрелять через Tool
