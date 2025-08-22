-- Parent this to StarterPlayerScripts
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Создаем M4
local function giveM4()
    local tool = Instance.new("Tool")
    tool.Name = "M41C"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack

    tool.Activated:Connect(function()
        local ray = Ray.new(player.Character.Head.Position, (mouse.Hit.p - player.Character.Head.Position).unit * 500)
        local part, pos = workspace:FindPartOnRay(ray, player.Character)
        if part and part.Parent:FindFirstChild("Humanoid") then
            part.Parent.Humanoid:TakeDamage(50)
        end
    end)
end

giveM4()

-- Прицел
local gui = Instance.new("ScreenGui")
gui.Name = "CrosshairGui"
gui.Parent = player:WaitForChild("PlayerGui")

local crosshair = Instance.new("Frame")
crosshair.Size = UDim2.new(0, 20, 0, 2)
crosshair.BackgroundColor3 = Color3.new(1, 0, 0)
crosshair.Position = UDim2.new(0.5, -10, 0.5, -1)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Parent = gui

local crosshairV = Instance.new("Frame")
crosshairV.Size = UDim2.new(0, 2, 0, 20)
crosshairV.BackgroundColor3 = Color3.new(1,0,0)
crosshairV.Position = UDim2.new(0.5, -1, 0.5, -10)
crosshairV.AnchorPoint = Vector2.new(0.5,0.5)
crosshairV.Parent = gui

-- Кнопка выстрела (для мобильных)
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(1, -120, 1, -60)
button.Text = "Fire"
button.Parent = gui
button.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
button.TextColor3 = Color3.new(1,1,1)

button.MouseButton1Click:Connect(function()
    local tool = player.Backpack:FindFirstChild("M41C") or player.Character:FindFirstChild("M41C")
    if tool then
        tool:Activate()
    end
end)
