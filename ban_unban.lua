local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RocketGUI"

-- Таблица GUI
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,100)
frame.Position = UDim2.new(0.5,-100,0.8,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- Кнопка Ракета
local rocketButton = Instance.new("TextButton", frame)
rocketButton.Size = UDim2.new(0,180,0,40)
rocketButton.Position = UDim2.new(0,10,0,10)
rocketButton.Text = "Ракета"

-- Кнопка закрытия
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0,40,0,40)
closeButton.Position = UDim2.new(0.75,0,0,10)
closeButton.Text = "X"

closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Функция создания ракеты
local function spawnRocket()
    local rocket = Instance.new("Part", workspace)
    rocket.Size = Vector3.new(2,2,6)
    rocket.BrickColor = BrickColor.new("Bright red")
    rocket.Position = player.Character.Head.Position + Vector3.new(0,5,0)
    rocket.Anchored = false
    rocket.CanCollide = true

    local bodyVelocity = Instance.new("BodyVelocity", rocket)
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)

    local function findTarget()
        local nearest
        local minDist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (rocket.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    nearest = p.Character.HumanoidRootPart
                    minDist = dist
                end
            end
        end
        return nearest
    end

    local connection
    connection = RunService.Heartbeat:Connect(function()
        local target = findTarget()
        if target then
            local dir = (target.Position - rocket.Position).Unit
            bodyVelocity.Velocity = dir * 100 -- скорость ракеты
        end

        -- Взрыв при столкновении с землей или объектом
        local ray = Ray.new(rocket.Position, Vector3.new(0,-1,0)*1)
        local hit = workspace:FindPartOnRay(ray, rocket)
        if hit then
            local explosion = Instance.new("Explosion", workspace)
            explosion.Position = rocket.Position
            explosion.BlastRadius = 10
            explosion.BlastPressure = 50000
            Debris:AddItem(rocket,0)
            connection:Disconnect()
        end
    end)
end

rocketButton.MouseButton1Click:Connect(spawnRocket)
