-- Last Breath Phase 2 Abilities (Script Example)
-- Авторская заготовка: вставь в GitHub и подключай через loadstring

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

-- Музыка
local Music = Instance.new("Sound")
Music.Name = "LastBreathPhase2"
Music.SoundId = "rbxassetid://9034277221" -- Last Breath Phase 2 Music (Roblox Audio)
Music.Volume = 5
Music.Looped = true
Music.Parent = SoundService

-- GUI
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SansGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,300)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = true

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,0,0)
close.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Кнопка: Запуск музыки
local musicBtn = Instance.new("TextButton", frame)
musicBtn.Size = UDim2.new(0,200,0,40)
musicBtn.Position = UDim2.new(0,20,0,50)
musicBtn.Text = "Play Music"
musicBtn.MouseButton1Click:Connect(function()
	if Music.IsPlaying then
		Music:Stop()
		musicBtn.Text = "Play Music"
	else
		Music:Play()
		musicBtn.Text = "Stop Music"
	end
end)

-- ТЕКСТУРЫ (пример)
local assets = {
	blaster = "rbxassetid://7072634770", -- Gaster Blaster Model Texture
	bone = "rbxassetid://6023426923", -- Bone
	boneWall = "rbxassetid://6022668898", -- Wall of Bones
	boneSword = "rbxassetid://6026312704", -- Bone Sword
	shield = "rbxassetid://7072711500" -- Blue Shield
}

-- ⚡ Атаки (пример упрощённый)
function spawnBlaster(target)
	local blaster = Instance.new("Part")
	blaster.Size = Vector3.new(4,4,4)
	blaster.Anchored = true
	blaster.CFrame = target.CFrame * CFrame.new(0,10,-10)
	local decal = Instance.new("Decal", blaster)
	decal.Texture = assets.blaster
	blaster.Parent = workspace
	
	-- Лазер
	local laser = Instance.new("Part")
	laser.Size = Vector3.new(1,1,30)
	laser.Anchored = true
	laser.BrickColor = BrickColor.new("Really red")
	laser.CFrame = blaster.CFrame * CFrame.new(0,0,-15)
	laser.Parent = workspace
	
	game:GetService("Debris"):AddItem(blaster, 3)
	game:GetService("Debris"):AddItem(laser, 1)
end

-- Пример: привязать к кнопке
local blasterBtn = Instance.new("TextButton", frame)
blasterBtn.Size = UDim2.new(0,200,0,40)
blasterBtn.Position = UDim2.new(0,20,0,100)
blasterBtn.Text = "Spawn Blaster"
blasterBtn.MouseButton1Click:Connect(function()
	local target = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if target then
		spawnBlaster(target)
	end
end)
