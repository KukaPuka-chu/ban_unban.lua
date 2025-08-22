loadstring([==[
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
mainFrame.Parent = ScreenGui

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,5)
uiList.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "Закрыть"
closeButton.Size = UDim2.new(1,0,0,30)
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Utility function for damage
function applyDamage(part, damage)
    RunService.RenderStepped:Connect(function()
        if part.Parent then
            for _,player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local hum = player.Character.Humanoid
                    if (hum.RootPart.Position - part.Position).magnitude < 5 then
                        hum:TakeDamage(damage * RunService.RenderStepped:Wait())
                    end
                end
            end
        end
    end)
end

-- Gaster Blaster Button
local blasterButton = Instance.new("TextButton")
blasterButton.Text = "Гастер-Бластер"
blasterButton.Size = UDim2.new(1,0,0,30)
blasterButton.Parent = mainFrame

blasterButton.MouseButton1Click:Connect(function()
    local blaster = Instance.new("Part")
    blaster.Size = Vector3.new(3,3,3)
    blaster.Position = localPlayer.Character.Head.Position + localPlayer.Character.Head.CFrame.LookVector * 5
    blaster.Anchored = true
    blaster.CanCollide = false
    blaster.Parent = workspace

    local decal = Instance.new("Decal", blaster)
    decal.Texture = "https://i.supaimg.com/43eab1e1-08f6-4a79-acf9-5b458354040a.png"
    decal.Face = Enum.NormalId.Front

    local blasterSound = Instance.new("Sound", blaster)
    blasterSound.SoundId = "rbxassetid://911045681"
    blasterSound:Play()

    applyDamage(blaster, 30)

    RunService.RenderStepped:Connect(function()
        if blaster.Parent then
            local direction = (mouse.Hit.Position - blaster.Position).unit
            blaster.Position = blaster.Position + direction * 0.5
        end
    end)
end)

-- Bone Wall Button
local wallButton = Instance.new("TextButton")
wallButton.Text = "Стена из костей"
wallButton.Size = UDim2.new(1,0,0,30)
wallButton.Parent = mainFrame

wallButton.MouseButton1Click:Connect(function()
    local wall = Instance.new("Part")
    wall.Size = Vector3.new(1,5,10)
    wall.Position = localPlayer.Character.Head.Position + localPlayer.Character.Head.CFrame.LookVector * 10
    wall.Anchored = true
    wall.CanCollide = false
    wall.BrickColor = BrickColor.new("White")
    wall.Parent = workspace

    applyDamage(wall, 30)

    RunService.RenderStepped:Connect(function()
        if wall.Parent then
            local direction = localPlayer.Character.Head.CFrame.LookVector
            wall.Position = wall.Position + direction * 0.5
        end
    end)
end)

-- Sword Button
local swordButton = Instance.new("TextButton")
swordButton.Text = "Меч"
swordButton.Size = UDim2.new(1,0,0,30)
swordButton.Parent = mainFrame

swordButton.MouseButton1Click:Connect(function()
    local sword = Instance.new("Part")
    sword.Size = Vector3.new(1,5,1)
    sword.Position = localPlayer.Character.Head.Position + localPlayer.Character.Head.CFrame.LookVector * 5
    sword.Anchored = false
    sword.CanCollide = false
    sword.BrickColor = BrickColor.new("Bright red")
    sword.Parent = workspace

    applyDamage(sword, 30)

    sword.CFrame = localPlayer.Character.HumanoidRootPart.CFrame
end)

-- Music Button
local musicButton = Instance.new("TextButton")
musicButton.Text = "Музыка Last Breath Phase 2"
musicButton.Size = UDim2.new(1,0,0,30)
musicButton.Parent = mainFrame

local music
musicButton.MouseButton1Click:Connect(function()
    if not music then
        music = Instance.new("Sound", workspace)
        music.SoundId = "rbxassetid://233264309" -- замените на свой ID
        music.Looped = true
        music:Play()
    else
        if music.IsPlaying then
            music:Stop()
        else
            music:Play()
        end
    end
end)
]==])()
