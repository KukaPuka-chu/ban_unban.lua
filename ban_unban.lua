--// Fling GUI Script
-- вставь в LocalScript в StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FlingGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Fling Players"
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.TextColor3 = Color3.new(1,1,1)

-- Кнопка свернуть
local MinBtn = Instance.new("TextButton", Frame)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-35,0,0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)

-- Кнопка для открытия после сворачивания
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,50,0,30)
OpenBtn.Position = UDim2.new(0,50,0,50)
OpenBtn.Text = "Open"
OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)

MinBtn.MouseButton1Click:Connect(function()
	Frame.Visible = false
	OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
	Frame.Visible = true
	OpenBtn.Visible = false
end)

-- Список игроков
local PlayerList = Instance.new("ScrollingFrame", Frame)
PlayerList.Size = UDim2.new(1,0,1,-30)
PlayerList.Position = UDim2.new(0,0,0,30)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)

local UIList = Instance.new("UIListLayout", PlayerList)

-- Функция обновления списка
local function RefreshList()
	for _,v in pairs(PlayerList:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local Btn = Instance.new("TextButton", PlayerList)
			Btn.Size = UDim2.new(1,-5,0,30)
			Btn.Text = plr.Name
			Btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
			Btn.TextColor3 = Color3.new(1,1,1)

			Btn.MouseButton1Click:Connect(function()
				-- Fling
				local char = LocalPlayer.Character
				local targetChar = plr.Character
				if char and targetChar and char:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
					local root = char.HumanoidRootPart
					local targetRoot = targetChar.HumanoidRootPart

					-- сохраняем позицию
					local oldCFrame = root.CFrame

					-- телепорт к цели
					root.CFrame = targetRoot.CFrame + Vector3.new(0,2,0)

					-- толчок
					local bv = Instance.new("BodyVelocity", root)
					bv.Velocity = Vector3.new(9999,9999,9999)
					bv.MaxForce = Vector3.new(1e9,1e9,1e9)
					game:GetService("Debris"):AddItem(bv, 0.2)

					wait(0.2)

					-- возврат на место
					root.CFrame = oldCFrame
				end
			end)
		end
	end
end

RefreshList()
Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(RefreshList)
