local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Fling Players"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)

local minBtn = Instance.new("TextButton", frame)
minBtn.Text = "-"
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,0)
minBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)

local openBtn = Instance.new("TextButton", gui)
openBtn.Text = "Open"
openBtn.Size = UDim2.new(0,50,0,30)
openBtn.Position = UDim2.new(0,50,0,50)
openBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
openBtn.Visible = false

minBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)

-- Player list
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,-30)
scroll.Position = UDim2.new(0,0,0,30)
local layout = Instance.new("UIListLayout", scroll)

local function refreshList()
    scroll:ClearAllChildren()
    layout:Parent = scroll
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1,-5,0,30)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BackgroundColor3 = Color3.fromRGB(100,100,100)

            btn.MouseButton1Click:Connect(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local target = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if root and target then
                    local oldCF = root.CFrame
                    root.CFrame = oldCF -- остаёшься на месте

                    -- fling target
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.PlatformStand = true
                        target.AssemblyLinearVelocity = (target.Position - root.Position).Unit * 200 + Vector3.new(0, 50, 0)
                        local av = Instance.new("AngularVelocity", target)
                        av.AngularVelocity = Vector3.new(100,100,100)
                        av.MaxTorque = Vector3.new(1e5,1e5,1e5)
                        av.ReactionTorqueEnabled = false
                        Debris:AddItem(av, 0.5)
                        Debris:AddItem(hum, 0.5)
                    end
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()
